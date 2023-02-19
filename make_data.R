library(dplyr)
library(sf)
library(CODECtools)

code_enforcement_url <- "https://data.cincinnati-oh.gov/api/views/cncm-znd6/rows.csv?accessType=DOWNLOAD"

raw_data <-
  readr::read_csv(code_enforcement_url,
    col_types = readr::cols_only(
      SUB_TYPE_DESC = "character",
      NUMBER_KEY = "character",
      ENTERED_DATE = readr::col_datetime(format = "%m/%d/%Y %I:%M:%S %p"),
      FULL_ADDRESS = "character",
      LATITUDE = "numeric",
      LONGITUDE = "numeric",
      DATA_STATUS_DISPLAY = "character"
    )
  )

d <-
  raw_data |>
  filter(!DATA_STATUS_DISPLAY %in% c(
    "Closed - No Violation",
    "Closed - No Violations Found",
    "Duplicate Case",
    "Closed - Duplicate Complaint"
  )) |>
  mutate(SUB_TYPE_DESC = stringr::str_to_lower(SUB_TYPE_DESC)) |>
  st_as_sf(coords = c("LONGITUDE", "LATITUDE"), crs = 4326) |>
  st_transform(st_crs(cincy::tract_tigris_2020)) |>
  st_join(cincy::tract_tigris_2020) |>
  mutate(address = stringr::str_to_lower(FULL_ADDRESS))

## city_parcel_lookup <-
##   readr::read_csv("violations_likely.csv") |>
##   transmute(
##     address = stringr::str_squish(`FULL ADDRESS`),
##     parcel_id = PARCEL_NO
##   ) |>
##   group_by(address, parcel_id) |>
##   summarize(n = n()) |>
##   arrange(desc(n))

## city_violation_lookup <-
##   readr::read_csv("violations_likely.csv") |>
##   transmute(violation = stringr::str_to_lower(`VIOLATION TYPE`)) |>
##   dplyr::group_by(violation) |>
##   summarize(n = n()) |>
##   arrange(desc(n))

## d <- left_join(d, city_parcel_lookup, by = c("FULL_ADDRESS" = "address"), na_matches = "never")

d_tract <-
  d |>
  st_drop_geometry() |>
  nest_by(census_tract_id_2020) |>
  mutate(
    n_violations = nrow(data),
    date_min = as.Date(min(data$ENTERED_DATE)),
    date_max = as.Date(max(data$ENTERED_DATE)),
    n_days = date_max - date_min
  ) |>
  left_join(cincy::tract_tigris_2020, by = "census_tract_id_2020") |>
  select(-data) |>
  st_as_sf()

# calculate as number of violations per household
hh_per_tract <-
  tigris::blocks(39, 061, year = 2020) |>
  st_drop_geometry() |>
  group_by(census_tract_id_2020 = substr(GEOID20, 1, 11)) |>
  summarize(n_households = sum(HOUSING20))

d_tract <-
  d_tract |>
  left_join(hh_per_tract, by = "census_tract_id_2020") |>
  mutate(violations_per_household = n_violations / n_households)

d_tract |>
  st_drop_geometry() |>
  select(census_tract_id_2020, violations_per_household) |>
  ungroup() |>
  add_col_attrs(census_tract_id_2020, description = "census tract identifier") |>
  add_col_attrs(violations_per_household,
                description = "number of property code enforcements per household") |>
  add_attrs(name = "hamilton_property_code_enforcement",
            title = "Hamilton County Property Code Enforcement",
            version = "0.1",
            homepage = "https://geomarker.io/hamilton_property_code_enforcement") |>
  write_tdr_csv()
