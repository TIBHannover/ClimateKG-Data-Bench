# Data Visualisation & Ontology Options

## Dataset Overview

Five datasets form the knowledge graph, with **Corpus** as the core and **Chapter** as the atomic unit. All other datasets connect upward to this backbone.

```
WORK
 └── REPORT_SERIES
      └── REPORT  ◄──── Bibliographic enrichment
           └── TEXT_DIVISION
                └── CHAPTER  ◄──── Authors (contributed_to)
                               ◄──── Glossary (series_ref → Report)
                               ◄──── Acronyms (part_of → Report)
```

| Dataset | Items | Connects to |
|---|---|---|
| **Corpus** | Work, Report Series, Report, Text Division, Chapter | — (core) |
| **Authors** | Author + Chapter contributions + Role qualifiers | Chapter (P27) |
| **Bibliographic** | Publisher, ISBNs, Licence, Abstract | Report, Chapter (enrichment) |
| **Glossary** | Term, Definition, AKA | Report (series_ref) |
| **Acronyms** | Code, Description variants | Report (Part of) |

---

## 1. Visualisation Options

### 1.1 Structural / Hierarchical

| Type | What it shows | Best tool |
|---|---|---|
| **Sunburst / Treemap** | Corpus hierarchy depth (Work → Chapter); relative chapter counts per Working Group | Plotly, D3.js |
| **Collapsible tree** | Full Work → Series → Report → Text Division → Chapter drill-down | D3.js, Observable |
| **Entity-Relationship Diagram** | Formal schema of all 5 datasets (already exists in `/erm/`) | Mermaid (embedded in Quarto) |

### 1.2 Author Network

| Type | What it shows | Best tool |
|---|---|---|
| **Bipartite graph** | Author ↔ Chapter contribution network; identifies high-contribution authors and co-chapter clusters | NetworkX + matplotlib, Gephi |
| **Chord diagram** | Cross-WG author sharing (authors contributing to multiple Working Groups) | D3.js chord, HiPlot |
| **Heatmap** | Author × Report/WG contribution density | Seaborn, Plotly |
| **Bar chart (country/gender)** | Citizenship or gender distribution per Working Group — good for a report section on diversity | Matplotlib, Plotly |

### 1.3 Knowledge Graph Coverage

| Type | What it shows | Best tool |
|---|---|---|
| **Stacked bar / grouped bar** | Count of items per class (Chapter, Author, Glossary Term, Acronym) — KG size overview | Matplotlib |
| **Bubble chart** | Chapters × Author count × Gender ratio per Working Group | Plotly |
| **Force-directed graph** | All entity types as nodes, relationship types as edges; shows connectivity of datasets | vis.js, Gephi, Cytoscape |

### 1.4 Bibliographic / Metadata Completeness

| Type | What it shows | Best tool |
|---|---|---|
| **Completeness matrix (heatmap)** | Which Reports/Chapters have DOI, ISBN, PDF, OpenAlex, Abstract filled | Seaborn, Plotly |
| **Timeline** | Report publication dates across AR6 | Plotly timeline / Gantt |

---

## 2. Ontology & Schema Options

### 2.1 Bibliographic Structure (Corpus)

#### FRBR / FRBRoo
- **Fit: High.** The Work → Report Series → Report → Text Division → Chapter hierarchy maps directly onto FRBR's Work/Expression/Manifestation levels.
- `frbr:Work` → WORK; `frbr:Expression` → REPORT; `frbr:Manifestation` → TEXT_DIVISION/CHAPTER
- FRBRoo (OWL version) is preferred for RDF/linked data contexts.

#### FaBiO (FRBR-aligned Bibliographic Ontology)
- **Fit: High.** Purpose-built for academic publications.
- `fabio:Report` → REPORT; `fabio:BookChapter` → CHAPTER; `fabio:WorkCollection` → REPORT_SERIES
- Already uses DOI, ISBN, OpenAlex-style identifiers.

#### BIBO (Bibliographic Ontology)
- **Fit: Medium–High.** Simpler than FaBiO; good for quick RDF export.
- `bibo:Book` → REPORT; `bibo:BookSection` → CHAPTER; `bibo:DocumentPart` → TEXT_DIVISION
- Handles DOI (`bibo:doi`), ISBN (`bibo:isbn13`), PDF URL.

### 2.2 Authors

#### FOAF (Friend of a Friend)
- **Fit: High.** `foaf:Person` covers `last_name`, `first_name`, `affiliation` (`org:memberOf`).
- Pair with **schema.org** `schema:Person` for `gender`, `nationality`, `worksFor`.

#### schema.org
- **Fit: High.** `schema:Person` + `schema:affiliation` + `schema:nationality`.
- `schema:contributor` links Person → Chapter, with `schema:roleName` for the role qualifier.

#### PROV-O
- **Fit: Medium.** Useful if you want to record *how* author data was sourced (provenance on P27 statements).

### 2.3 Glossary & Acronyms

#### SKOS (Simple Knowledge Organization System)
- **Fit: Very High.** Designed exactly for controlled vocabularies and glossaries.
- `skos:Concept` → GLOSSARY_TERM / ACRONYM
- `skos:prefLabel` → `name` / `code`; `skos:altLabel` → `also_known_as`
- `skos:definition` → `definition` / `description`
- `skos:inScheme` → link term to the Report it belongs to

#### LEMON / OntoLex
- **Fit: Medium.** Extends SKOS with lexical entries; useful if acronym variant descriptions (multiple `<description source=…>` elements) need finer modelling.

### 2.4 Provenance & References

#### PROV-O
- **Fit: High** for the bibliographic enrichment pipeline (P17 date accessed, P19 source version).
- `prov:wasDerivedFrom`, `prov:generatedAtTime`, `prov:wasAttributedTo` map to the reference block on each statement.

#### Dublin Core / DataCite
- **Fit: Medium.** `dc:identifier` (DOI), `dc:date`, `dc:publisher`, `dc:rights` (Licence URL) all appear in the Bibliographic dataset. DataCite Metadata Schema 4.x covers the same fields more precisely for DOI-registered items.

---

## 3. Summary Recommendation

| Layer | Recommended ontology | Rationale |
|---|---|---|
| Corpus structure | **FaBiO** + **BIBO** | Best coverage of Report/Chapter hierarchy with DOI/ISBN fields |
| Authors | **schema.org Person** + **FOAF** | Wide tooling support; role qualifier fits `schema:Role` |
| Glossary / Acronyms | **SKOS** | Standard for controlled vocabularies; already partially used (`skos:altLabel` in DTD) |
| Provenance | **PROV-O** | Maps directly to existing P17/P18/P19 reference properties |
| Visualisation (report) | **Sunburst** (structure) + **Bar charts** (diversity) + **ERM** (schema) | Cover hierarchy, people data, and formal schema in one report section |
