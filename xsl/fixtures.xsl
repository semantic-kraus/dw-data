<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
  <xsl:output method="xml" encoding="UTF-8" media-type="text/xml" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/">
    <xsl:apply-templates select="node()|@*"/>
  </xsl:template>
  <xsl:template match="//tei:idno[@type='GND']">
    <xsl:copy>
      <xsl:attribute name="type">GND</xsl:attribute>
      <xsl:value-of select="concat('https://d-nb.info/gnd/', .)"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="//tei:idno[@type='VIAF']">
    <xsl:copy>
      <xsl:attribute name="type">VIAF</xsl:attribute>
      <xsl:value-of select="concat('https://viaf.org/viaf/', .)"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
