# ClimateKG SPARQL Question Bank

This page is a short starting point for a query-first notebook series for the Climate Knowledge Graph. It groups a small set of candidate questions by dataset area so each notebook stays focused and reusable.

## Goal

The aim is to show how the ClimateKG graph can be queried with SPARQL and explained in notebooks. The focus is on evidence, reproducibility, and clear results.

## Dataset areas and question groups

### 1. Corpus and report structure

- What is the structure of the corpus hierarchy?
- How many items are there at each level?
- Which reports and chapters are present?

### 2. Bibliography and publication metadata

- Which publications are linked to each report or chapter?
- How complete is the bibliographic metadata?
- Which reports are most heavily referenced?

### 3. Authors and contributors

- How many distinct authors are represented?
- Which authors contribute to more than one report or chapter?
- What does author contribution look like across the reports?

### 4. Glossary and conceptual vocabulary

- Which glossary terms are attached to a report?
- How are glossary terms connected to reports and definitions?
- Which terms appear across multiple reports?

### 5. Acronyms and terminology

- Which acronyms appear most often?
- Which reports or chapters use them?
- Are any acronyms repeated in different contexts?

### 6. Cross-dataset and evidence queries

- How can bibliographic, author, and chapter data be connected?
- Which corpus elements link to glossary terms or acronyms?
- Where are the main gaps or inconsistencies?

## Initial notebook series proposal

### Notebook 1: class instance counts

Purpose: count the main classes and establish a baseline.

Suggested questions:
- How many items are there in each major class?
- Do the hierarchy counts match the document structure?

### Notebook 2: investigation of Q1 count discrepancy

Purpose: explain the main count discrepancy.

Suggested questions:
- Why do the Q1 counts differ from the expected total?
- Are there duplicates or missing links?

### Notebook 3: glossary triple demonstration

Purpose: show a simple RDF triple example for a glossary term.

Suggested questions:
- What does a glossary triple look like?
- Which properties connect the term to a report?

### Notebook 4: bibliography and report linking

Purpose: connect publications, reports, and chapter evidence.

Suggested questions:
- Which entries link to which reports?
- Which reports have the most references?

### Notebook 5: authorship and contribution analysis

Purpose: measure author participation.

Suggested questions:
- Which authors contribute to multiple reports or chapters?
- Which report sections have the most authors?

### Notebook 6: glossary and acronym crosswalks

Purpose: connect terminology and acronyms to the corpus.

Suggested questions:
- Which terms are associated with which reports?
- Which acronyms recur in the same contexts?

## Query-first workflow

Each notebook should follow this pattern:

1. Define the question.
2. Convert it to SPARQL.
3. Validate the live result.
4. Document the result in text and tables.
5. Add visualisation only after the query is stable.

## Current Wikibase instance

- Main site: https://climatekg.tibwiki.io/
- SPARQL query interface: https://climatekg.tibwiki.io/query/
- Local notebook access may require the current deployment credentials.

## Next implementation step

The next step is to update the notebooks for the current instance and validate a small first set of queries for the corpus and bibliography domains.
