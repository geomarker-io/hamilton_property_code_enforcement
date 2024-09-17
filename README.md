**This repository is deprecated in favor of https://github.com/geomarker-io/parcel/property_code_enforcements**

# Hamilton County Property Code Enforcement

## About

This R code generates the **Hamilton County Property Code Enforcement** (`hamilton_property_code_enforcement`) data resource. A census tract-level rate of property code enforcements per household is derived from [code enforcement data](https://data.cincinnati-oh.gov/api/views/cncm-znd6/rows.csv?accessType=DOWNLOAD) from [CincyInsights](https://data.cincinnati-oh.gov/thriving-neighborhoods/Code-Enforcement/cncm-znd6) (contributed and maintained by [CAGIS](https://cagismaps.hamilton-co.org/cagisportal)).

See [metadata.md](./metadata.md) for detailed metadata and schema information.

## Accessing Data

Read this CSV file into R directly from the [release](https://github.com/geomarker-io/hamilton_property_code_enforcement/releases) with:

```
readr::read_csv("https://github.com/geomarker-io/hamilton_property_code_enforcement/releases/download/0.1.3/hamilton_property_code_enforcement.csv")
```

Metadata can be imported from the accompanying `tabular-data-resource.yaml` file by using [{CODECtools}](https://geomarker.io/CODECtools/).

## Data Details

#### Exclusions

Housing code violations with a `DATA_STATUS_DISPLAY` of "Closed - No Violation", "Closed - No Violations Found", "Duplicate Case", or "Closed - Duplicate Complaint" were excluded.

#### Rate per households

The number of households per tract was estimated by summing the number of households per block in each tract from the 2020 census.

#### Resources

- [City of Cincinnati code enforcement data dictionary](https://data.cincinnati-oh.gov/api/views/cncm-znd6/files/35440eee-1428-4bd9-9d98-a5935951dddf?download=true&filename=Code%20Enforcement%20-%203b.Data%20Dictionary.pdf) 
- [City of Cincinnati code enforcement guide](https://www.cincinnati-oh.gov/buildings/building-permit-forms-applications/application-forms/all-forms-handouts-checklists-alphabetical-list/code-enforcement-guide/) 
- [City of Cincinnati common housing code violations](https://www.cincinnati-oh.gov/buildings/building-permit-forms-applications/application-forms/all-forms-handouts-checklists-alphabetical-list/common-housing-code-violations/) 
