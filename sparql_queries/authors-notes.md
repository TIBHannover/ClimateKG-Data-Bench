# Authors Query

This notebook explores author contribution patterns in the ClimateKG graph by following the relationship between authors and chapters.

The live query uses the current Wikibase instance and authenticates with the project credentials for the off-web service:

- Username: `ckg`
- Password: `fairdata`

The core pattern is to deduplicate authors by `P20` (ClimateKG Author ID) and then inspect which chapters they contributed to via `P27`.

```sparql
PREFIX wd: <https://climatekg.tibwiki.io/entity/>
PREFIX wdt: <https://climatekg.tibwiki.io/prop/direct/>

SELECT ?author ?authorLabel ?chapter ?chapterLabel ?authorId
WHERE {
  ?author wdt:P20 ?authorId .
  ?author wdt:P27 ?chapter .
  ?chapter wdt:P1 wd:Q6 .

  SERVICE wikibase:label {
    bd:serviceParam wikibase:language "en".
  }
}
ORDER BY ?authorLabel ?chapterLabel
LIMIT 200
```

This is a good query-first starting point for author analysis because it lets us validate the graph schema before doing counting, collaboration, or network analysis.
