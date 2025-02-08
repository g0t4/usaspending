## metadata schema

Links:
- [Download](https://files.usaspending.gov/docs/USAspending-data-catalog.json)
- [Info](https://www.usaspending.gov/download_center/dataset_metadata)

```sh
cat USAspending-data-catalog.json | jq "keys"

cat USAspending-data-catalog.json | jq '.["@context"]'
# https://resources.data.gov/schemas/dcat-us/v1.1/schema/catalog.jsonld
cat USAspending-data-catalog.json | jq -r '.["@type"]'
# dcat:Catalog
cat USAspending-data-catalog.json | jq ".conformsTo"
# https://resources.data.gov/resources/dcat-us/
cat USAspending-data-catalog.json | jq ".describedBy"
# "https://project-open-data.cio.gov/v1.1/schema/catalog.json"
```

## metadata dataset

```sh

# fields per dataset:
cat USAspending-data-catalog.json | jq ".dataset[0] | keys"

# first dataset:
cat USAspending-data-catalog.json | jq ".dataset[0]"

# titles:
cat USAspending-data-catalog.json | jq ".dataset[].title"

# key fields:
cat USAspending-data-catalog.json | jq ".dataset[] | { title, description, describedBy, landingPage }"

```
