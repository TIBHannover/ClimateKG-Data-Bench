<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  
  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <title>IPCC AR6 Authors</title>
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
          .header-meta a {
            color: #1a5490;
            text-decoration: none;
          }
          .header-meta a:hover {
            text-decoration: underline;
          }
          .author-stats {
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
          .author-list {
            margin-top: 20px;
          }
          .author {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #fafafa;
            border-left: 4px solid #1a5490;
            border-radius: 4px;
          }
          .author-name {
            font-size: 1.3em;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
          }
          .author-details {
            color: #666;
            margin: 5px 0;
            font-size: 0.95em;
          }
          .author-details strong {
            color: #444;
          }
          .contributions {
            margin-top: 10px;
          }
          .contribution {
            margin: 8px 0;
            padding: 8px 12px;
            background-color: white;
            border-radius: 3px;
            border-left: 2px solid #ccc;
          }
          .contribution-report {
            font-weight: bold;
            color: #1a5490;
          }
          .contribution-role {
            display: inline-block;
            padding: 2px 8px;
            background-color: #e3f2fd;
            color: #0d47a1;
            border-radius: 3px;
            font-size: 0.85em;
            margin-left: 5px;
          }
          .contribution-chapter {
            color: #555;
            font-size: 0.9em;
            margin-top: 3px;
          }
          .gender-badge {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 3px;
            font-size: 0.85em;
            margin-left: 5px;
          }
          .gender-F {
            background-color: #f3e5f5;
            color: #6a1b9a;
          }
          .gender-M {
            background-color: #e3f2fd;
            color: #1565c0;
          }
        </style>
        <script>
          function filterAuthors() {
            var input = document.getElementById('searchInput');
            var filter = input.value.toLowerCase();
            var authorList = document.getElementById('authorList');
            var authors = authorList.getElementsByClassName('author');
            
            for (var i = 0; i &lt; authors.length; i++) {
              var authorText = authors[i].textContent || authors[i].innerText;
              if (authorText.toLowerCase().indexOf(filter) &gt; -1) {
                authors[i].style.display = '';
              } else {
                authors[i].style.display = 'none';
              }
            }
          }
        </script>
      </head>
      <body>
        <div class="container">
          <h1>IPCC AR6 Authors</h1>
          <div class="header-meta">
            <strong>Source:</strong> <a href="https://apps.ipcc.ch/report/authors/">https://apps.ipcc.ch/report/authors/</a><br/>
            IPCC Assessment Report 6 Author Directory
          </div>
          
          <div class="author-stats">
            <div class="stat-item">
              <strong><xsl:value-of select="count(//author)"/></strong>
              authors
            </div>
            <div class="stat-item">
              <strong><xsl:value-of select="count(//contribution)"/></strong>
              contributions
            </div>
            <div class="stat-item">
              <strong><xsl:value-of select="count(//author[gender='F'])"/></strong>
              Female
            </div>
            <div class="stat-item">
              <strong><xsl:value-of select="count(//author[gender='M'])"/></strong>
              Male
            </div>
          </div>
          
          <div class="search-box">
            <input type="text" id="searchInput" placeholder="🔍 Search authors by name, country, affiliation..." onkeyup="filterAuthors()"/>
          </div>
          
          <div class="author-list" id="authorList">
            <xsl:apply-templates select="//author">
              <xsl:sort select="last_name"/>
            </xsl:apply-templates>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="author">
    <div class="author">
      <div class="author-name">
        <xsl:value-of select="concat(first_name, ' ', last_name)"/>
        <xsl:if test="gender">
          <span class="gender-badge gender-{gender}">
            <xsl:value-of select="gender"/>
          </span>
        </xsl:if>
      </div>
      
      <xsl:if test="citizenship">
        <div class="author-details">
          <strong>Citizenship:</strong> <xsl:value-of select="citizenship"/>
        </div>
      </xsl:if>
      
      <xsl:if test="country_of_residence">
        <div class="author-details">
          <strong>Country of Residence:</strong> <xsl:value-of select="country_of_residence"/>
        </div>
      </xsl:if>
      
      <xsl:if test="affiliation">
        <div class="author-details">
          <strong>Affiliation:</strong> <xsl:value-of select="affiliation"/>
        </div>
      </xsl:if>
      
      <xsl:if test="chapter_contributions/contribution">
        <div class="contributions">
          <strong>Contributions:</strong>
          <xsl:apply-templates select="chapter_contributions/contribution"/>
        </div>
      </xsl:if>
    </div>
  </xsl:template>
  
  <xsl:template match="contribution">
    <div class="contribution">
      <span class="contribution-report">
        <xsl:value-of select="@report"/>
      </span>
      <span class="contribution-role">
        <xsl:value-of select="role"/>
      </span>
      <div class="contribution-chapter">
        <xsl:value-of select="@chapter"/>
      </div>
    </div>
  </xsl:template>
  
</xsl:stylesheet>
