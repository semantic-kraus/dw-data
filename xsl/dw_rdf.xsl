<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:tei="http://www.tei-c.org/ns/1.0"
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
      <xsl:when test="tei:title[@level = 'a']">
        <xsl:call-template name="create-bibl-F22-issue"/>
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
      <xsl:call-template name="get-F22-title"/>
    </xsl:variable>
    <xsl:variable name="id">
      <xsl:choose>
        <xsl:when
          test="tei:citedRange[@wholePeriodical = 'yes'] or tei:citedRange[@wholeText = 'yes']">
          <xsl:value-of select="tei:citedRange[@wholeText = 'yes']/@xml:id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@xml:id"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:text>sk:</xsl:text>
    <xsl:value-of select="$id"/>
    <xsl:text> a frbroo:F22_Self-Contained_Expression ;
  rdfs:label &quot;Expression: </xsl:text>
    <xsl:value-of select="$title"/>
    <xsl:text>&quot;@en .

</xsl:text>
  </xsl:template>

  <xsl:template name="create-bibl-F22-issue">

    <xsl:variable name="title">
      <xsl:call-template name="get-F22-title"/>
    </xsl:variable>
    <xsl:variable name="id">
      <xsl:choose>
        <xsl:when
          test="tei:citedRange[@wholePeriodical = 'yes'] or tei:citedRange[@wholeText = 'yes']">
          <xsl:value-of select="tei:citedRange[@wholeText = 'yes']/@xml:id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@xml:id"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="id-level-j">
      <xsl:choose>
        <xsl:when test="tei:title[@level = 'j']">
          <xsl:value-of select="translate(tei:date/@key, '#', '')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="translate(tei:title[@level = 'm']/@key, '#', '')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:text>sk:</xsl:text><xsl:value-of select="$id"/><xsl:text> a frbroo:F22_Self-Contained_Expression ;
  rdfs:label &quot;Expression: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:P165i_is_incorporated_in sk:</xsl:text><xsl:value-of select="$id-level-j"/><xsl:text> .
    
</xsl:text>

    <xsl:variable name="title-level-j">
      <xsl:choose>
        <xsl:when test="tei:title[@level = 'j']">
          <xsl:value-of select="concat('Issue: ', tei:title[@level='j'][1]/text())"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('Expression: ', tei:title[@level='m'][1]/text())"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:text>sk:</xsl:text><xsl:value-of select="$id-level-j"/><xsl:text> a frbroo:F22_Self-Contained_Expression ;
  rdfs:label &quot;Expression: </xsl:text><xsl:value-of select="$title-level-j"/><xsl:text>&quot;@en ;
  cidoc:P165_incorporates sk:</xsl:text><xsl:value-of select="$id"/><xsl:text> .
    
</xsl:text>
  </xsl:template>

  <!-- 
    
Diese F22 wird dann auch gleich Subjekt in ihrem eigenen Statement und mit einem rdfs:label ausgestattet. 

Zum label:

Wenn es einen title[@level="j"] gibt, dann lautet das label: "Issue: [title[@level="j"][1]/text()]"@en
Wenn es das nicht gibt, sondern nur ein title[@level="m"], dann "Expression: [title[@level="m"]/text()]"@en

Zur Text-URI: Das ist wieder dieselbe wie siehe oben, generiert entweder aus dem bibl/@xml:id oder aus citedRange[@wholeText="yes"]/@xml:id.

Also:

sk:[Ausgaben-URI] a frbroo:F22_Self-Contained_Expression ;

rdfs:label: "[label]"@en ;

cidoc:P165_incorporates [Text-URI] .  
  -->

  <xsl:template name="get-F22-title">
    <xsl:choose>
      <xsl:when test="tei:title[@level = 'a']">
        <xsl:value-of
          select="replace(translate(tei:title[@level = 'a'][1], '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"
        />
      </xsl:when>
      <xsl:when test="tei:title[@level = 'm']">
        <xsl:value-of
          select="replace(translate(tei:title[@level = 'm'][1], '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"
        />
      </xsl:when>
      <xsl:otherwise> </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
