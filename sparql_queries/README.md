# SPARQL Queries

This directory contains Jupyter notebooks that demonstrate a query-first, evidence-based workflow for the ClimateKG Wikibase instance.

## Purpose

These notebooks serve as:
- **Question-led analysis** of the Climate Knowledge Graph
- **SPARQL examples** for working with the current ClimateKG Wikibase instance
- **Reusable notebooks** that can be cited, shared, and extended on GitHub
- **Documentation** for common graph queries across the bibliographic foundation of the knowledge graph

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

These queries are designed for the current ClimateKG Wikibase instance:

- **Main Page**: https://climatekg.tibwiki.io/
- **SPARQL Endpoint**: https://climatekg.tibwiki.io/query/sparql
- **Query Interface**: https://climatekg.tibwiki.io/query/
- **Access note**: the live service is protected; if your deployment requires credentials, export `CLIMATEKG_SPARQL_USERNAME` and `CLIMATEKG_SPARQL_PASSWORD` before running the notebooks. On the current instance this is typically `ckg` and `fairdata`.

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

2. Set the credentials for the endpoint if required:
   ```bash
   export CLIMATEKG_SPARQL_USERNAME=ckg
   export CLIMATEKG_SPARQL_PASSWORD=fairdata
   ```

3. Launch Jupyter:
   ```bash
   jupyter notebook
   ```

4. Open and run the desired notebook

### View in Quarto Website

The notebooks are automatically rendered as part of the Quarto website. Visit the "SPARQL Queries" menu to view the rendered outputs.

## Query Structure

All queries follow standard Wikibase SPARQL patterns:

```sparql
PREFIX wd: <https://climatekg.tibwiki.io/entity/>
PREFIX wdt: <https://climatekg.tibwiki.io/prop/direct/>

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
3. Start from a research question, then convert it into a validated SPARQL query
4. Include explanatory text and links to Wikibase
5. Add academic metadata for future citation and DOI assignment
6. Update `_quarto.yml` to include the new notebook in the Data Analysis menu

## Resources

- [Wikibase SPARQL Documentation](https://www.mediawiki.org/wiki/Wikibase/Indexing/SPARQL_Query_Examples)
- [SPARQL 1.1 Query Language](https://www.w3.org/TR/sparql11-query/)
- [SPARQLWrapper Documentation](https://sparqlwrapper.readthedocs.io/)
- [ClimateKG Project Documentation](https://github.com/TIBHannover/Climate-KG-data)
