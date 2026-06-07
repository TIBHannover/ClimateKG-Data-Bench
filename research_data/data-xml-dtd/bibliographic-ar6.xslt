<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <title>IPCC AR6 Bibliographic Data</title>
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
          .biblio-stats {
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
          .biblio-list {
            margin-top: 20px;
          }
          .biblio-item {
            margin-bottom: 25px;
            padding: 20px;
            background-color: #fafafa;
            border-left: 4px solid #1a5490;
            border-radius: 4px;
          }
          .item-label {
            font-size: 1.4em;
            font-weight: bold;
            color: #1a5490;
            margin-bottom: 10px;
          }
          .item-type {
            display: inline-block;
            padding: 3px 10px;
            background-color: #e3f2fd;
            color: #0d47a1;
            border-radius: 3px;
            font-size: 0.85em;
            margin-left: 10px;
          }
          .item-qid {
            font-family: 'Courier New', monospace;
            color: #666;
            font-size: 0.9em;
            margin-left: 5px;
          }
          .statements {
            margin-top: 15px;
          }
          .statement {
            margin: 10px 0;
            padding: 10px;
            background-color: white;
            border-radius: 3px;
          }
          .statement-prop {
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
          }
          .statement-value {
            color: #555;
            margin-left: 10px;
          }
          .statement-value a {
            color: #1a5490;
            text-decoration: none;
          }
          .statement-value a:hover {
            text-decoration: underline;
          }
          .reference {
            margin-top: 5px;
            padding: 5px 10px;
            background-color: #f8f9fa;
            border-left: 2px solid #ccc;
            font-size: 0.85em;
            color: #666;
          }
          .reference-item {
            margin: 2px 0;
          }
          .abstract {
            max-height: 150px;
            overflow: hidden;
            transition: max-height 0.3s ease;
          }
          .abstract.expanded {
            max-height: none;
          }
          .expand-link {
            color: #1a5490;
            cursor: pointer;
            text-decoration: underline;
            font-size: 0.9em;
            margin-top: 5px;
            display: inline-block;
          }
        </style>
        <script>
          function filterItems() {
            var input = document.getElementById('searchInput');
            var filter = input.value.toLowerCase();
            var biblioList = document.getElementById('biblioList');
            var items = biblioList.getElementsByClassName('biblio-item');
            
            for (var i = 0; i &lt; items.length; i++) {
              var itemText = items[i].textContent || items[i].innerText;
              if (itemText.toLowerCase().indexOf(filter) &gt; -1) {
                items[i].style.display = '';
              } else {
                items[i].style.display = 'none';
              }
            }
          }
          
          function toggleAbstract(element) {
            var abstract = element.previousElementSibling;
            abstract.classList.toggle('expanded');
            element.textContent = abstract.classList.contains('expanded') ? 'Show less' : 'Show more';
          }
        </script>
      </head>
      <body>
        <div class="container">
          <h1>IPCC AR6 Bibliographic Data</h1>
          <div class="header-meta">
            <strong>Generated:</strong> <xsl:value-of select="//bibliographic-enrichment/@generated"/><br/>
            <strong>Source:</strong> Crossref DOI enrichment data<br/>
            Comprehensive bibliographic metadata for IPCC AR6 reports
          </div>
          
          <div class="biblio-stats">
            <div class="stat-item">
              <strong><xsl:value-of select="count(//item)"/></strong>
              items
            </div>
            <div class="stat-item">
              <strong><xsl:value-of select="count(//item[@type='Series'])"/></strong>
              series
            </div>
            <div class="stat-item">
              <strong><xsl:value-of select="count(//statement)"/></strong>
              statements
            </div>
          </div>
          
          <div class="search-box">
            <input type="text" id="searchInput" placeholder="🔍 Search bibliographic entries..." onkeyup="filterItems()"/>
          </div>
          
          <div class="biblio-list" id="biblioList">
            <xsl:apply-templates select="//item"/>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="item">
    <div class="biblio-item">
      <div class="item-label">
        <xsl:value-of select="@label"/>
        <span class="item-type">
          <xsl:value-of select="@type"/>
        </span>
        <span class="item-qid">
          <xsl:value-of select="@qid"/>
        </span>
      </div>
      
      <xsl:if test="statement">
        <div class="statements">
          <xsl:apply-templates select="statement"/>
        </div>
      </xsl:if>
    </div>
  </xsl:template>
  
  <xsl:template match="statement">
    <div class="statement">
      <div class="statement-prop">
        <xsl:value-of select="@prop"/>:
      </div>
      <div class="statement-value">
        <xsl:choose>
          <xsl:when test="@datatype='url'">
            <a href="{@value}" target="_blank">
              <xsl:value-of select="@value"/>
            </a>
          </xsl:when>
          <xsl:when test="@prop='Abstract (DOI)'">
            <div class="abstract" id="abstract-{generate-id()}">
              <xsl:value-of select="@value"/>
            </div>
            <span class="expand-link" onclick="toggleAbstract(this)">Show more</span>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@value"/>
          </xsl:otherwise>
        </xsl:choose>
      </div>
      
      <xsl:if test="reference">
        <div class="reference">
          <xsl:apply-templates select="reference"/>
        </div>
      </xsl:if>
    </div>
  </xsl:template>
  
  <xsl:template match="reference">
    <xsl:for-each select="ref">
      <div class="reference-item">
        <xsl:choose>
          <xsl:when test="@pid='P17'">
            <strong>Reference URL:</strong> <a href="{@value}" target="_blank"><xsl:value-of select="@value"/></a>
          </xsl:when>
          <xsl:when test="@pid='P18'">
            <strong>Retrieved:</strong> <xsl:value-of select="@value"/>
          </xsl:when>
          <xsl:when test="@pid='P19'">
            <strong>Source:</strong> <xsl:value-of select="@value"/>
          </xsl:when>
          <xsl:otherwise>
            <strong><xsl:value-of select="@pid"/>:</strong> <xsl:value-of select="@value"/>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>
