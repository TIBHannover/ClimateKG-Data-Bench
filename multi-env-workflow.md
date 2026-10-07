---
title: "Multi-Environment Workflow"
---

# Multi-Environment Workflow

This page documents how the ClimateKG project is developed and published across the different local and public environments used during analysis and site updates.

## Overview

The project is built as a Quarto website and rendered to the `docs` folder. Notebook-based analysis files under `sparql_queries/` are executed against the live Wikibase instance and then published as static pages.

## Local workflow

1. Update the SPARQL notebooks and supporting queries.
2. Validate the endpoint and credentials against the live ClimateKG instance.
3. Run the site render locally with Quarto.
4. Check the generated pages in the `docs` output.

## Publishing workflow

1. Review the rendered site output.
2. Commit the changes to the repository.
3. Publish the updated site via the project deployment process.
