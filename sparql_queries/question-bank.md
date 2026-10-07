# ClimateKG SPARQL Question Bank

This page is the starting point for a query-first notebook series for the Climate Knowledge Graph. It groups candidate questions by dataset area so that each notebook can answer a coherent set of research questions and later be cited as a reusable scholarly resource.

## Goal

The aim is to demonstrate how the bibliographic foundation of the ClimateKG knowledge graph can be queried, analysed, and explained using SPARQL and Jupyter Notebooks. The emphasis is on evidence, reproducibility, and shareable notebook workflows rather than one-off exploratory scripts.

## Dataset areas and question groups

### 1. Corpus and report structure

- What is the structure of the corpus hierarchy from report series to chapter and text division?
- How many items exist at each level of the corpus hierarchy?
- Which reports, chapters, and sections are present in the corpus?
- How do chapter counts vary across the report series?
- What is the distribution of text divisions and paragraph-level elements?

### 2. Bibliography and publication metadata

- Which publications are associated with each report or chapter?
- How many bibliographic entries include DOIs or other identifiers?
- Which reports are most heavily referenced in the bibliographic set?
- Are there missing publication metadata or incomplete citation records?
- How can bibliographic entities be connected to the corpus object hierarchy?

### 3. Authors and contributors

- How many distinct authors are represented in the graph?
- Which authors contributed to more than one report or chapter?
- What is the distribution of author contributions by report or chapter?
- Which authors appear in the main report series and which only appear in linked chapters or sections?
- Can authors be linked consistently across report, chapter, and section contexts?

### 4. Glossary and conceptual vocabulary

- Which glossary terms are attached to a report or report series?
- How are glossary terms connected to definition, report, and hierarchy data?
- What is the distribution of glossary terms across reports?
- Which glossary terms appear across multiple reports or evidence contexts?
- How can the glossary data be used to explain the semantic structure of the graph?

### 5. Acronyms and terminology

- Which acronyms are most frequent in the corpus?
- Which acronyms are attached to which reports or chapter contexts?
- Which acronyms are ambiguous or repeated across different report sections?
- How can acronym usage support an analysis of terminology in the report corpus?

### 6. Cross-dataset and evidence queries

- How can a bibliographic record, author, and chapter be connected in one query?
- Which corpus elements are associated with a given glossary term or acronym?
- How do different dataset areas align in terms of coverage and completeness?
- What patterns of missingness or inconsistency appear when datasets are linked together?

## Initial notebook series proposal

### Notebook 1: class instance counts

Purpose: count major graph classes and establish the corpus hierarchy baseline.

Suggested questions:
- How many items exist for each major class in the graph?
- Are the expected hierarchy counts aligned with the document structure?
- Which classes have the highest volume of instances?

### Notebook 2: investigation of Q1 count discrepancy

Purpose: explain irregularities in category counts and identify reporting or modelling issues.

Suggested questions:
- Why do the counts for Q1 differ from the expected total?
- Which categories are overrepresented or underrepresented?
- Are there duplicates, missing links, or report-level inconsistencies?

### Notebook 3: glossary triple demonstration

Purpose: explain the idea of an RDF triple and show how a glossary term relates to report and category context.

Suggested questions:
- What does a full glossary triple look like in the graph?
- Which properties connect a glossary term to its report and category?
- How does the graph represent semantic statements rather than only table rows?

### Notebook 4: bibliography and report linking

Purpose: connect publications, reports, and chapter-level evidence.

Suggested questions:
- Which bibliographic entries relate to which reports or chapter contexts?
- Which reports have the highest bibliographic density?
- Are bibliographic references incomplete or inconsistent across the corpus?

### Notebook 5: authorship and contribution analysis

Purpose: quantify author participation and contribution patterns.

Suggested questions:
- Which authors contribute to multiple reports or chapters?
- Which report sections are most densely authored?
- Can authorship signals be used to analyse collaboration or geographic coverage?

### Notebook 6: glossary and acronym crosswalks

Purpose: connect terminology, acronyms, and the report corpus.

Suggested questions:
- Which terms are associated with which reports?
- Which acronyms recur in the same contexts as particular glossary concepts?
- How can the graph support conceptual linking between terminology and report narrative?

## Query-first workflow

Each notebook should follow this pattern:

1. Define the research question.
2. Convert it to a SPARQL query.
3. Validate the live result against the current Wikibase instance.
4. Document the result in prose and tables.
5. Add a visualisation layer only after the query is stable.
6. Record the notebook metadata for future academic citation.

## Current Wikibase instance

- Main site: https://climatekg.tibwiki.io/
- SPARQL query interface: https://climatekg.tibwiki.io/query/
- Local notebook access may require the project off-web credentials provided for the current deployment (username: ckg, password: fairdata).

## Next implementation step

The next concrete task is to rewrite the existing SPARQL notebooks to use the current instance and then expand the question bank into a first set of fully validated notebook queries for the corpus and bibliography domains.
