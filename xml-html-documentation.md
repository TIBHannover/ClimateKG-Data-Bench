# IPCC AR6 XML to HTML Transformations

This directory contains XML data files and XSLT stylesheets to generate HTML documentation pages for IPCC AR6 data.

## Overview: CSV to XML to Wikibase Pipeline

The IPCC AR6 data follows a structured pipeline from source data to knowledge base:

```
CSV files → Normalization → XML + DTD → Multiple outputs:
                                         ├─ HTML (via XSLT)
                                         ├─ Wikibase import (via Python)
                                         └─ Other formats (via XSLT)
```

### Step 1: CSV Normalization

Source data starts as CSV files (e.g., `ipccglossary.csv`, `authors-source.csv`, `acronyms-ar6.csv`), which undergo normalization in the `research_data/data-import/` directories:

- **Whitespace cleaning**: Remove leading/trailing spaces
- **Standardization**: Normalize country names, convert case (e.g., `SMITH` → `Smith`)
- **Enrichment**: Look up Wikibase QIDs via SPARQL, add stable IDs
- **Column mapping**: Rename and reorder columns for XML compatibility
- **Validation**: Check data consistency and completeness

Scripts: `normalise_*.py` in each data-import subdirectory

### Step 2: XML Generation with DTD Validation

Normalized CSVs are converted to structured XML using Python scripts:

- **Scripts**: `csv_to_xml.py` or `csv_to_xml.ipynb` (Jupyter notebook)
- **Libraries**: `xml.etree.ElementTree` (Python) or `lxml` (notebook)
- **Validation**: Each XML file is validated against its Document Type Definition (DTD)
- **Output**: Clean, validated XML files in `outputs/` or `data-xml-dtd/`

**DTD files** (e.g., `glossary.dtd`, `authors-ar6.dtd`) define the structure and constraints:
- Required vs. optional elements
- Element nesting rules
- Attribute definitions
- Data types and patterns

Example DTD excerpt:
```dtd
<!ELEMENT term (name, also_known_as?, definition, series)>
<!ATTLIST term id ID #REQUIRED>
<!ELEMENT series (series_ref+)>
<!ELEMENT series_ref (#PCDATA)>
<!ATTLIST series_ref qid CDATA #REQUIRED>
```

### Step 3a: XSLT Transformation to HTML

XSLT (eXtensible Stylesheet Language Transformations) converts XML to HTML for human-readable documentation:

- **Flexibility**: XSLT can transform XML to **any text format** (HTML, CSV, JSON, LaTeX, Markdown, etc.)
- **Reusability**: Same XML file can generate multiple outputs with different stylesheets
- **Standards-based**: XSLT 1.0 is widely supported across languages (.NET, Java, Python lxml, browser engines)
- **Template-driven**: Declarative pattern matching makes transformations maintainable

This repository uses XSLT 1.0 stylesheets (e.g., `authors-ar6.xslt`) with .NET's `XslCompiledTransform` for HTML generation.

### Step 3b: Python-Based Wikibase Import

XML is ideal for Wikibase imports because:

- **Structured validation**: DTD ensures data integrity before import
- **Hierarchical data**: Natural representation of entities and relationships (e.g., author → contributions → chapters)
- **Namespace handling**: Clean separation of metadata and content
- **Parsing libraries**: Python's `xml.etree.ElementTree` and `lxml` provide robust parsing
- **Error handling**: XML validation catches issues early, before touching the knowledge base
- **Documentation**: Self-documenting with DTD, unlike raw CSVs

