# Climate-KG Quarto Project

This Quarto project generates a website with the Climate-KG data analysis notebooks.

## Prerequisites

Install Quarto from https://quarto.org/docs/get-started/

## Building the Site

**Note**: The Quarto project is located at the **root of the repository**.

From the repository root:

```bash
quarto render
```

The output will be generated in the `docs/` folder at the repository root.

## Previewing the Site

To preview with live reload:

```bash
quarto preview
```

## Publishing to GitHub Pages

If your repository is on GitHub, you can publish to GitHub Pages:

1. Push the `docs/` folder to your repository
2. Go to Settings > Pages
3. Set source to "Deploy from a branch"
4. Select the `main` branch and `/docs` folder
5. Save

Your site will be available at: `https://tibhannover.github.io/Climate-KG-data/`

## Project Structure

**At repository root:**
- `_quarto.yml` - Project configuration
- `index.qmd` - Home page
- `docs/` - Generated website output

**Notebook sources:**
- `research_data/data-vis/ar6-authors-distribution-analysis.ipynb` - AR6 authors analysis
- `research_data/data-vis/wikibase-inventory-dashboard.ipynb` - Wikibase inventory dashboard

## Configuration

The project is configured with:
- Code folding enabled (collapsed by default, expandable)
- Code tools available
- Table of contents
- Cosmo theme
- Auto-freeze for faster re-renders
