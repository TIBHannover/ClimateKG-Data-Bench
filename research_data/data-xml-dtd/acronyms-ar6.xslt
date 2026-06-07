<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <title>IPCC AR6 Acronyms</title>
        <style>
          body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
            line-height: 1.6;
          }
          .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
          }
          h1 {
            color: #1a5490;
            border-bottom: 3px solid #1a5490;
            padding-bottom: 10px;
            margin-bottom: 20px;
          }
          .header-meta {
            color: #666;
            margin-bottom: 20px;
            font-size: 0.95em;
          }
          .header-meta strong {
            color: #333;
          }
          .acronym-stats {
            display: flex;
            gap: 20px;
            margin: 20px 0;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 5px;
            flex-wrap: wrap;
          }
          .stat-item {
            text-align: center;
            padding: 10px 20px;
          }
          .stat-item strong {
            display: block;
            font-size: 1.8em;
            color: #1a5490;
          }
          .search-box {
            margin: 20px 0;
          }
          .search-box input {
            width: 100%;
            padding: 12px;
            font-size: 1em;
            border: 2px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
          }
          .search-box input:focus {
            outline: none;
            border-color: #1a5490;
          }
          .acronym-list {
            margin-top: 20px;
          }
          .acronym {
            margin-bottom: 15px;
            padding: 15px;
            background-color: #fafafa;
            border-left: 4px solid #1a5490;
            border-radius: 4px;
          }
          .acronym-code {
            font-size: 1.3em;
            font-weight: bold;
            color: #1a5490;
            font-family: 'Courier New', monospace;
            margin-bottom: 8px;
          }
          .acronym-description {
            color: #333;
            margin: 5px 0;
            padding-left: 10px;
          }
          .description-item {
            margin: 5px 0;
          }
          .report-badges {
            margin-top: 8px;
          }
          .report-badge {
            display: inline-block;
            padding: 3px 10px;
            margin-right: 5px;
            border-radius: 3px;
            font-size: 0.85em;
            font-weight: 500;
          }
          .report-badge.wgi {
            background-color: #e3f2fd;
            color: #0d47a1;
          }
          .report-badge.wgii {
            background-color: #f3e5f5;
            color: #6a1b9a;
          }
          .report-badge.wgiii {
            background-color: #e8f5e9;
            color: #2e7d32;
          }
          .report-badge.sr15 {
            background-color: #fff3e0;
            color: #e65100;
          }
          .report-badge.srccl {
            background-color: #fce4ec;
            color: #c2185b;
          }
          .report-badge.srocc {
            background-color: #e0f2f1;
            color: #00695c;
          }
          .source-note {
            font-size: 0.85em;
            color: #888;
            font-style: italic;
          }
        </style>
        <script>
          function filterAcronyms() {
            var input = document.getElementById('searchInput');
            var filter = input.value.toLowerCase();
            var acronymList = document.getElementById('acronymList');
            var acronyms = acronymList.getElementsByClassName('acronym');
            
            for (var i = 0; i &lt; acronyms.length; i++) {
              var acronymText = acronyms[i].textContent || acronyms[i].innerText;
              if (acronymText.toLowerCase().indexOf(filter) &gt; -1) {
                acronyms[i].style.display = '';
              } else {
                acronyms[i].style.display = 'none';
              }
            }
          }
        </script>
      </head>
      <body>
        <div class="container">
          <h1>IPCC AR6 Acronyms</h1>
          <div class="header-meta">
            <strong>Source:</strong> IPCC Assessment Report 6<br/>
            Comprehensive list of acronyms used across IPCC AR6 reports
          </div>
          
          <div class="acronym-stats">
            <div class="stat-item">
              <strong><xsl:value-of select="count(//acronym)"/></strong>
              acronyms
            </div>
            <div class="stat-item">
              <strong><xsl:value-of select="count(//acronym[reports/report='WGI'])"/></strong>
              WGI
            </div>
            <div class="stat-item">
              <strong><xsl:value-of select="count(//acronym[reports/report='WGII'])"/></strong>
              WGII
            </div>
            <div class="stat-item">
              <strong><xsl:value-of select="count(//acronym[reports/report='WGIII'])"/></strong>
              WGIII
            </div>
            <div class="stat-item">
              <strong><xsl:value-of select="count(//acronym[reports/report='SR1.5'])"/></strong>
              SR1.5
            </div>
          </div>
          
          <div class="search-box">
            <input type="text" id="searchInput" placeholder="🔍 Search acronyms..." onkeyup="filterAcronyms()"/>
          </div>
          
          <div class="acronym-list" id="acronymList">
            <xsl:apply-templates select="//acronym">
              <xsl:sort select="code"/>
            </xsl:apply-templates>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="acronym">
    <div class="acronym">
      <div class="acronym-code">
        <xsl:value-of select="code"/>
      </div>
      
      <div class="acronym-description">
        <xsl:for-each select="descriptions/description">
          <div class="description-item">
            <xsl:value-of select="."/>
            <xsl:if test="@source">
              <span class="source-note"> (<xsl:value-of select="@source"/>)</span>
            </xsl:if>
          </div>
        </xsl:for-each>
      </div>
      
      <xsl:if test="reports/report">
        <div class="report-badges">
          <xsl:for-each select="reports/report">
            <xsl:variable name="reportLower" select="translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ.', 'abcdefghijklmnopqrstuvwxyz')"/>
            <span class="report-badge {$reportLower}">
              <xsl:value-of select="."/>
            </span>
          </xsl:for-each>
        </div>
      </xsl:if>
    </div>
  </xsl:template>
  
</xsl:stylesheet>
