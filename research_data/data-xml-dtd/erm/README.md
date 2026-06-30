# Entity-Relationship Model (ERM) — Wikibase Mapping

This directory contains the artefacts for mapping the IPCC AR6 XML/DTD data model to the
local Wikibase instance, generating both a flat CSV property table and a Mermaid
entity-relationship diagram.

---

## Directory contents

| File | Role |
|------|------|
| `erm-wikibase-mapping.xml` | **Source of truth** — hand-maintained XML that maps every DTD entity and field to a real Wikibase Property (PID) or Item (QID) |
| `erm-to-csv.xslt` | XSLT 1.0 stylesheet: transforms mapping XML → flat CSV |
| `erm-to-mermaid.xslt` | XSLT 1.0 stylesheet: transforms mapping XML → Mermaid `erDiagram` |
| `generate-erm.ps1` | PowerShell runner — executes both transforms in one step |
| `erm-mapping.csv` | **Generated output** — entity/property table (73 rows) |
| `er-diagram-wikibase.mmd` | **Generated output** — Mermaid ER diagram with real QIDs and PIDs |
| `er-diagram.mmd` | Original conceptual ERD (no real QIDs — created before SPARQL query) |
| `erm.md` | Markdown wrapper for previewing `er-diagram-wikibase.mmd` inside VS Code |

---

## Workflow

```
DTD files (parent data-xml-dtd/)
        │
        ▼
[Manual step] SPARQL query against local Wikibase
  http://localhost:9999/bigdata/namespace/wdq/sparql
  → retrieve all Properties (P1–P33) and class Items (Q-IDs)
        │
        ▼
erm-wikibase-mapping.xml  ◄── edit this file to update the mapping
        │
        ├──[erm-to-csv.xslt]──────► erm-mapping.csv
        │
        └──[erm-to-mermaid.xslt]──► er-diagram-wikibase.mmd
```

### Step 1 — Query Wikibase for PIDs and QIDs

The mapping XML was populated by querying the local Wikibase SPARQL endpoint.
Example SPARQL (uses explicit prefixes required by this Wikibase instance):

```sparql
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?prop ?num ?label WHERE {
  ?prop a wikibase:Property .
  ?prop wikibase:propertyType ?type .
  BIND(REPLACE(STR(?prop), ".*/", "") AS ?num)
  OPTIONAL { ?prop rdfs:label ?label FILTER(LANG(?label) = "en") }
}
ORDER BY xsd:integer(SUBSTR(?num, 2))
```

### Step 2 — Maintain `erm-wikibase-mapping.xml`

This is the only file you need to edit manually. Structure:

```xml
<erm-mapping>
  <dtd name="corpus-ar6">
    <entity name="WORK" qid="Q2" label="Work">
      <field name="instance_of" pid="P1" label="Instance of"
             datatype="WikibaseItem" notes="P1=Q2"/>
      ...
    </entity>
    <relationship from="PUBLICATION" to="SERIES"
                  cardinality="||--o{" label="P4 contains"/>
  </dtd>
  ...
</erm-mapping>
```

**Five DTD sections** in hierarchy order:

1. `corpus-ar6` — top-level corpus (Work Q2, Publication Q3, Series Q4, Book Q5, Chapter Q6)
2. `authors-ar6` — IPCC AR6 author records (Author Q3998)
3. `bibliographic-ar6` — DOI bibliographic enrichment (adds P29–P33 to Series and Chapter)
4. `glossary-ar6` — glossary terms (Category Q1)
5. `acronyms-ar6` — acronym list (Acronym Q2087)

### Step 3 — Regenerate outputs

Run from PowerShell inside this directory (or any working directory — the script uses `$PSScriptRoot`):

```powershell
.\generate-erm.ps1
```

Requires: Windows PowerShell 5.1+ or PowerShell 7+, .NET `System.Xml.Xsl.XslCompiledTransform` (built-in on Windows).

Outputs written as **UTF-8 without BOM** (required by the Mermaid parser).

---

## Wikibase property reference (P1–P33)

| PID | Label | Type |
|-----|-------|------|
| P1  | Instance of | WikibaseItem |
| P2  | Instances | WikibaseItem |
| P3  | Part of | WikibaseItem |
| P4  | Parts | WikibaseItem |
| P5  | Wiki | Url |
| P6  | Source | Url |
| P7  | PDF | Url |
| P8  | Date | String |
| P9  | OPENALEX | String |
| P10 | DOI | String |
| P11 | LICENSE | String |
| P12 | Has TAG | WikibaseItem |
| P13 | Definition | Monolingualtext |
| P17 | date accessed | Time |
| P18 | date accessed | Time |
| P19 | source version | String |
| P20 | ClimateKG Author ID | String |
| P21 | last name | String |
| P22 | first name | String |
| P23 | gender | String |
| P24 | citizenship | String |
| P25 | country of residence | String |
| P26 | affiliation | String |
| P27 | contributed to chapter | WikibaseItem |
| P28 | role | String |
| P29 | Publisher DOI | String |
| P30 | ISBN Electronic DOI | String |
| P31 | ISBN Print DOI | String |
| P32 | Licence URL DOI | Url |
| P33 | Abstract DOI | String |

## Wikibase class items (QIDs)

| QID | Label |
|-----|-------|
| Q1 | Category (Glossary Terms) |
| Q2 | Work |
| Q3 | Publication |
| Q4 | Series |
| Q5 | Book |
| Q6 | Chapter |
| Q2087 | Acronym |
| Q3998 | Author |

---

## Previewing the diagram

Open `erm.md` in VS Code and press `Ctrl+K V` (preview to side).
Requires the **bierner.markdown-mermaid** VS Code extension.

The diagram can also be viewed online at [mermaid.live](https://mermaid.live) — use
the Python snippet in `generate-erm.ps1` comments to generate the pako-encoded URL.
