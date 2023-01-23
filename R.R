library(dplyr)

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
                  ))
