# Report Structure Query

This is the first working query for the planned "Report Structure" notebook. It uses the live ClimateKG Wikibase and extracts the hierarchy encoded through the `P3` property, which represents the current graph's parent/child structure.

## Endpoint

- Query UI: https://climatekg.tibwiki.io/query/
- SPARQL endpoint: https://climatekg.tibwiki.io/query/proxy/sparql

## Working query

```sparql
PREFIX wd: <https://climatekg.tibwiki.io/entity/>
PREFIX wdt: <https://climatekg.tibwiki.io/prop/direct/>

SELECT ?item ?itemLabel ?parent ?parentLabel ?itemType ?itemTypeLabel
WHERE {
  ?item wdt:P3 ?parent .
  OPTIONAL { ?item wdt:P1 ?itemType . }
  SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
}
ORDER BY ?parent ?itemLabel
LIMIT 200
```

## Why this query

- `wdt:P3` is the working parent/child relationship in the current graph.
- `?itemLabel` and `?parentLabel` expose readable names for the hierarchy.
- `?itemType` / `?itemTypeLabel` help distinguish the role or class of each item when present.
- The result is suitable for exploring report-series → report → chapter / section relationships in a notebook.

## Example result pattern

The live query returns rows in the form:

- `item`: a ClimateKG entity
- `itemLabel`: its human-readable title
- `parent`: its parent item in the hierarchy
- `parentLabel`: the parent title

This gives a direct graph view of the report structure without assuming a fixed Q-number mapping from earlier drafts.

## Next notebook step

The next refinement would be to add a small table summarising the hierarchy depth and then turn this into a notebook cell that renders a dataframe of the report structure with labels and counts.
