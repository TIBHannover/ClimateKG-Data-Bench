# generate-erm.ps1
# Transforms erm-wikibase-mapping.xml using two XSLT stylesheets:
#   1. erm-to-csv.xslt     -> erm-mapping.csv
#   2. erm-to-mermaid.xslt -> er-diagram-wikibase.mmd

$ErrorActionPreference = "Stop"
$dir = $PSScriptRoot

Write-Host "`n=== ERM / Wikibase Mapping Transforms ===" -ForegroundColor Cyan
Write-Host "Source : $dir\erm-wikibase-mapping.xml" -ForegroundColor Gray

$source = "$dir\erm-wikibase-mapping.xml"

function Invoke-TextTransform {
    param(
        [string]$XmlFile,
        [string]$XsltFile,
        [string]$OutFile
    )

    $xslt = New-Object System.Xml.Xsl.XslCompiledTransform
    $xslt.Load($XsltFile)

    $settings = New-Object System.Xml.XmlReaderSettings
    # Mapping XML has no DTD -- use Ignore (safe default)
    $settings.DtdProcessing = [System.Xml.DtdProcessing]::Ignore

    $reader = [System.Xml.XmlReader]::Create($XmlFile, $settings)

    # Use StreamWriter with UTF-8 without BOM (Mermaid parser rejects BOM)
    $noBom = New-Object System.Text.UTF8Encoding($false)
    $sw = New-Object System.IO.StreamWriter($OutFile, $false, $noBom)

    try {
        $xslt.Transform($reader, $null, $sw)
    }
    finally {
        $reader.Close()
        $sw.Close()
    }

    $sizeKB = [math]::Round((Get-Item $OutFile).Length / 1KB, 2)
    Write-Host "  OK  $OutFile ($sizeKB KB)" -ForegroundColor Green
}

# 1. CSV
Write-Host "`nGenerating CSV..." -ForegroundColor Yellow
Invoke-TextTransform `
    -XmlFile  $source `
    -XsltFile "$dir\erm-to-csv.xslt" `
    -OutFile  "$dir\erm-mapping.csv"

# 2. Mermaid
Write-Host "Generating Mermaid diagram..." -ForegroundColor Yellow
Invoke-TextTransform `
    -XmlFile  $source `
    -XsltFile "$dir\erm-to-mermaid.xslt" `
    -OutFile  "$dir\er-diagram-wikibase.mmd"

Write-Host "`nDone." -ForegroundColor Cyan
