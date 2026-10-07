# Glossary Query

This notebook explores glossary terms in the ClimateKG graph by tracing how glossary entries are linked to the report hierarchy and concept structure.

The live query uses the current Wikibase instance and the authenticated SPARQL endpoint with the project credentials:

- Username: `ckg`
- Password: `fairdata`

The core pattern is to find terms of class `Q1` (glossary term) and then inspect which report or corpus items they are associated with through `P3`.

```sparql
PREFIX wd: <https://climatekg.tibwiki.io/entity/>
PREFIX wdt: <https://climatekg.tibwiki.io/prop/direct/>

SELECT ?term ?termLabel ?report ?reportLabel ?termType ?termTypeLabel
WHERE {
  ?term wdt:P1 wd:Q1 .
  ?term wdt:P3 ?report .
  OPTIONAL { ?term wdt:P1 ?termType . }

  SERVICE wikibase:label {
    bd:serviceParam wikibase:language "en".
  }
}
ORDER BY ?reportLabel ?termLabel
LIMIT 200
```

This gives a direct starting point for glossary analysis without assuming fixed item IDs or prior data tables.
