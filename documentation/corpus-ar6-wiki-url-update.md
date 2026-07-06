# corpus-ar6.csv — Wiki URL Update

This document describes how the **WIKI** column (first column) of `research_data/data-xml-dtd/corpus-ar6.csv` was updated to use canonical PROD URLs sourced from Wikibase P5 values.

---

## Background

The WIKI column stores the MediaWiki page URL for each chapter item in the ClimateKG corpus. The original values used an old domain and a colon-delimited page title format, e.g.:

```
https://test.kewl.org/wiki/IPCC:Wg2:Chapter:Chapter-1
```

After the Wikibase sitelinks feature was implemented and the P5 update script (`scripts/update-chapter-wiki-urls.py`) was run across all environments, the canonical URLs changed to a slash-delimited format on the PROD domain, e.g.:

```
https://prod-climatekg.semanticclimate.org/wiki/IPCC:AR6/WGII/Chapter-1
```

The CSV needed to be updated to match the live PROD P5 values.

---

## Scope

- **File:** `research_data/data-xml-dtd/corpus-ar6.csv`
- **Column updated:** `WIKI` (column 1)
- **Rows updated:** 88 chapter items (all rows that already had a WIKI URL)
- **Rows unchanged:** 17 report-level rows (WIKI column empty — these have no corresponding chapter item)

---

## Update Process

### 1. Query PROD SPARQL for current P5 values

The PROD SPARQL endpoint was queried to retrieve the live P5 (Wiki URL) and P10 (DOI) for every item where P1=Q6 (Chapter):

```python
SELECT ?item ?p5 ?doi WHERE {
  ?item <https://prod-climatekg.semanticclimate.org/prop/direct/P1>
        <https://prod-climatekg.semanticclimate.org/entity/Q6> .
  OPTIONAL { ?item <https://prod-climatekg.semanticclimate.org/prop/direct/P5> ?p5 . }
  OPTIONAL { ?item <https://prod-climatekg.semanticclimate.org/prop/direct/P10> ?doi . }
}
```

SPARQL endpoint: `https://prod-climatekg.semanticclimate.org/query/proxy/sparql`

### 2. Build DOI → URL mapping

The SPARQL results provide a direct DOI → PROD URL mapping. DOI is stable across environments and uniquely identifies each chapter item in the CSV.

### 3. Update the CSV

For each row in the CSV that has a non-empty WIKI value, the DOI in column 9 was looked up in the mapping and the WIKI column was replaced with the corresponding PROD URL. Rows with no WIKI value (report-level rows) were not modified.

The update was applied in-place using Python's `csv` module to preserve field quoting.

---

## URL Format Change Summary

| Report | Old format (example) | New format (example) |
|--------|----------------------|----------------------|
| SR15   | `IPCC:Sr15:Chapter:Spm` | `IPCC:AR6/SR15/SPM` |
| SRCCL  | `IPCC:Srccl:Chapter:Summary-for-policymakers` | `IPCC:AR6/SRCCL/SPM` |
| SROCC  | `IPCC:Srocc:Chapter:Chapter-2` | `IPCC:AR6/SROCC/Chapter-2` |
| WGI    | `IPCC:Wg1:Chapter:Chapter-1` | `IPCC:AR6/WGI/Chapter-1` |
| WGII   | `IPCC:Wg2:Chapter:Chapter-1` | `IPCC:AR6/WGII/Chapter-1` |
| WGIII  | `IPCC:Wg3:Chapter:Chapter-1` | `IPCC:AR6/WGIII/Chapter-1` |
| SYR    | `IPCC:Syr` | `IPCC:AR6/SYR/SPM` |
| SYR    | `IPCC:Syr:Longer-report` | `IPCC:AR6/SYR/Longer-Report` |

All URLs use base: `https://prod-climatekg.semanticclimate.org/wiki/`

---

## Re-running After a PROD Update

If the PROD P5 values change (e.g. after a domain change or new chapter items), re-run the SPARQL query and apply the mapping again. The process is safe to repeat — only rows with a WIKI URL are touched.

The P5 update script that keeps Wikibase in sync is documented in [`p5-url-update-guide.md`](p5-url-update-guide.md).
