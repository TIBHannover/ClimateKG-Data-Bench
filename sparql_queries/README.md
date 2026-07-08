# SPARQL Queries

This directory contains Jupyter notebooks demonstrating SPARQL queries against the ClimateKG Wikibase instance.

## Purpose

These notebooks serve as:
- **Educational examples** of SPARQL query patterns for Wikibase
- **Interactive tutorials** that can be run locally or viewed in the Quarto website
- **Documentation** of common queries for working with ClimateKG data

## Notebooks

### 1. Class Instance Counts (`class-counts.ipynb`)

Demonstrates basic SPARQL queries to count items belonging to major classes in the corpus hierarchy:
- Q2: Person
- Q3: Series
- Q4: Publication
- Q5: Book
- Q1: Chapter
- Q2087: Paragraph
- Q3998: Section

Each query includes:
- The full SPARQL query text
- A link to run the query in the Wikibase SPARQL interface
- A link to view the class definition in Wikibase

## Wikibase Instance

These queries are designed for the production ClimateKG Wikibase instance:

- **Main Page**: https://prod-climatekg.semanticclimate.org/wiki/Main_Page
- **SPARQL Endpoint**: https://prod-climatekg.semanticclimate.org/bigdata/sparql
- **Query Interface**: https://prod-climatekg.semanticclimate.org/query/

## Running the Notebooks

### Prerequisites

Install the required Python packages:

```bash
pip install SPARQLWrapper pandas ipython jupyter
```

### Local Execution

1. Navigate to this directory:
   ```bash
   cd sparql_queries
   ```

2. Launch Jupyter:
   ```bash
   jupyter notebook
   ```

3. Open and run the desired notebook

### View in Quarto Website

The notebooks are automatically rendered as part of the Quarto website. Visit the "SPARQL Queries" menu to view the rendered outputs.

## Query Structure

All queries follow standard Wikibase SPARQL patterns:

```sparql
PREFIX wd: <https://prod-climatekg.semanticclimate.org/entity/>
PREFIX wdt: <https://prod-climatekg.semanticclimate.org/prop/direct/>

SELECT ... WHERE {
  # Query patterns here
}
```

### Key Properties

- **P3**: instance of - Links items to their class

## Contributing

To add new query examples:

1. Create a new Jupyter notebook in this directory
2. Follow the structure of existing notebooks
3. Include explanatory text and links to Wikibase
4. Update this README with a description of your notebook
5. Update `_quarto.yml` to include the new notebook in the menu

## Resources

- [Wikibase SPARQL Documentation](https://www.mediawiki.org/wiki/Wikibase/Indexing/SPARQL_Query_Examples)
- [SPARQL 1.1 Query Language](https://www.w3.org/TR/sparql11-query/)
- [SPARQLWrapper Documentation](https://sparqlwrapper.readthedocs.io/)
- [ClimateKG Project Documentation](https://github.com/TIBHannover/Climate-KG-data)
