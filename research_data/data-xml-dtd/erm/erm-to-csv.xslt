<?xml version="1.0" encoding="UTF-8"?>
<!--
  erm-to-csv.xslt
  Transforms erm-wikibase-mapping.xml into a flat CSV.

  Output columns:
    dtd, entity, entity_qid, entity_label,
    field_name, wikibase_pid, wikibase_label, wikibase_datatype, notes

  Run via generate-erm.ps1 or any XSLT 1.0 processor.
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text" encoding="UTF-8"/>

  <!-- ── Header ──────────────────────────────────────────────────── -->
  <xsl:template match="/">
    <xsl:text>dtd,entity,entity_qid,entity_label,field_name,wikibase_pid,wikibase_label,wikibase_datatype,notes&#10;</xsl:text>
    <xsl:apply-templates select="//dtd/entity/field"/>
  </xsl:template>

  <!-- ── One row per field ────────────────────────────────────────── -->
  <xsl:template match="field">
    <xsl:call-template name="csv-field">
      <xsl:with-param name="v" select="ancestor::dtd/@name"/>
    </xsl:call-template>
    <xsl:text>,</xsl:text>
    <xsl:call-template name="csv-field">
      <xsl:with-param name="v" select="parent::entity/@name"/>
    </xsl:call-template>
    <xsl:text>,</xsl:text>
    <xsl:call-template name="csv-field">
      <xsl:with-param name="v" select="parent::entity/@qid"/>
    </xsl:call-template>
    <xsl:text>,</xsl:text>
    <xsl:call-template name="csv-field">
      <xsl:with-param name="v" select="parent::entity/@label"/>
    </xsl:call-template>
    <xsl:text>,</xsl:text>
    <xsl:call-template name="csv-field">
      <xsl:with-param name="v" select="@name"/>
    </xsl:call-template>
    <xsl:text>,</xsl:text>
    <xsl:call-template name="csv-field">
      <xsl:with-param name="v" select="@pid"/>
    </xsl:call-template>
    <xsl:text>,</xsl:text>
    <xsl:call-template name="csv-field">
      <xsl:with-param name="v" select="@label"/>
    </xsl:call-template>
    <xsl:text>,</xsl:text>
    <xsl:call-template name="csv-field">
      <xsl:with-param name="v" select="@datatype"/>
    </xsl:call-template>
    <xsl:text>,</xsl:text>
    <xsl:call-template name="csv-field">
      <xsl:with-param name="v" select="@notes"/>
    </xsl:call-template>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- ── Named template: RFC 4180 CSV quoting ─────────────────────── -->
  <!--   Wrap in double-quotes when value contains comma, quote or LF  -->
  <xsl:template name="csv-field">
    <xsl:param name="v"/>
    <xsl:choose>
      <xsl:when test="contains($v,',') or contains($v,'&quot;') or contains($v,'&#10;')">
        <xsl:text>"</xsl:text>
        <xsl:call-template name="escape-quotes">
          <xsl:with-param name="s" select="$v"/>
        </xsl:call-template>
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$v"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Double any embedded double-quotes (RFC 4180) -->
  <xsl:template name="escape-quotes">
    <xsl:param name="s"/>
    <xsl:choose>
      <xsl:when test="contains($s,'&quot;')">
        <xsl:value-of select="substring-before($s,'&quot;')"/>
        <xsl:text>""</xsl:text>
        <xsl:call-template name="escape-quotes">
          <xsl:with-param name="s" select="substring-after($s,'&quot;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$s"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
