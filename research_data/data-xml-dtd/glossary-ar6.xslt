<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta charset="UTF-8"/>
        <title>IPCC Glossary</title>
        <style>
          body{font-family:system-ui,sans-serif;max-width:1200px;margin:0 auto;padding:1.5em;color:#1a1a1a;background:#fafafa}
          h1{color:#1a3a5c;margin-bottom:.25em;border-bottom:3px solid #1e5282;padding-bottom:.5em}
          .header-meta{color:#555;margin-bottom:2em;padding:1em;background:#fff;border-left:4px solid #1e5282}
          .header-meta a{color:#1e5282}
          .glossary-stats{display:flex;gap:2em;margin:1em 0;font-size:.9em;color:#666}
          .stat-item{background:#fff;padding:.5em 1em;border-radius:4px}
          .search-box{margin:1.5em 0;padding:1em;background:#fff;border-radius:6px}
          .search-box input{width:100%;padding:.6em;font-size:1em;border:2px solid #ddd;border-radius:4px}
          .search-box input:focus{outline:none;border-color:#1e5282}
          .term-list{display:grid;gap:1em}
          .term{background:#fff;padding:1em 1.2em;border-left:4px solid #c8d8ea;border-radius:4px;transition:all .2s}
          .term:hover{border-left-color:#1e5282;box-shadow:0 2px 8px rgba(0,0,0,.08)}
          .term-name{font-weight:700;font-size:1.1em;color:#1a3a5c;margin-bottom:.3em}
          .term-aka{font-size:.85em;color:#666;margin-bottom:.5em;font-style:italic}
          .term-def{line-height:1.6;color:#333;margin:.5em 0}
          .series-badges{margin-top:.5em;display:flex;gap:.3em;flex-wrap:wrap}
          .series-badge{display:inline-block;background:#dbeafe;color:#1e3a8f;border-radius:3px;padding:2px 8px;font-size:.75em;font-weight:600}
          .series-badge.wgi{background:#fef3c7;color:#92400e}
          .series-badge.wgii{background:#dbeafe;color:#1e3a8a}
          .series-badge.wgiii{background:#d1fae5;color:#065f46}
          .series-badge.sr15{background:#fce7f3;color:#831843}
          .series-badge.srccl{background:#e0f2f1;color:#00695c}
          .series-badge.srocc{background:#fff3e0;color:#e65100}
        </style>
        <script>
          function filterTerms() {
            var input = document.getElementById('searchInput');
            var filter = input.value.toLowerCase();
            var termList = document.getElementById('termList');
            var terms = termList.getElementsByClassName('term');
            
            for (var i = 0; i &lt; terms.length; i++) {
              var termText = terms[i].textContent || terms[i].innerText;
              if (termText.toLowerCase().indexOf(filter) &gt; -1) {
                terms[i].style.display = '';
              } else {
                terms[i].style.display = 'none';
              }
            }
          }
        </script>
      </head>
      <body>
        <h1>IPCC Glossary</h1>
        <div class="header-meta">
          <strong>Version:</strong><xsl:value-of select="//metadata/version"/>  • 
          <strong>Date:</strong><xsl:value-of select="//metadata/date"/>  • 
          <strong>Source:</strong><a href="{//metadata/source}"><xsl:value-of select="//metadata/source"/></a><br/>
          <xsl:value-of select="//metadata/description"/>
        </div>
        
        <div class="glossary-stats">
          <div class="stat-item">
            <strong><xsl:value-of select="count(//term)"/></strong> terms
          </div>
          <div class="stat-item">
            <strong><xsl:value-of select="count(//term[series/series_ref='WGI'])"/></strong> WGI
          </div>
          <div class="stat-item">
            <strong><xsl:value-of select="count(//term[series/series_ref='WGII'])"/></strong> WGII
          </div>
          <div class="stat-item">
            <strong><xsl:value-of select="count(//term[series/series_ref='WGIII'])"/></strong> WGIII
          </div>
        </div>
        
        <div class="search-box">
          <input type="text" id="searchInput" placeholder="🔍 Search glossary terms..." onkeyup="filterTerms()"/>
        </div>
        
        <div class="term-list" id="termList">
          <xsl:apply-templates select="//term">
            <xsl:sort select="name"/>
          </xsl:apply-templates>
        </div>
        
        <script>
          document.getElementById('searchInput').focus();
        </script>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="term">
    <div class="term">
      <div class="term-name">
        <xsl:value-of select="name"/>
      </div>
      
      <xsl:if test="also_known_as">
        <div class="term-aka">
          Also known as: <xsl:value-of select="also_known_as"/>
        </div>
      </xsl:if>
      
      <div class="term-def">
        <xsl:value-of select="definition"/>
      </div>
      
      <xsl:if test="series/series_ref">
        <div class="series-badges">
          <xsl:for-each select="series/series_ref">
            <xsl:variable name="seriesLower" select="translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
            <span class="series-badge {$seriesLower}">
              <xsl:value-of select="."/> (<xsl:value-of select="@qid"/>)
            </span>
          </xsl:for-each>
        </div>
      </xsl:if>
    </div>
  </xsl:template>
  
</xsl:stylesheet>
