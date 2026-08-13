# Glossary Term Triple Demonstration

A SPARQL query to visualise the statements (triples) for a specific IPCC glossary term, using **Gini coefficient** as the example. The purpose is to demonstrate what a triple is: a subject–predicate–object statement in the knowledge graph.

## Status

Work in progress — see [Next Steps](#next-steps) below.

---

## Background

Glossary terms in the ClimateKG Wikibase are instances of **Q1 (Category)**. Each term has:

| Property | Label | Value (example: Gini coefficient / Q620) |
|----------|-------|------------------------------------------|
| P1 | instance of | Q1 (Category) |
| P3 | part of | Report it belongs to (e.g. Q150 = WGIII AR6) |
| P13 | definition | Plain-text definition string |

The relationship between a glossary term and its source report is via **P3 (part of)**, pointing to a **Q4 (Report)** item. There is currently no chapter-level tagging for glossary terms — they are associated at the report level only.

---

## SPARQL Query — Graph View

Paste this into the [production SPARQL query interface](https://prod-climatekg.semanticclimate.org/query/) and switch to the **Graph** tab.

```sparql
PREFIX ckg:  <https://prod-climatekg.semanticclimate.org/entity/>
PREFIX ckgp: <https://prod-climatekg.semanticclimate.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?subject ?subjectLabel ?linkLabel ?object ?objectLabel
WHERE {
  VALUES ?subject { ckg:Q620 }
  ?subject rdfs:label ?subjectLabel .

  {
    ?subject ckgp:P1 ?object .
    BIND("P1: instance of" AS ?linkLabel)
  }
  UNION
  {
    ?subject ckgp:P3 ?object .
    BIND("P3: part of" AS ?linkLabel)
  }

  ?object rdfs:label ?objectLabel .
}
```

### What the graph shows

```
Gini coefficient ──[P1: instance of]──► Category
Gini coefficient ──[P3: part of]──────► Working Group III: Mitigation of Climate Change
```

Each row in the table result = one triple. The graph view makes the subject–predicate–object structure visible.

### Notes on using the interface

- **Do not remove the `PREFIX` lines** — the interface injects its own `wd:`/`wdt:` prefixes that point to Wikidata, not ClimateKG. The `ckg:`/`ckgp:` aliases override that conflict.
- Switch to **Graph** tab in the results panel after running.

---

## To make this query generic (any glossary term by label)

Replace the `VALUES` block with a label filter:

```sparql
  # Replace VALUES ?subject { ckg:Q620 } with:
  ?subject ckgp:P1 ckg:Q1 .
  ?subject rdfs:label ?subjectLabel .
  FILTER(CONTAINS(LCASE(STR(?subjectLabel)), "gini coefficient"))
```

---

## Next Steps

- [ ] Query to list all glossary terms and the report(s) each belongs to
- [ ] Query to find which glossary terms are shared across multiple reports
- [ ] Investigate whether chapter-level tagging of glossary terms is feasible / exists in source data
- [ ] Build a notebook (`.ipynb`) version of this query for the Quarto site, following the pattern in `class-counts.ipynb`
- [ ] Consider a query showing the full neighbourhood of a glossary term: definition (P13), report hierarchy (P3 → P4 → report series), and any P12 chapter tags
