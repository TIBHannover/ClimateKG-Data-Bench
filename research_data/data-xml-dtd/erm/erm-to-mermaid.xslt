<?xml version="1.0" encoding="UTF-8"?>
<!--
  erm-to-mermaid.xslt
  Transforms erm-wikibase-mapping.xml into a Mermaid erDiagram (.mmd).

  Each entity block includes:
    datatype  field_name  "PID wikibase-label: notes"

  Relationship lines use the cardinality notation from the mapping.
  Cross-DTD relationship targets (e.g. SERIES, CHAPTER) are defined
  once in corpus-ar6 and referenced by later DTD sections.

  Run via generate-erm.ps1 or any XSLT 1.0 processor.
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text" encoding="UTF-8"/>

  <!-- Root: emit diagram header then process each DTD section -->
  <xsl:template match="/">
    <xsl:text>erDiagram&#10;&#10;</xsl:text>
    <xsl:apply-templates select="erm-mapping/dtd"/>
  </xsl:template>

  <!-- DTD section -->
  <xsl:template match="dtd">
    <!-- Section banner comment -->
    <xsl:text>    %% -- </xsl:text>
    <xsl:value-of select="@file"/>
    <xsl:text> ------------------------------------------&#10;</xsl:text>
    <xsl:text>    %% </xsl:text>
    <xsl:value-of select="@description"/>
    <xsl:text>&#10;</xsl:text>

    <!-- Entity QID legend line (e.g.  %% WORK=Q2  PUBLICATION=Q3  ...) -->
    <xsl:text>    %%</xsl:text>
    <xsl:for-each select="entity[string(@qid)]">
      <xsl:text>  </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>=</xsl:text>
      <xsl:value-of select="@qid"/>
    </xsl:for-each>
    <xsl:text>&#10;&#10;</xsl:text>

    <!-- Entity blocks -->
    <xsl:apply-templates select="entity"/>

    <!-- Relationship lines -->
    <xsl:apply-templates select="relationship"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- Entity block -->
  <xsl:template match="entity">
    <xsl:text>    </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text> {&#10;</xsl:text>
    <xsl:apply-templates select="field"/>
    <xsl:text>    }&#10;</xsl:text>
  </xsl:template>

  <!-- Field / attribute line -->
  <!--   Format:  datatype  name  "PID label: notes"                  -->
  <xsl:template match="field">
    <xsl:text>        </xsl:text>
    <xsl:value-of select="@datatype"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="@name"/>

    <!-- Build the comment string: PID + label [+ ": " + notes] -->
    <xsl:variable name="comment">
      <xsl:if test="string(@pid)">
        <xsl:value-of select="@pid"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:value-of select="@label"/>
      <xsl:if test="string(@notes)">
        <xsl:text>: </xsl:text>
        <xsl:value-of select="@notes"/>
      </xsl:if>
    </xsl:variable>

    <xsl:if test="string($comment)">
      <xsl:text> "</xsl:text>
      <!-- Replace any double-quotes in comment to keep Mermaid syntax valid -->
      <xsl:call-template name="strip-quotes">
        <xsl:with-param name="s" select="$comment"/>
      </xsl:call-template>
      <xsl:text>"</xsl:text>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- Relationship line -->
  <!--   Format:  FROM  cardinality  TO  :  "label"                   -->
  <xsl:template match="relationship">
    <xsl:text>    </xsl:text>
    <xsl:value-of select="@from"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="@cardinality"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="@to"/>
    <xsl:text> : "</xsl:text>
    <xsl:call-template name="strip-quotes">
      <xsl:with-param name="s" select="@label"/>
    </xsl:call-template>
    <xsl:text>"&#10;</xsl:text>
  </xsl:template>

  <!-- Strip double-quotes (Mermaid does not allow them in strings) -->
  <xsl:template name="strip-quotes">
    <xsl:param name="s"/>
    <xsl:choose>
      <xsl:when test="contains($s,'&quot;')">
        <xsl:value-of select="substring-before($s,'&quot;')"/>
        <xsl:text>'</xsl:text>
        <xsl:call-template name="strip-quotes">
          <xsl:with-param name="s" select="substring-after($s,'&quot;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$s"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
