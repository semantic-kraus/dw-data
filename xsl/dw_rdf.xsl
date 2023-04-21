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
        <xsl:call-template name="create-bibl-F24-issue"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="create-bibl-F22"/>
        <xsl:call-template name="create-bibl-F24"/>
      </xsl:otherwise>
    </xsl:choose>
    
    <xsl:if test="tei:title[@level = 'j']">
      <xsl:call-template name="create-bibl-F24-periodical"/>
    </xsl:if>
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
  rdfs:label &quot;Expression: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en .

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

    <xsl:variable name="uri-issue">
      <xsl:call-template name="get-issue-uri"/>
    </xsl:variable>

    <xsl:text>sk:</xsl:text><xsl:value-of select="$id"/><xsl:text> a frbroo:F22_Self-Contained_Expression ;
  rdfs:label &quot;Expression: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:P165i_is_incorporated_in sk:</xsl:text><xsl:value-of select="$uri-issue"/><xsl:text> .
    
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

    <xsl:text>sk:</xsl:text><xsl:value-of select="$uri-issue"/><xsl:text> a frbroo:F22_Self-Contained_Expression ;
  rdfs:label &quot;Expression: </xsl:text><xsl:value-of select="$title-level-j"/><xsl:text>&quot;@en ;
  cidoc:P165_incorporates sk:</xsl:text><xsl:value-of select="$id"/><xsl:text> .
    
</xsl:text>
  </xsl:template>

  <xsl:template name="create-bibl-F24">
    
    <xsl:variable name="title">
      <xsl:call-template name="get-F24-title"/>
    </xsl:variable>
    <xsl:variable name="uri-f22">
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
    <xsl:variable name="uri-f24">
      <xsl:call-template name="get-F24-uri"/>
    </xsl:variable>
    
    <xsl:text>sk:</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text> a frbroo:F24_Publication_Expression ;
  rdfs:label &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:P165_incorporates sk:</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text> .

</xsl:text>
  </xsl:template>
  
  <xsl:template name="create-bibl-F24-periodical">
    
    <xsl:variable name="title" select="tei:title[@level='j'][1]/text()"/>

    <xsl:variable name="uri-period">
      <xsl:call-template name="get-periodical-uri"/>
    </xsl:variable>
    <xsl:variable name="uri-issue">
      <xsl:call-template name="get-issue-uri"/>
    </xsl:variable>
    
    <xsl:text>sk:</xsl:text><xsl:value-of select="$uri-period"/><xsl:text> a frbroo:F24_Publication_Expression ;
  rdfs:label &quot;Periodical: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  frbroo:R5_has_component sk:</xsl:text><xsl:value-of select="$uri-issue"/><xsl:text> .

</xsl:text>
  </xsl:template>
    
  <xsl:template name="create-bibl-F24-issue">
      <xsl:variable name="title">
        <xsl:call-template name="get-F24-title"/>
      </xsl:variable>
      <xsl:variable name="uri-f22">
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
      <xsl:variable name="uri-f24">
        <xsl:call-template name="get-F24-uri"/>
      </xsl:variable>
      
      <xsl:variable name="uri-issue">
        <xsl:call-template name="get-issue-uri"/>
      </xsl:variable>
      
      <xsl:text>sk:</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text> a frbroo:F24_Publication_Expression ;
  rdfs:label &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en </xsl:text>
      <xsl:if test="tei:title[level='j']">
        <xsl:variable name="uri-period">
          <xsl:call-template name="get-periodical-uri"/>
        </xsl:variable>
        <xsl:text>;
  frbrooR5i_is_component_of sk:</xsl:text><xsl:value-of select="$uri-period"/>
      </xsl:if>
  <xsl:text>;
  cidoc:P165_incorporates sk:</xsl:text><xsl:value-of select="$uri-issue"/><xsl:text> .

</xsl:text>
    </xsl:template>

  <xsl:template name="get-issue-uri">
    <xsl:variable name="uri">
      <xsl:choose>
        <xsl:when test="tei:title[@level = 'j']">
          <xsl:value-of select="tei:date/@key"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="tei:title[@level = 'm']/@key"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>  
    <xsl:value-of select="translate($uri, '#', '')" />
  </xsl:template>
  
  <xsl:template name="get-periodical-uri">
    <xsl:value-of select="concat(translate(tei:title[@level = 'j']/@key, '#', ''), '/published-expression')" />
  </xsl:template>

  <xsl:template name="get-F24-uri">
    <xsl:variable name="uri">      
      <xsl:choose>
        <xsl:when test="tei:title[@level = 'a']">
          <xsl:choose>
            <xsl:when test="tei:date[@key]">
              <xsl:value-of select="tei:date/@key"/>
            </xsl:when>
            <xsl:otherwise> 
              <xsl:value-of select="tei:title[@level = 'm']/@key"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="tei:citedRange[@wholeText='yes']">
              <xsl:value-of select="tei:citedRange[@wholeText='yes']/@xml:id"/>
            </xsl:when>
            <xsl:otherwise> 
              <xsl:value-of select="@xml:id"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:value-of select="concat(translate($uri, '#', ''), '/published-expression')"/>
  </xsl:template>
 
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

  <xsl:template name="get-F24-title">
    <xsl:variable name="title">
      <xsl:choose>
        <xsl:when test="tei:title[@level = 'a'] and tei:title[@level = 'j']">
          <xsl:value-of select="tei:title[@level = 'j'][1]/text()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="tei:title[@level = 'm'][1]/text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="concat('Published Expression: ', replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' '))" />
  </xsl:template>
  
</xsl:stylesheet>
