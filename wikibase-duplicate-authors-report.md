# Wikibase Duplicate Author Items — Investigation Report

**Date:** 2026-06-09  
**Reported by:** kg-stats-dashboard notebook  
**Status:** Under investigation

---

## Summary

The local Wikibase instance contains **1,864 Q-items** with `P1 = Q3998` (Author class), when the expected count is **932** (matching `authors-ar6.csv`). This is an exact 2× duplication.

---

## Evidence

### SPARQL diagnostic queries run against `http://localhost:9999/bigdata/namespace/wdq/sparql`

```sparql
-- Query 1: COUNT(DISTINCT ?item) — returns 1864 (expected: 932)
PREFIX wdt: <http://localhost:8080/prop/direct/>
PREFIX wd:  <http://localhost:8080/entity/>
SELECT (COUNT(DISTINCT ?item) AS ?count)
WHERE { ?item wdt:P1 wd:Q3998 }
```
**Result:** `1864`

```sparql
-- Query 2: Nested SELECT DISTINCT subquery — also returns 1864
SELECT (COUNT(*) AS ?count)
WHERE {
  SELECT DISTINCT ?item
  WHERE { ?item wdt:P1 wd:Q3998 }
}
```
**Result:** `1864` — confirms 1864 **genuinely distinct entity URIs**, not a COUNT aggregation quirk.

```sparql
-- Query 3: COUNT DISTINCT P20 literal values — returns 932 (correct)
SELECT (COUNT(DISTINCT ?uid) AS ?count)
WHERE { ?item wdt:P20 ?uid }
```
**Result:** `932` ✓

### Confirmed Q-number ranges (two distinct import batches)

| Batch | Q-range | Authors |
|-------|---------|---------|
| **Original import** | Q3999 – Q4930 | AU0001 – AU0932 |
| **Duplicate import** | Q4932 – Q5863 | AU0001 – AU0932 (same data) |

Q4931 is not an author item (likely a different entity between the two imports).

### Full duplicate URI list

All 932 pairs are exported to **[`wikibase-duplicate-authors.csv`](wikibase-duplicate-authors.csv)** with columns:
`ClimateKG_Author_ID`, `Original_QID`, `Original_Item_URL`, `Duplicate_QID`, `Duplicate_Item_URL`, `Action`

Sample (first 10 rows):

