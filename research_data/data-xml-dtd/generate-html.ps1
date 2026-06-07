# Generate HTML from XML using XSLT transformations
# This script transforms IPCC AR6 XML data files into HTML using XSLT stylesheets

$ErrorActionPreference = "Stop"
$dir = $PSScriptRoot

Write-Host "`n=== IPCC AR6 XML to HTML Transformation ===" -ForegroundColor Cyan
Write-Host "Directory: $dir`n" -ForegroundColor Gray

# Function to transform XML to HTML
function Transform-XmlToHtml {
    param(
        [string]$XmlFile,
        [string]$XsltFile,
        [string]$HtmlFile
    )
    
    Write-Host "Transforming: $XmlFile" -ForegroundColor Yellow
    
    try {
        # Create XSLT transformer
        $xslt = New-Object System.Xml.Xsl.XslCompiledTransform
        $xslt.Load($XsltFile)
        
        # Configure XML reader to allow DTD processing
        $settings = New-Object System.Xml.XmlReaderSettings
        $settings.DtdProcessing = [System.Xml.DtdProcessing]::Parse
        
        # Create reader and writer
        $reader = [System.Xml.XmlReader]::Create($XmlFile, $settings)
        $writer = [System.Xml.XmlWriter]::Create($HtmlFile)
        
        # Perform transformation
        $xslt.Transform($reader, $writer)
        
        # Clean up
        $reader.Close()
        $writer.Close()
        
        $size = (Get-Item $HtmlFile).Length
        $sizeKB = [math]::Round($size / 1KB, 2)
        Write-Host "  ✓ Generated: $HtmlFile ($sizeKB KB)" -ForegroundColor Green
        
        return $true
    }
    catch {
        Write-Host "  ✗ Error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Transform each file
$transformations = @(
    @{
        Name = "Authors"
        Xml = "$dir\authors-ar6.xml"
        Xslt = "$dir\authors-ar6.xslt"
        Html = "$dir\authors-ar6.html"
    },
    @{
        Name = "Acronyms"
        Xml = "$dir\acronyms-ar6.xml"
        Xslt = "$dir\acronyms-ar6.xslt"
        Html = "$dir\acronyms-ar6.html"
    },
    @{
        Name = "Bibliography"
        Xml = "$dir\bibliographc-ar6.xml"  # Note: typo in original filename
        Xslt = "$dir\bibliographic-ar6.xslt"
        Html = "$dir\bibliographic-ar6.html"
    },
    @{
        Name = "Corpus"
        Xml = "$dir\corpus-ar6.xml"
        Xslt = "$dir\corpus-ar6.xslt"
        Html = "$dir\corpus-ar6.html"
    },
    @{
        Name = "Glossary"
        Xml = "$dir\glossary-ar6.xml"
        Xslt = "$dir\glossary-ar6.xslt"
        Html = "$dir\glossary-ar6.html"
    }
)

$successCount = 0
$totalCount = $transformations.Count

foreach ($transform in $transformations) {
    Write-Host "`n--- $($transform.Name) ---" -ForegroundColor Cyan
    
    # Check if files exist
    if (-not (Test-Path $transform.Xml)) {
        Write-Host "  ✗ XML file not found: $($transform.Xml)" -ForegroundColor Red
        continue
    }
    if (-not (Test-Path $transform.Xslt)) {
        Write-Host "  ✗ XSLT file not found: $($transform.Xslt)" -ForegroundColor Red
        continue
    }
    
    # Perform transformation
    $success = Transform-XmlToHtml -XmlFile $transform.Xml -XsltFile $transform.Xslt -HtmlFile $transform.Html
    if ($success) {
        $successCount++
    }
}

# Summary
Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host "Successfully transformed: $successCount of $totalCount files" -ForegroundColor $(if ($successCount -eq $totalCount) { "Green" } else { "Yellow" })

if ($successCount -eq $totalCount) {
    Write-Host "`n✓ All HTML files generated successfully!" -ForegroundColor Green
} else {
    Write-Host "`n⚠ Some transformations failed. Check error messages above." -ForegroundColor Yellow
}

# Copy HTML files to Quarto docs/data/ directory
if ($successCount -gt 0) {
    $docsDataDir = Join-Path $dir "..\..\docs\data"
    if (Test-Path $docsDataDir) {
        Write-Host "`n--- Copying to Quarto website ---" -ForegroundColor Cyan
        try {
            foreach ($transform in $transformations) {
                if (Test-Path $transform.Html) {
                    $destFile = Join-Path $docsDataDir (Split-Path $transform.Html -Leaf)
                    Copy-Item -Path $transform.Html -Destination $destFile -Force
                    Write-Host "  ✓ Copied: $(Split-Path $transform.Html -Leaf)" -ForegroundColor Green
                }
            }
            Write-Host "`n✓ HTML files copied to docs/data/ for Quarto website" -ForegroundColor Green
        }
        catch {
            Write-Host "  ⚠ Warning: Could not copy to docs/data/: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
}

Write-Host ""
