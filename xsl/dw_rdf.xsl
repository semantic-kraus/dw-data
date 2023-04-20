<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
  <xsl:output method="text" encoding="UTF-8" media-type="text/plain" indent="no"/>
  <xsl:strip-space elements="*"/>
  
  <xsl:template match="/">
    <xsl:call-template name="get-header"/>
    
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:teiHeader"/>
  <xsl:template match="tei:facsimile"/>
  
  <xsl:template match="tei:bibl">
    
    <xsl:choose>
      <xsl:when test="tei:citedRange[@wholePeriodical='yes'] or tei:citedRange[@wholeText='yes']">
        
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="create-bibl-F22"/>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
   
  <!-- functions aka. named templates -->

  <xsl:template name="get-header">
<xsl:text>@prefix cidoc: &lt;http://www.cidoc-crm.org/cidoc-crm/&gt; .
@prefix dcterms: &lt;http://purl.org/dc/terms/&gt; .    
@prefix frbroo: &lt;https://cidoc-crm.org/frbroo/sites/default/files/FRBR2.4-draft.rdfs#&gt; .
@prefix lk: &lt;https://sk.acdh.oeaw.ac.at/project/legal-kraus&gt; .
@prefix ns1: &lt;https://w3id.org/lso/intro/Vx/#&gt; .
@prefix rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt; .
@prefix rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt; .
@prefix schema: &lt;https://schema.org/&gt; .
@prefix sk: &lt;https://sk.acdh.oeaw.ac.at/&gt; .
@prefix xsd: &lt;http://www.w3.org/2001/XMLSchema#&gt; .

</xsl:text>
  </xsl:template>

  <xsl:template name="create-bibl-F22">
    
    <xsl:variable name="title">
      <xsl:choose>
        <xsl:when test="tei:title[@level='a']">
          <xsl:value-of select="tei:title[@level='a'][1]"/>
        </xsl:when>
        <xsl:when test="tei:title[@level='m']">
          <xsl:value-of select="tei:title[@level='m'][1]"/>
        </xsl:when>
        <xsl:otherwise>          
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:text>sk:</xsl:text><xsl:value-of select="@xml:id"/><xsl:text> a frbroo:F22_Self-Contained_Expression ;
  rdfs:label &quot;Expression: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en  .
    
</xsl:text>
  </xsl:template>

<!-- 
  -->

</xsl:stylesheet>
