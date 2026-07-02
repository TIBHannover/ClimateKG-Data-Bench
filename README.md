# ClimateKG-Data-Bench

Data and data model for the [ClimateKG](https://tibhannover.github.io/ClimateKG-Data-Bench/) Wikibase knowledge graph, focusing on IPCC AR6 climate science publications.

## Data model & pipeline

IPCC AR6 data follows a **CSV → XML/DTD → Wikibase** pipeline:

```
CSV files → normalise → XML + DTD → XSLT → HTML
                            └──────────────→ Wikibase import (wikibaseintegrator)
```

The **Entity-Relationship Model** (`research_data/data-xml-dtd/erm/`) maps every DTD element to a confirmed Wikibase PID/QID:

| Entity | QID | Also known as |
|--------|-----|---------------|
| Report Series | Q3 | Monographic Series |
| Report | Q4 | Book; Monograph; Volume |
| Text Division | Q5 | Division |
| Chapter | Q6 | |
| Author | Q3998 | |

Key files:
- [`erm/erm-wikibase-mapping.xml`](research_data/data-xml-dtd/erm/erm-wikibase-mapping.xml) — source of truth for all PID/QID mappings
- [`erm/er-diagram-wikibase.mmd`](research_data/data-xml-dtd/erm/er-diagram-wikibase.mmd) — Mermaid ER diagram (regenerate with `erm/generate-erm.ps1`)
- [`data-xml-dtd/README-HTML.md`](research_data/data-xml-dtd/README-HTML.md) — full pipeline documentation

## Documentation & Analysis

Interactive Quarto site:

- **View online**: [https://tibhannover.github.io/ClimateKG-Data-Bench/](https://tibhannover.github.io/ClimateKG-Data-Bench/) *(once published)*
- **View locally**: Open `docs/index.html` in your browser
- **Build**: `quarto render` from the repository root

Site includes: ERM diagram, XML/HTML pipeline docs, AR6 author analysis, Wikibase inventory.

See [research_data/data-vis/README-quarto.md](research_data/data-vis/README-quarto.md) for build and publish details.
