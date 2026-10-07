# Acronyms Query

This notebook checks whether acronym entries are currently represented in the live ClimateKG instance and how they relate to the report hierarchy.

The work follows the same query-first pattern used in the other notebooks in this series: verify the live graph, inspect the actual labels and properties in use, and only then build analysis around the result.

## Endpoint

- Query UI: https://climatekg.tibwiki.io/query/
- SPARQL endpoint: https://climatekg.tibwiki.io/query/proxy/sparql

## Authentication

The production endpoint is protected by the off-web basic-auth layer:

- Username: `ckg`
- Password: `fairdata`

The notebook uses the shared helper in `wikibase_auth.py` so it does not hardcode credentials in every query cell.

## Working query

```sparql
PREFIX wd: <https://climatekg.tibwiki.io/entity/>
PREFIX wdt: <https://climatekg.tibwiki.io/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?item ?itemLabel ?class ?classLabel ?report ?reportLabel
WHERE {
  ?item wdt:P1 ?class .
  ?class rdfs:label ?classLabel .
  FILTER(LANG(?classLabel) = "en" && ( ?classLabel = "Acronym" || ?classLabel = "Glossary term" || ?classLabel = "Category" ))
  OPTIONAL { ?item wdt:P3 ?report . }
  SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
}
ORDER BY ?classLabel ?itemLabel
LIMIT 50
```

## Why this query

- `wdt:P1` is used to fetch the type/class of each item.
- `rdfs:label` and `wikibase:label` let us see the human-readable class labels in English.
- The filter checks for the likely class names currently present in the graph: `Acronym`, `Glossary term`, and `Category`.
- `OPTIONAL { ?item wdt:P3 ?report . }` keeps the query useful even if an item is not attached to a report hierarchy node.
- This is intentionally a validation query: it confirms whether these types are actually present before building a richer acronym or glossary dataset.

## Interpretation

This notebook is designed to answer a very specific question:

- Do acronym-like entries already exist in the live ClimateKG data?
- If they do, what are they called and how are they linked to the report structure?
- If they do not, the result is still valuable: it tells us the graph does not currently expose those entries under the expected labels.

This is important because the live dataset is not assumed to match earlier drafts or older schema descriptions. The notebook is intentionally conservative and query-first.

## Next step after validation

Once a real acronym or glossary set is present in the graph, the same pattern can be extended to:

- count acronym entries by report
- compare acronym labels across report sections
- identify whether glossary and acronym terms share a common entity pattern
- surface a cleaner table for narrative analysis in the Quarto site