| ClimateKG_Author_ID | Original_QID | Original Item | Duplicate_QID | Duplicate Item |
|---------------------|--------------|---------------|---------------|----------------|
| AU0001 | Q3999 | [Q3999](http://localhost:8080/wiki/Item:Q3999) | Q4932 | [Q4932](http://localhost:8080/wiki/Item:Q4932) |
| AU0002 | Q4000 | [Q4000](http://localhost:8080/wiki/Item:Q4000) | Q4933 | [Q4933](http://localhost:8080/wiki/Item:Q4933) |
| AU0003 | Q4001 | [Q4001](http://localhost:8080/wiki/Item:Q4001) | Q4934 | [Q4934](http://localhost:8080/wiki/Item:Q4934) |
| AU0004 | Q4002 | [Q4002](http://localhost:8080/wiki/Item:Q4002) | Q4935 | [Q4935](http://localhost:8080/wiki/Item:Q4935) |
| AU0005 | Q4003 | [Q4003](http://localhost:8080/wiki/Item:Q4003) | Q4936 | [Q4936](http://localhost:8080/wiki/Item:Q4936) |
| AU0006 | Q4004 | [Q4004](http://localhost:8080/wiki/Item:Q4004) | Q4937 | [Q4937](http://localhost:8080/wiki/Item:Q4937) |
| AU0007 | Q4005 | [Q4005](http://localhost:8080/wiki/Item:Q4005) | Q4938 | [Q4938](http://localhost:8080/wiki/Item:Q4938) |
| AU0008 | Q4006 | [Q4006](http://localhost:8080/wiki/Item:Q4006) | Q4939 | [Q4939](http://localhost:8080/wiki/Item:Q4939) |
| AU0009 | Q4007 | [Q4007](http://localhost:8080/wiki/Item:Q4007) | Q4940 | [Q4940](http://localhost:8080/wiki/Item:Q4940) |
| AU0010 | Q4008 | [Q4008](http://localhost:8080/wiki/Item:Q4008) | Q4941 | [Q4941](http://localhost:8080/wiki/Item:Q4941) |

*… 922 more rows in `wikibase-duplicate-authors.csv`*

### CSV source of truth
```
authors-ar6.csv: 1,164 rows, 932 unique ClimateKG_Author_ID values (AU0001–AU0932)
```

---

## Likely Cause

The author data was **imported into Wikibase twice**, creating two sets of Q-items for the same 932 authors. Each real author now has:
- One Q-item from the original import (e.g. `Q100`)
- One duplicate Q-item from a re-import (e.g. `Q4932`)

Both items have the same P20 (`ClimateKG Author ID`) literal value, P23 (gender), and P27 (chapter links).

---

## Scope — What Else May Be Affected

| Data type | Likely affected? | Verification query |
|-----------|------------------|--------------------|
| Authors (P1=Q3998) | **YES** — confirmed 1864 vs 932 | `COUNT(DISTINCT ?uid) WHERE { ?item wdt:P20 ?uid }` → use this |
| Chapters (P1=Q6) | Possibly — check Q6 count vs `Chapter_QID` in CSV | `COUNT(DISTINCT ?item) WHERE { ?item wdt:P1 wd:Q6 }` |
| DOIs (P10) | Possibly — check vs `bibliographic-ar6.csv` | `COUNT(DISTINCT ?doi) WHERE { ?item wdt:P10 ?doi }` |
| OpenAlex (P9) | Possibly | `COUNT(DISTINCT ?id) WHERE { ?item wdt:P9 ?id }` |
| Series/Reports | Possibly | Check vs `bibliographic-ar6.csv` Type=Series count |

**Note:** For any count that returns 2× the expected value, switch from counting entities (`?item`) to counting the **property value** (`?literal`) using `COUNT(DISTINCT ?literal)`.

---

## Investigation Steps

1. **Identify the two import batches** — find the Q-number ranges:
   ```sparql
   PREFIX wdt: <http://localhost:8080/prop/direct/>
   PREFIX wd:  <http://localhost:8080/entity/>
   SELECT ?item ?uid
   WHERE { ?item wdt:P1 wd:Q3998 . ?item wdt:P20 ?uid . }
   ORDER BY ?uid
   LIMIT 20
   ```
   Look for the same UID (e.g. `AU0001`) appearing under two different Q-numbers.

2. **Confirm which Q-range is the duplicate** — the higher-numbered range is likely the re-import. Check creation date or item structure.

3. **Check if duplicates share the same property values** — if yes, one set can safely be deleted:
   ```sparql
   PREFIX wdt: <http://localhost:8080/prop/direct/>
   SELECT ?uid (COUNT(?item) AS ?n)
   WHERE { ?item wdt:P20 ?uid }
   GROUP BY ?uid
   HAVING (?n > 1)
   ORDER BY ?uid
   LIMIT 10
   ```
   If every UID appears exactly twice, the duplicate set is systematic.

4. **Delete the duplicate batch** via the Wikibase UI or a bot script. The Q-items in the higher range (e.g. Q4932+) are likely the ones to remove.

5. **Re-run the dashboard notebook** after cleanup to confirm counts drop to 932.

---

## Temporary Workaround (Applied)

The `kg-stats-dashboard.ipynb` notebook currently uses:
```sparql
SELECT (COUNT(DISTINCT ?uid) AS ?count) WHERE { ?item wdt:P20 ?uid }
```
This counts **distinct P20 literal values** (`"AU0001"`, `"AU0002"`, etc.) rather than entity URIs, giving the correct count of **932** regardless of how many Q-items exist per author.

---

## Files Affected

- `research_data/data-vis/kg-stats-dashboard.ipynb` — workaround applied
- `research_data/data-vis/gender-distribution-simple.ipynb` — uses deduplication on P20 in Python; result unaffected
- `research_data/data-vis/authors-top-ten.ipynb` — uses CSV as primary source; result unaffected