**Import library**: [wikibaseintegrator](https://github.com/LeMyst/WikibaseIntegrator)
- High-level Python API for creating/editing Wikibase items and properties
- Handles authentication, item creation, statements, qualifiers, and references
- Works in both Python scripts (`.py`) and Jupyter notebooks (`.ipynb`)
- Install: `pip install wikibaseintegrator`

**Example scripts**: `upload_to_wikibase.py` in each `data-import/*/` directory
- [research_data/data-import/authors-XML-DTD/upload_to_wikibase.py](research_data/data-import/authors-XML-DTD/upload_to_wikibase.py) - Complete example with bootstrap pattern, XML parsing, and item creation
- [research_data/data-import/ipcc-glossary-XML-DTD/upload_to_wikibase.ipynb](research_data/data-import/ipcc-glossary-XML-DTD/upload_to_wikibase.ipynb) - Jupyter notebook version for interactive imports
- Each script demonstrates XML parsing, statement creation with qualifiers/references, and error handling

### Tools for Working with XML

**Microsoft XML Notepad** (free) - Recommended XML viewer/editor:
- Download: https://microsoft.github.io/XmlNotepad/
- Features: Tree view, DTD validation, XSLT transformation preview, syntax highlighting
- Use case: Review generated XML files, validate against DTD, test XSLT stylesheets

Other tools:
- **VS Code** with XML extensions (Red Hat XML, XML Tools)
- **Python lxml**: `lxml.etree.fromstring()` with DTD validation
- **xmllint** (Linux/Mac): Command-line validation tool

## Generated HTML Pages

The following HTML pages are generated from XML data using XSLT transformations:

### 1. **authors-ar6.html**
- **Source:** `authors-ar6.xml`
- **Stylesheet:** `authors-ar6.xslt`
- **Content:** Comprehensive directory of IPCC AR6 authors with:
  - Full name, gender, citizenship, country of residence
  - Institutional affiliations
  - Chapter contributions and roles (Lead Author, Review Editor, etc.)
  - Statistics: total authors, contributions, gender distribution
  - Searchable interface

### 2. **acronyms-ar6.html**
- **Source:** `acronyms-ar6.xml`
- **Stylesheet:** `acronyms-ar6.xslt`
- **Content:** Complete list of acronyms used across IPCC AR6 reports:
  - Acronym codes and definitions
  - Multiple definitions where applicable (with source attribution)
  - Report badges showing which reports use each acronym (WGI, WGII, WGIII, SR1.5, etc.)
  - Statistics by working group
  - Searchable interface

### 3. **bibliographic-ar6.html**
- **Source:** `bibliographc-ar6.xml`
- **Stylesheet:** `bibliographic-ar6.xslt`
- **Content:** Bibliographic metadata enriched from Crossref DOI data:
  - Publisher information
  - ISBN numbers (electronic and print)
  - License URLs
  - Abstracts
  - DOI references
  - Searchable interface with expandable abstracts

### 4. **corpus-ar6.html**
- **Source:** `corpus-ar6.xml`
- **Stylesheet:** `corpus-ar6.xslt`
- **Content:** Hierarchical structure of IPCC AR6 publications:
  - Publication and series information
  - Working Group books (WGI, WGII, WGIII) and Special Reports
  - Front matter and chapter organization
  - DOI, PDF, Wiki, Source, and OpenAlex links for each chapter
  - License and date metadata
  - Clean hierarchical navigation

### 5. **glossary-ar6.html**
- **Source:** `glossary-ar6.xml`
- **Stylesheet:** `glossary-ar6.xslt`
- **Content:** IPCC glossary terms with:
  - Term names and aliases (also known as)
  - Definitions
  - Series badges (WGI, WGII, WGIII, SR15, etc.) with QID references
  - Statistics by working group
  - Searchable interface with real-time filtering

## File Structure

```
data-xml-dtd/
├── authors-ar6.xml          # Author data
├── authors-ar6.dtd          # Document Type Definition for authors
├── authors-ar6.xslt         # XSLT stylesheet for authors
├── authors-ar6.html         # Generated HTML page
│
├── acronyms-ar6.xml         # Acronyms data
├── acronyms-ar6.dtd         # DTD for acronyms
├── acronyms-ar6.xslt        # XSLT stylesheet for acronyms
├── acronyms-ar6.html        # Generated HTML page
│
├── bibliographc-ar6.xml     # Bibliographic enrichment data
├── bibliographic-ar6.dtd    # DTD for bibliographic data
├── bibliographic-ar6.xslt   # XSLT stylesheet for bibliography
├── bibliographic-ar6.html   # Generated HTML page
│
├── corpus-ar6.xml           # Corpus structure data
├── corpus-ar6.dtd           # DTD for corpus
├── corpus-ar6.xslt          # XSLT stylesheet for corpus
├── corpus-ar6.html          # Generated HTML page
│
├── glossary-ar6.xml         # Glossary data
├── glossary-ar6.dtd         # DTD for glossary
├── glossary-ar6.xslt        # XSLT stylesheet for glossary
├── glossary-ar6.html        # Generated HTML page
│
└── generate-html.ps1        # PowerShell script to regenerate all HTML
```

## Generating HTML Files

### Option 1: Using the PowerShell Script (Recommended)

Run the provided script to regenerate all HTML files:

```powershell
cd research_data/data-xml-dtd
.\generate-html.ps1
```

The script will:
- Check for required XML and XSLT files
- Transform each XML file using its corresponding XSLT stylesheet
- Report success/failure for each transformation
- Display file sizes of generated HTML
- **Copy HTML files to `../../docs/data/` for the Quarto website**

**Note**: After running `quarto render`, re-run `.\generate-html.ps1` to ensure the HTML files are copied to the Quarto output directory, as Quarto may clean the output directory during rendering.

### Option 2: Manual Transformation

To manually transform an XML file to HTML:

```powershell
# Navigate to the directory
cd research_data/data-xml-dtd

# Create XSLT transformer and configure DTD processing
$xslt = New-Object System.Xml.Xsl.XslCompiledTransform
$xslt.Load("authors-ar6.xslt")

$settings = New-Object System.Xml.XmlReaderSettings
$settings.DtdProcessing = [System.Xml.DtdProcessing]::Parse

# Create reader and writer
$reader = [System.Xml.XmlReader]::Create("authors-ar6.xml", $settings)
$writer = [System.Xml.XmlWriter]::Create("authors-ar6.html")

# Transform
$xslt.Transform($reader, $writer)

# Clean up
$reader.Close()
$writer.Close()
```

Repeat for other files by changing the filenames.

## XSLT Features

All XSLT stylesheets follow a consistent design pattern:

### Visual Design
- Clean, modern interface with responsive layout
- IPCC blue color scheme (#1a5490)
- Card-based design with subtle shadows and borders
- Mobile-friendly responsive design

### Functionality
- **Search:** Real-time JavaScript-based search filtering
- **Statistics:** Summary cards showing key metrics
- **Badges:** Color-coded badges for reports, roles, and categories
- **Interactive Elements:** Expandable abstracts, hover effects

### Styling
- Uses system fonts for better performance and native look
- Consistent spacing and typography
- Accessible color contrasts
- Print-friendly styles

## Technical Details

### DTD Processing
The XML files reference Document Type Definitions (DTDs) which must be processed during transformation. The PowerShell scripts configure `DtdProcessing = Parse` to enable this.

### XSLT Version
All stylesheets use XSLT 1.0 for maximum compatibility with .NET's `XslCompiledTransform` class.

### Browser Compatibility
Generated HTML files are compatible with all modern browsers (Chrome, Firefox, Safari, Edge).

## Data Sources

The XML files in this directory are generated from CSV source data processed in `research_data/data-import/`:

- **Authors:** `data-import/authors-XML-DTD/` - IPCC official author listings from https://apps.ipcc.ch/report/authors/
- **Acronyms:** `data-import/ipcc-acronyms-XML-DTD/` - Compiled from IPCC AR6 reports
- **Bibliography:** `data-import/bibliographic-XML-DTD/` - Enriched with Crossref DOI metadata
- **Corpus:** `data-import/corpus-backbone-XML-DTD/` - IPCC AR6 publication structure with chapter metadata and links
- **Glossary:** `data-import/ipcc-glossary-XML-DTD/` - IPCC official glossary from https://apps.ipcc.ch/glossary/

Each data-import directory contains:
- Source CSV files
- Normalization scripts (`normalise_*.py`)
- CSV-to-XML conversion scripts (`csv_to_xml.py` or `csv_to_xml.ipynb`)
- DTD files for validation
- Wikibase upload scripts (`upload_to_wikibase.py`)
- Documentation (`README.md` or `instructions.md`)

## Maintenance

To update the HTML pages after XML data changes:

1. **If source data changed**: Re-run the normalization and XML generation in the appropriate `data-import/` directory
2. **If XML changed**: Copy updated XML file to this `data-xml-dtd/` directory
3. Run `.\generate-html.ps1` to regenerate HTML
4. Verify the output by opening the HTML file in a browser

## Related Files

- **Source data**: `research_data/data-import/*/` - CSV files and conversion scripts
- CSV source files: `*.csv` - Original data in CSV format
- DTD files: `*.dtd` - Document Type Definitions for XML validation
- XML files: `*.xml` - Structured data
- XSLT files: `*.xslt` - Transformation stylesheets
- HTML files: `*.html` - Generated documentation pages
