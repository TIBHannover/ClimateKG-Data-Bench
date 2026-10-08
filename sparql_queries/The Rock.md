# The Rock

## Important links

- [ERM model README](../research_data/data-xml-dtd/erm/README.qmd)
- [Class instance counts notebook](./class-counts.ipynb)
- [The Rock reference](./The%20Rock.md)

This note is the shared reference base for the ClimateKG notebooks. It captures the core ER model and keeps the graph interpretation stable across the report-structure, authors, glossary, and acronyms analyses.

The source of truth for this reference is the ER model documentation in [research_data/data-xml-dtd/erm/README.qmd](../research_data/data-xml-dtd/erm/README.qmd).

## Canonical KG structure

The intended corpus hierarchy is:

Work (Q2) -> Report Series (Q3) -> Report (Q4) -> Text Division (Q5) -> Chapter (Q6)

This is the governing structure for the report hierarchy. The notebook queries should be interpreted against this model, not the other way around.

## Relationship semantics

- `P1` = Instance of
- `P3` = Part of
- `P4` = Parts

In the intended model, the report tree is represented through the part-of / parts relationships between items in the hierarchy.

## Entity and class mapping

The ER model defines the relevant classes and their roles in the graph:

- `Q2` Work
- `Q3` Report Series
- `Q4` Report
- `Q5` Text Division
- `Q6` Chapter
- `Q1` Category / glossary terms
- `Q2087` Acronym
- `Q3998` Author

The same model also defines the key author and enrichment properties used across the notebooks:

- `P20` ClimateKG Author ID
- `P27` contributed to chapter
- `P3`/`P4` for report structure
- `P13` Definition
- `P12` Has TAG

## DTD sections represented in the model

The ER model is organized around the five XML/DTD sections:

1. `corpus-ar6` — top-level corpus hierarchy
2. `authors-ar6` — author records and contributions
3. `bibliographic-ar6` — DOI / bibliographic enrichment
4. `glossary-ar6` — glossary terms / category entries
5. `acronyms-ar6` — acronym entries

## Working rule for the notebooks

Each notebook should follow the same pattern:

1. Start from the canonical ER model in this note.
2. Query the live Wikibase to see what is actually present.
3. Compare the live result to the intended model.
4. Report the graph faithfully, including partial or snapshot-style outputs when the live data is incomplete.

This means that a notebook should not silently assume the full hierarchy exists if only a subset is present. Instead, it should record the actual live structure and call out the difference against the ER model.

## In plain terms

The Rock is the stable reference layer: it keeps the KB structure clear, preserves the intended hierarchy, and prevents the notebooks from drifting into interpretations that are not grounded in the project ER mapping.
