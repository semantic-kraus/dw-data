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
        <xsl:call-template name="create-bibl-F22-art-issue"/>
        <xsl:call-template name="create-INT16-segment"/>
        <xsl:call-template name="create-F28"/>
        <xsl:call-template name="create-E52-creation-timespan"/>
        <xsl:call-template name="create-F22-title-art-issue"/>
        <xsl:call-template name="create-F22-subtitle-art-issue"/>
        <xsl:call-template name="create-bibl-F22-issue"/>
        <xsl:call-template name="create-F22-title-issue"/>
        <xsl:call-template name="create-bibl-F24-issue"/>
      </xsl:when>
      <xsl:when test="tei:editor">
        <xsl:call-template name="create-bibl-F22-art-edissue"/>
        <xsl:call-template name="create-F22-title-art-edissue"/>
        <xsl:call-template name="create-F22-subtitle-art-edissue"/>
        <xsl:call-template name="create-bibl-F24-issue"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="create-bibl-F22"/>
        <xsl:call-template name="create-F28"/>
        <xsl:call-template name="create-E52-creation-timespan"/>
        <xsl:call-template name="create-F22-title"/>
        <xsl:call-template name="create-F22-subtitle"/>
        <xsl:call-template name="create-bibl-F24"/>
      </xsl:otherwise>
    </xsl:choose>    
    
    <xsl:call-template name="create-F30-issue"/>
    <xsl:call-template name="create-E52-publication-timespan"/>
    <xsl:call-template name="create-F31"/>
    <xsl:call-template name="create-E52-performance-timespan"/>
    
    <xsl:choose>
      <xsl:when test="tei:title[@level = 'j'] and tei:date">
          <xsl:call-template name="create-bibl-F24-periodical"/>
          <xsl:call-template name="create-bibl-F24-appellation-periodical"/>
          <xsl:call-template name="create-F24-appellation-title0-periodical"/>
          <xsl:call-template name="create-F24-appellation-title1-periodical"/>
          <xsl:call-template name="create-F24-appellation-date-periodical"/>
          <xsl:call-template name="create-F24-appellation-datenote-periodical"/>
          <xsl:call-template name="create-F24-appellation-place-periodical"/>
          <xsl:call-template name="create-F24-appellation-num-periodical"/>
          <xsl:call-template name="create-F24-appellation-edition-periodical"/>
      </xsl:when>
      <xsl:when test="not(tei:date) or tei:date/tei:note/text()='UA' or tei:date/tei:note/text()='Entst.'"></xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="create-F24-appellation"/>
        <xsl:call-template name="create-F24-appellation-title0"/>
        <xsl:call-template name="create-F24-appellation-title1"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="create-INT1-textpassage"/>    
    <xsl:call-template name="create-INT1-INT16-segment"/>
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
    <xsl:variable name="uri-f22">
      <xsl:call-template name="get-F22-uri"/>      
    </xsl:variable>
    <xsl:text>#F22
</xsl:text>
    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>&gt; a frbroo:F22_Self-Contained_Expression ;
  rdfs:label &quot;Expression: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:P102_has_title &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>/title/0&gt;</xsl:text>    
    <xsl:if test="tei:title[@level='m' and @type='subtitle']">
      <xsl:text> ;
  cidoc:P102_has_title &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>/title/1&gt;</xsl:text>   
    </xsl:if>
    <xsl:text> .
    
</xsl:text>  </xsl:template>

  <xsl:template name="create-bibl-F22-art-issue">
    <xsl:variable name="title">
      <xsl:call-template name="get-F22-title"/>
    </xsl:variable>
    <xsl:variable name="uri-f22">
      <xsl:call-template name="get-F22-uri"/>
    </xsl:variable>
    <xsl:variable name="uri-issue">
      <xsl:call-template name="get-issue-uri"/>
    </xsl:variable>

    <xsl:text>#F22 art-issue
</xsl:text>
    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>&gt; a frbroo:F22_Self-Contained_Expression ;
  rdfs:label &quot;Expression: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:P102_has_title &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>/title/0&gt;</xsl:text>    
    <xsl:if test="tei:title[@level='a' and @type='subtitle']">
      <xsl:text> ;
  cidoc:P102_has_title &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>/title/1&gt;</xsl:text>   
    </xsl:if>
    <xsl:text> ;  
  cidoc:P165i_is_incorporated_in &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-issue"/><xsl:text>&gt; .
    
</xsl:text>
  </xsl:template>
  
  <xsl:template name="create-INT16-segment">
    <xsl:variable name="title">
      <xsl:call-template name="get-F22-title"/>
    </xsl:variable>
    <xsl:variable name="uri-f22">
      <xsl:call-template name="get-F22-uri"/>
    </xsl:variable>
    <xsl:variable name="uri-issue">
      <xsl:call-template name="get-issue-uri"/>
    </xsl:variable>
    
    <xsl:text>#INT16 segment
</xsl:text>
    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>/segment&gt; a ns1:INT16_Segment ;
  rdfs:label &quot;Segment: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  ns1:R16_incorporates &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>&gt;</xsl:text>    
    <xsl:if test="tei:biblScope">
      <xsl:text> ;
  ns1:R41_has_location &quot;</xsl:text><xsl:value-of select="tei:biblScope/text()"/><xsl:text>&quot;^^xsd:string ;</xsl:text>   
    </xsl:if>
    <xsl:text> ;  
  ns1:R25_is_segment_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-issue"/><xsl:text>/published-expression&gt; .
    
</xsl:text>
  </xsl:template>
  
  <xsl:template name="create-INT1-INT16-segment">
    <xsl:if test="tei:pubPlace">      
      <xsl:variable name="title">
        <xsl:call-template name="get-F22-title"/>
      </xsl:variable>
      <xsl:variable name="uri-f22">
        <xsl:call-template name="get-F22-uri"/>
      </xsl:variable>
      <xsl:variable name="uri-issue">
        <xsl:call-template name="get-issue-uri"/>
      </xsl:variable>
      <xsl:for-each select="tei:citedRange[not(@wholeText) and not(@wholePeriodical)]">
        <xsl:variable name="citedRange" select="replace(translate(text(), '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>  
        
        <xsl:text>#INT1-INT16 textpassage segment
</xsl:text>
        <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>/segment/</xsl:text><xsl:value-of select="position() - 1"/><xsl:text>&gt; a ns1:INT16_Segment ;
  rdfs:label &quot;Text segment from: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en</xsl:text>
        <xsl:if test="starts-with($citedRange, 'S. ')">
          <xsl:text> ;
  schema:pagination &quot;</xsl:text><xsl:value-of select="tei:biblScope/text()"/><xsl:text>&quot;</xsl:text>
        </xsl:if>
        <xsl:text> ;
  ns1:R16_incorporates &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>/passage/</xsl:text><xsl:value-of select="position() - 1"/><xsl:text>&gt;</xsl:text>
        <xsl:if test="$citedRange!=''">
          <xsl:text> ;
  ns1:R41_has_location &quot;</xsl:text><xsl:value-of select="$citedRange"/><xsl:text>&quot;^^xsd:string</xsl:text>   
        </xsl:if>
        <xsl:if test="tei:note[@type='context']">
          <xsl:text> ;
  ns1:R44_has_wording &quot;</xsl:text><xsl:value-of select="tei:note[@type='context']/text()"/><xsl:text>&quot;@und</xsl:text>
        </xsl:if>
        <xsl:text> .
    
</xsl:text>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-INT1-textpassage">    
      <xsl:variable name="title">
        <xsl:call-template name="get-F22-title"/>
      </xsl:variable>
      <xsl:variable name="uri-f22">
        <xsl:call-template name="get-F22-uri"/>
      </xsl:variable>
      <xsl:variable name="uri-issue">
        <xsl:call-template name="get-issue-uri"/>
      </xsl:variable>
  
      <xsl:for-each select="tei:citedRange[not(@wholeText) and not(@wholePeriodical)]">
        <xsl:variable name="citedRange" select="replace(translate(text(), '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>  
        
        <xsl:text>#INT1 textpassage 
</xsl:text>
        <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>/passage/</xsl:text><xsl:value-of select="position() - 1"/><xsl:text>&gt; a ns1:INT1_TextPassage ;
  rdfs:label &quot;Text passage from: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  ns1:R10_is_Text_Passage_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>&gt;</xsl:text>    
        <xsl:if test="not(starts-with($citedRange, 'S. '))">
          <xsl:text> ;
  ns1:R41_has_location &quot;</xsl:text><xsl:value-of select="$citedRange"/><xsl:text>&quot;^^xsd:string</xsl:text>   
        </xsl:if>
        <xsl:if test="tei:note[@type='context']">
          <xsl:text> ;
  ns1:R44_has_wording &quot;</xsl:text><xsl:value-of select="tei:note[@type='context']/text()"/><xsl:text>&quot;@und</xsl:text>
        </xsl:if>
        <xsl:text> .
    
</xsl:text>
      </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="create-bibl-F22-issue">

    <xsl:variable name="uri-f22">
      <xsl:call-template name="get-F22-uri"/>
    </xsl:variable>
    <xsl:variable name="uri-issue">
      <xsl:call-template name="get-issue-uri"/>
    </xsl:variable>
    <xsl:variable name="title">
      <xsl:call-template name="get-issue-title-text"/>
    </xsl:variable>

    <xsl:text>#F22 issue
</xsl:text>
    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-issue"/><xsl:text>&gt; a frbroo:F22_Self-Contained_Expression ;
  rdfs:label &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:P102_has_title &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-issue"/><xsl:text>/title/0&gt;</xsl:text>    
    <xsl:if test="tei:title[@level='a' and @type='subtitle']">
      <xsl:text> ;
  cidoc:P102_has_title &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-issue"/><xsl:text>/title/1&gt;</xsl:text>   
    </xsl:if>
    <xsl:text> ;  
  cidoc:P165_incorporates &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>&gt; .
    
</xsl:text>
  </xsl:template>

  <xsl:template name="create-bibl-F24">
    <xsl:if test="tei:date and not(tei:date/tei:note/text()='UA' or tei:date/tei:note/text()='Entst.')">
      <xsl:variable name="title">
        <xsl:call-template name="get-F24-title"/>
      </xsl:variable>
      <xsl:variable name="uri-f22">
        <xsl:call-template name="get-F22-uri"/>     
      </xsl:variable>
      <xsl:variable name="uri-f24">
        <xsl:call-template name="get-F24-uri"/>
      </xsl:variable>
      
      <xsl:text>#F24
</xsl:text>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/published-expression&gt; a frbroo:F24_Publication_Expression ;
  rdfs:label &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:P1_is_identified_by &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>/appellation/0&gt; ;
  cidoc:P165_incorporates &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>&gt; ;
  cidoc:R24i_was_created_through &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>/publication&gt; .

</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-bibl-F24-periodical">
    <xsl:if test="tei:date">      
      <xsl:variable name="title" select="tei:title[@level = 'j'][1]/text()"/>
  
      <xsl:variable name="uri-period">
        <xsl:call-template name="get-periodical-uri"/>
      </xsl:variable>
      <xsl:variable name="uri-issue">
        <xsl:call-template name="get-issue-uri"/>
      </xsl:variable>
  
      <xsl:text>#F24 periodical
</xsl:text>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-period"/><xsl:text>&gt; a frbroo:F24_Publication_Expression ;
  rdfs:label &quot;Periodical: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  frbroo:R5_has_component &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-issue"/><xsl:text>/published-expression&gt; .

</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-bibl-F24-issue">
    <xsl:if test="tei:date and not(tei:date/tei:note/text()='UA' or tei:date/tei:note/text()='Entst.')">      
      <xsl:variable name="title">
        <xsl:call-template name="get-F24-title"/>
      </xsl:variable>
      <xsl:variable name="uri-f22">
        <xsl:call-template name="get-F22-uri"/>
      </xsl:variable>
      <xsl:variable name="uri-f24">
        <xsl:call-template name="get-F24-uri"/>
      </xsl:variable>
      <xsl:variable name="uri-issue">
        <xsl:call-template name="get-issue-uri"/>
      </xsl:variable>
  
      <xsl:text>#F24 issue
</xsl:text>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/published-expression&gt; a frbroo:F24_Publication_Expression ;
  rdfs:label &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en </xsl:text>
      <xsl:if test="tei:title[level = 'j']">
        <xsl:variable name="uri-period">
          <xsl:call-template name="get-periodical-uri"/>
        </xsl:variable>
        <xsl:text>;
  frbrooR5i_is_component_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-period"/><xsl:text>&gt; </xsl:text>
      </xsl:if>
      <xsl:text>;
  cidoc:P1_is_identified_by &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation/0&gt; ;
  cidoc:P165_incorporates &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-issue"/><xsl:text>&gt; ;
  cidoc:R24i_was_created_through &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>/publication&gt; .

</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F22-title-art-issue">
    <xsl:text>#F22 title art-issue
</xsl:text>
    <xsl:call-template name="create-F22-title-param">
        <xsl:with-param name="title" select="tei:title[@level='a' and not(@type)]/text()"/>  
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="create-F22-subtitle-art-issue">
    <xsl:if test="tei:title[@level='a' and @type='subtitle']">        
      <xsl:text>#F22 subtitle art-issue
</xsl:text>
      <xsl:call-template name="create-F22-subtitle-art-issue-param">
        <xsl:with-param name="title" select="tei:title[@level='a' and @type='subtitle']/text()"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="create-F22-title-issue">
    <xsl:text>#F22 title issue
</xsl:text>
    <xsl:call-template name="create-F22-title-param">
      <xsl:with-param name="uri-f22">
        <xsl:call-template name="get-issue-uri"/>
      </xsl:with-param>
      <xsl:with-param name="title">
        <xsl:call-template name="get-issue-title"/>
      </xsl:with-param>  
    </xsl:call-template>    
  </xsl:template>
  
  <xsl:template name="create-F22-title">
    <xsl:text>#F22 title
</xsl:text>
    <xsl:call-template name="create-F22-title-param">
      <xsl:with-param name="title" select="tei:title[@level='m' and not(@type)]/text()"/>
    </xsl:call-template>    
  </xsl:template>
  
  <xsl:template name="create-F22-subtitle">
    <xsl:if test="tei:title[@level='m' and @type='subtitle']">      
      <xsl:text>#F22 subtitle
</xsl:text>
      <xsl:call-template name="create-F22-subtitle-param">
        <xsl:with-param name="title" select="tei:title[@level='m' and @type='subtitle']/text()"/>
      </xsl:call-template>    
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="create-bibl-F22-art-edissue">
    <xsl:variable name="title">
      <xsl:call-template name="get-F22-title"/>
    </xsl:variable>
    <xsl:variable name="uri-f22ed" select="translate(tei:title[@level='m']/@key, '#', '')"/>    
    <xsl:variable name="uri-issue">
      <xsl:call-template name="get-issue-uri"/>
    </xsl:variable>
    
    <xsl:text>#F22 art-edissue
</xsl:text>
    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22ed"/><xsl:text>&gt; a frbroo:F22_Self-Contained_Expression ;
  rdfs:label &quot;Expression: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:P102_has_title &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22ed"/><xsl:text>/title/0&gt;</xsl:text>    
    <xsl:if test="tei:title[@level='m' and @type='subtitle']">
      <xsl:text> ;
  cidoc:P102_has_title &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22ed"/><xsl:text>/title/1&gt;</xsl:text>   
    </xsl:if>
    <xsl:text> ;  
  cidoc:P165i_is_incorporated_in &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-issue"/><xsl:text>&gt; .
    
</xsl:text>
  </xsl:template>
  
  <xsl:template name="create-F22-title-art-edissue">
    <xsl:text>#F22 title art-edissue
</xsl:text>
    <xsl:call-template name="create-F22-title-param">
      <xsl:with-param name="title">
        <xsl:call-template name="get-issue-title"/>
      </xsl:with-param> 
      <xsl:with-param name="uri-f22" select="translate(tei:title[@level='m']/@key, '#', '')"/>
    </xsl:call-template>    
    
  </xsl:template>

  <xsl:template name="create-F22-subtitle-art-edissue">
    <xsl:if test="tei:title[@level='m' and @type='subtitle']">        
      <xsl:text>#F22 subtitle art-edissue
</xsl:text>
      <xsl:call-template name="create-F22-subtitle-art-issue-param">
        <xsl:with-param name="uri-f22" select="translate(tei:title[@level='m']/@key, '#', '')"/>
        <xsl:with-param name="title" select="tei:title[@level='m' and @type='subtitle']/text()"/>
      </xsl:call-template>
    </xsl:if>
    
  </xsl:template>  
  
  <xsl:template name="create-F22-title-param">
    <xsl:param name="title" />    
    <xsl:param name="uri-f22">
      <xsl:call-template name="get-F22-uri"/>
    </xsl:param>
    
    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>/title/0&gt; a cidoc:E35_Title ;
  cidoc:P102i_is_title_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>&gt; ;
  rdfs:label &quot;Title: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/title/main&gt; ;
  rdf:value &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot; .
    
</xsl:text>
  </xsl:template>
 
  <xsl:template name="create-F22-subtitle-param">
    <xsl:param name="title" />    
    <xsl:param name="uri-f22">
      <xsl:call-template name="get-F22-uri"/>
    </xsl:param>
    
    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>/title/1&gt; a cidoc:E35_Title ;
  cidoc:P102i_is_title_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>&gt; ;
  rdfs:label &quot;Title: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/title/sub&gt; ;
  rdf:value &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot; .
    
</xsl:text>
  </xsl:template>
 
  <xsl:template name="create-F22-subtitle-art-issue-param">
    <xsl:param name="uri-f22">
      <xsl:call-template name="get-F22-uri"/>
    </xsl:param>
    <xsl:param name="title"/>
    
    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>/title/1&gt; a cidoc:E35_Title ;
  cidoc:P102i_is_title_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>&gt; ;
  rdfs:label &quot;Title: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/title/sub&gt; ;
  rdf:value &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot; .
    
</xsl:text>
    
  </xsl:template>
  
  <xsl:template name="create-F24-appellation">
    <xsl:variable name="uri-f24">
      <xsl:call-template name="get-F24-uri"/>
    </xsl:variable>
    <xsl:variable name="title" select="tei:title[@level='m' and not(@type)]/text()"/>
    
    <xsl:text>#F24 appellation
</xsl:text>
    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation/0&gt; a cidoc:E33_E41_Linguistic_Appellation ;
  rdfs:label &quot;Appellation for: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:P1i_identifies &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/published-expression&gt; ;  
  cidoc:P106_is_composed_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation-title/0&gt;</xsl:text>
    <xsl:if test="tei:title[@level='m' and @type='subtitle']">    
      <xsl:text> ;
  cidoc:P106_is_composed_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation-title/1&gt;</xsl:text>
    </xsl:if>
      <xsl:text> .
        
</xsl:text>    
  </xsl:template>
  
  <xsl:template name="create-bibl-F24-appellation-periodical">
    <xsl:variable name="uri-f24">
      <xsl:call-template name="get-F24-uri"/>
    </xsl:variable>
    <xsl:variable name="title" select="tei:title[@level='j']/text()"/>
    
    <xsl:text>#F24 appellation periodical
</xsl:text>
    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation/0&gt; a cidoc:E33_E41_Linguistic_Appellation ;
  rdfs:label &quot;Appellation for: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:P1i_identifies &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/published-expression&gt; ;  
  cidoc:P106_is_composed_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation-title/0&gt;</xsl:text>
    <xsl:if test="tei:title[@level='m' and @type='subtitle']">    
      <xsl:text> ;
  cidoc:P106_is_composed_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation-title/1&gt;</xsl:text>
    </xsl:if>
 
    <xsl:if test="tei:date">
      <xsl:text> ;
  cidoc:P106_is_composed_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation-date/0&gt;</xsl:text>   
    </xsl:if>
 
    <xsl:if test="tei:date/tei:note">
      <xsl:text> ;
  cidoc:P106_is_composed_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation-ed/0&gt;</xsl:text>   
    </xsl:if> 
    <xsl:if test="tei:pubPlace">
      <xsl:text> ;
  cidoc:P106_is_composed_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation-place/0&gt;</xsl:text>   
    </xsl:if>
    <xsl:if test="tei:num">
      <xsl:text> ;
  cidoc:P106_is_composed_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation-num/0&gt;</xsl:text>   
    </xsl:if>
    <xsl:if test="tei:edition">
      <xsl:text> ;
  cidoc:P106_is_composed_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation-ed/1&gt;</xsl:text>   
    </xsl:if>
    <xsl:text> .
        
</xsl:text>
  </xsl:template>

  <xsl:template name="create-F24-appellation-title0">
    <xsl:variable name="uri-f24">
      <xsl:call-template name="get-F24-uri"/>
    </xsl:variable>
    <xsl:variable name="title" select="tei:title[@level='m' and not(@type)]"/>
    
    <xsl:text>#F24 appellation title0
</xsl:text>
    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation-title/0&gt; a cidoc:E90_Symbolic_Object ;
  rdfs:label &quot;Appellation Part: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en 
  cidoc:P106i_forms_part_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation/0&gt; ;  
  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/appellation/title/main&gt; ;
  rdf:value &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot; .

</xsl:text>
  </xsl:template>
  
  <xsl:template name="create-F24-appellation-title1">
    <xsl:if test="tei:title[@level='m' and @type='subtitle']">
      
      <xsl:variable name="uri-f24">
        <xsl:call-template name="get-F24-uri"/>
      </xsl:variable>
      <xsl:variable name="title" select="replace(translate(tei:title[@level='m' and @type='subtitle'], '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      
      <xsl:text>#F24 appellation title1
</xsl:text>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation-title/1&gt; a cidoc:E90_Symbolic_Object ;
  rdfs:label &quot;Appellation Part: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en 
  cidoc:P106i_forms_part_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation/0&gt; ;  
  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/appellation/title/sub&gt; ;
  rdf:value &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot; .

</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F24-appellation-title0-periodical">
    <xsl:variable name="uri-f24">
      <xsl:call-template name="get-F24-uri"/>
    </xsl:variable>
    <xsl:variable name="title" select="tei:title[@level='j' and not(@type)]"/>
    
    <xsl:text>#F24 appellation title0 periodical issue
</xsl:text>
    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation-title/0&gt; a cidoc:E90_Symbolic_Object ;
  rdfs:label &quot;Appellation Part: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en 
  cidoc:P106i_forms_part_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation/0&gt; ;  
  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/appellation/title/main&gt; ;
  rdf:value &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot; .

</xsl:text>    
  </xsl:template>
  
  <xsl:template name="create-F24-appellation-title1-periodical">
    <xsl:if test="tei:title[@level='j' and @type='subtitle']">
      
      <xsl:variable name="uri-f24">
        <xsl:call-template name="get-F24-uri"/>
      </xsl:variable>
      <xsl:variable name="title" select="replace(translate(tei:title[@level='j' and @type='subtitle'], '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      
      <xsl:text>#F24 appellation title1 periodical issue
</xsl:text>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation-title/1&gt; a cidoc:E90_Symbolic_Object ;
  rdfs:label &quot;Appellation Part: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en 
  cidoc:P106i_forms_part_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation/0&gt; ;  
  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/appellation/title/sub&gt; ;
  rdf:value &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot; .

</xsl:text>
    </xsl:if>  </xsl:template>
  
  <xsl:template name="create-F24-appellation-date-periodical">
    <xsl:if test="tei:date">      
      <xsl:variable name="uri-f24">
        <xsl:call-template name="get-F24-uri"/>
      </xsl:variable>
      <xsl:variable name="title" select="tei:date/text()"/>
      
      <xsl:text>#F24 appellation date periodical issue
</xsl:text>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation-date/0&gt; a cidoc:E90_Symbolic_Object ;
  rdfs:label &quot;Appellation Part: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en 
  cidoc:P106i_forms_part_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation/0&gt; ;  
  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/appellation/date&gt; ;
  rdf:value &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot; .

</xsl:text>    
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="create-F24-appellation-datenote-periodical">
    <xsl:if test="tei:date/tei:note">
      <xsl:variable name="uri-f24">
        <xsl:call-template name="get-F24-uri"/>
      </xsl:variable>
      <xsl:variable name="title" select="tei:date/tei:note/text()"/>
      
      <xsl:text>#F24 appellation date/note periodical issue
</xsl:text>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation-ed/0&gt; a cidoc:E90_Symbolic_Object ;
  rdfs:label &quot;Appellation Part: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en 
  cidoc:P106i_forms_part_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation/0&gt; ;  
  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/appellation/ed&gt; ;
  rdf:value &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot; .

</xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="create-F24-appellation-place-periodical">    
    <xsl:if test="tei:pubPlace">
      <xsl:variable name="uri-f24">
        <xsl:call-template name="get-F24-uri"/>
      </xsl:variable>
      <xsl:variable name="title" select="tei:pubPlace/text()"/>
      
      <xsl:text>#F24 appellation place periodical issue
</xsl:text>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation-place/0&gt; a cidoc:E90_Symbolic_Object ;
  rdfs:label &quot;Appellation Part: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en 
  cidoc:P106i_forms_part_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation/0&gt; ;  
  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/appellation/place&gt; ;
  rdf:value &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot; .

</xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="create-F24-appellation-num-periodical">    
    <xsl:if test="tei:num">
      <xsl:variable name="uri-f24">
        <xsl:call-template name="get-F24-uri"/>
      </xsl:variable>
      <xsl:variable name="title" select="tei:num/text()"/>
      
      <xsl:text>#F24 appellation num periodical issue
</xsl:text>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation-num/0&gt; a cidoc:E90_Symbolic_Object ;
  rdfs:label &quot;Appellation Part: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en 
  cidoc:P106i_forms_part_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation/0&gt; ;  
  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/appellation/num&gt; ;
  rdf:value &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot; .

</xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="create-F24-appellation-edition-periodical">    
    <xsl:if test="tei:edition">
      <xsl:variable name="uri-f24">
        <xsl:call-template name="get-F24-uri"/>
      </xsl:variable>
      <xsl:variable name="title" select="tei:edition/text()"/>
      
      <xsl:text>#F24 appellation edition periodical issue
</xsl:text>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation-ed/1&gt; a cidoc:E90_Symbolic_Object ;
  rdfs:label &quot;Appellation Part: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en 
  cidoc:P106i_forms_part_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f24"/><xsl:text>/appellation/0&gt; ;  
  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/appellation/ed&gt; ;
  rdf:value &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot; .

</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F22-subtitle-issue">
    <xsl:if test="tei:title[@level='a' and @type='subtitle']">        
      <xsl:variable name="uri-f22">
        <xsl:call-template name="get-F22-uri"/>
      </xsl:variable>
      <xsl:variable name="title" select="tei:title[@level='a' and @type='subtitle']/text()"/>
    
      <xsl:text>#F22 subtitle issue
</xsl:text>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>/title/1&gt; a cidoc:E35_Title ;
  cidoc:P102i_is_title_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>&gt; ;
  rdfs:label &quot;Title: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/title/sub&gt; ;
  rdf:value &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot; .
    
</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F28">
    <xsl:if test="tei:bibl/tei:author or contains(tei:date/tei:note/text(), 'Entst.')">
      <xsl:variable name="title">
        <xsl:call-template name="get-F22-title"/>
      </xsl:variable>
      <xsl:variable name="uri">
        <xsl:call-template name="get-F22-uri"/>      
      </xsl:variable>
      
      <xsl:text>#F28
</xsl:text>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri"/><xsl:text>/creation&gt; a frbroo:F28_Expression_Creation ;
  rdfs:label &quot;Creation of: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  frbroo:R17_created &lt;https://sk.acdh.oeaw.ac.at/t</xsl:text><xsl:value-of select="$uri"/><xsl:text>&gt;</xsl:text>
      
      <xsl:if test="contains(tei:date/tei:note/text(), 'Entst.')">
        <xsl:text> ;
  cidoc:P4_has_time-span &lt;https://sk.acdh.oeaw.ac.at/t</xsl:text><xsl:value-of select="$uri"/><xsl:text>/creation/time-span&gt;</xsl:text>
      </xsl:if>
      
      <xsl:text> .
    
</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-E52-creation-timespan">
    <xsl:if test="contains(tei:date/tei:note/text(), 'Entst.')">
      <xsl:if test="tei:date[@when or (@notBefore and @notAfter)]">
        <xsl:variable name="uri">
          <xsl:call-template name="get-F22-uri"/>      
        </xsl:variable>
        <xsl:variable name="title">
          <xsl:call-template name="get-timespan-title"/>
        </xsl:variable>
        <xsl:variable name="begin-date">
          <xsl:call-template name="get-timespan-begin"/>          
        </xsl:variable>
        <xsl:variable name="end-date">
          <xsl:call-template name="get-timespan-end"/>          
        </xsl:variable>
        
        <xsl:text>#E52 creation time-span
</xsl:text>
        <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri"/><xsl:text>/creation/time-span&gt; a cidoc:E52_Time-Span ;
  rdfs:label &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:P4i_is_time-span_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri"/><xsl:text>/creation&gt; ;
  cidoc:P82a_begin_of_the_begin </xsl:text><xsl:value-of select="$begin-date"/><xsl:text> ;
  cidoc:P82b_end_of_the_end </xsl:text><xsl:value-of select="$end-date"/><xsl:text> .  
    
</xsl:text>      
      </xsl:if>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="create-F30">
    <xsl:if test="tei:date and not(tei:date/tei:note/text()='UA' or tei:date/tei:note/text()='Entst.')">
      <xsl:variable name="title">
        <xsl:call-template name="get-F22-title"/>
      </xsl:variable>
      <xsl:variable name="uri">
        <xsl:call-template name="get-F22-uri"/>      
      </xsl:variable>
      
      <xsl:text>#F30
</xsl:text>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri"/><xsl:text>/publication&gt; a frbroo:F30_Publication_Event ;
  rdfs:label &quot;Publication of: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:R24_created &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri"/><xsl:text>/published-expression&gt;</xsl:text>
      <xsl:for-each select="tei:pubPlace">
        <xsl:text>;
  cidoc:P7_took_place_a t&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="translate(@key, '#', '')"/><xsl:text>&gt;</xsl:text> 
      </xsl:for-each>      
      <xsl:text> ;
  cidoc:P4_has_time-span &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri"/><xsl:text>/publication/time-span&gt; .

</xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="create-F30-issue">
    <xsl:if test="tei:date">
      <xsl:variable name="title">
        <xsl:call-template name="get-F24-title"/>
      </xsl:variable>
      <xsl:variable name="uri">
        <xsl:call-template name="get-F24-uri"/>      
      </xsl:variable>
      
      <xsl:text>#F30 issue
</xsl:text>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri"/><xsl:text>/publication&gt; a frbroo:F30_Publication_Event ;
  rdfs:label &quot;Publication of: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:R24_created &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri"/><xsl:text>/published-expression&gt;</xsl:text>
      <xsl:for-each select="tei:pubPlace">
        <xsl:text>;
  cidoc:P7_took_place_a t&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="translate(@key, '#', '')"/><xsl:text>&gt;</xsl:text> 
      </xsl:for-each>
      <xsl:if test="not(tei:date/tei:note/text()='UA' or tei:date/tei:note/text()='Entst.')">
        <xsl:text> ;
  cidoc:P4_has_time-span &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri"/><xsl:text>/publication/time-span&gt;</xsl:text>
      </xsl:if>
      <xsl:text> .

</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-E52-publication-timespan">
    <xsl:if test="not(tei:date/tei:note/text()='UA' or tei:date/tei:note/text()='Entst.')">
      <xsl:if test="tei:date[@when or (@notBefore and @notAfter)]">
        <xsl:variable name="uri">
          <xsl:call-template name="get-F22-uri"/>      
        </xsl:variable>
        <xsl:variable name="title">
          <xsl:call-template name="get-timespan-title"/>
        </xsl:variable>
        <xsl:variable name="begin-date">
          <xsl:call-template name="get-timespan-begin"/>          
        </xsl:variable>
        <xsl:variable name="end-date">
          <xsl:call-template name="get-timespan-end"/>          
        </xsl:variable>
      
        <xsl:text>#E52 publication time-span
</xsl:text>
        <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri"/><xsl:text>/publication/time-span&gt; a cidoc:E52_Time-Span ;
  rdfs:label &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:P4i_is_time-span_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri"/><xsl:text>/publication&gt; ;
  cidoc:P82a_begin_of_the_begin </xsl:text><xsl:value-of select="$begin-date"/><xsl:text> ;
  cidoc:P82b_end_of_the_end </xsl:text><xsl:value-of select="$end-date"/><xsl:text> .  
    
</xsl:text>      
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-E52-publication-timespan-issue">
    <xsl:if test="not(tei:date/tei:note/text()='UA' or tei:date/tei:note/text()='Entst.')">
      <xsl:if test="tei:date[@when or (@notBefore and @notAfter)]">
        <xsl:variable name="uri">
          <xsl:call-template name="get-F24-uri"/>      
        </xsl:variable>
        <xsl:variable name="title">
          <xsl:call-template name="get-timespan-title"/>
        </xsl:variable>
        <xsl:variable name="begin-date">
          <xsl:call-template name="get-timespan-begin"/>          
        </xsl:variable>
        <xsl:variable name="end-date">
          <xsl:call-template name="get-timespan-end"/>          
        </xsl:variable>
      
        <xsl:text>#E52 issue publication time-span
</xsl:text>
        <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri"/><xsl:text>/publication/time-span&gt; a cidoc:E52_Time-Span ;
  rdfs:label &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:P4i_is_time-span_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri"/><xsl:text>/publication&gt; ;
  cidoc:P82a_begin_of_the_begin </xsl:text><xsl:value-of select="$begin-date"/><xsl:text> ;
  cidoc:P82b_end_of_the_end </xsl:text><xsl:value-of select="$end-date"/><xsl:text> .  
    
</xsl:text>      
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F31">
    <xsl:if test="tei:date/tei:note/text()='UA'">
      <xsl:variable name="title">
        <xsl:call-template name="get-F22-title"/>
      </xsl:variable>
      <xsl:variable name="uri">
        <xsl:call-template name="get-F22-uri"/>      
      </xsl:variable>
      
      <xsl:text>#F31 performance for F22
</xsl:text>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri"/><xsl:text>/performance&gt; a frbroo:F31_Performance ;
  rdfs:label &quot;Performance / Recital of: </xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  frbroo:R66_included_performed_version_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri"/><xsl:text>&gt; ;
  cidoc:P4_has_time-span &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri"/><xsl:text>/performance/time-span&gt; ;
  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/event/first&gt; .

</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-E52-performance-timespan">
    <xsl:if test="tei:date/tei:note/text()='UA' and tei:date[@when or (@notBefore and @notAfter)]">
        <xsl:variable name="uri">
          <xsl:call-template name="get-F22-uri"/>      
        </xsl:variable>
        <xsl:variable name="title">
          <xsl:call-template name="get-timespan-title"/>
        </xsl:variable>
        <xsl:variable name="begin-date">
          <xsl:call-template name="get-timespan-begin"/>          
        </xsl:variable>
        <xsl:variable name="end-date">
          <xsl:call-template name="get-timespan-end"/>          
        </xsl:variable>
        
        <xsl:text>#E52 performance time-span
</xsl:text>
        <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri"/><xsl:text>/performance/time-span&gt; a cidoc:E52_Time-Span ;
  rdfs:label &quot;</xsl:text><xsl:value-of select="$title"/><xsl:text>&quot;@en ;
  cidoc:P4i_is_time-span_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri"/><xsl:text>/performance&gt; ;
  cidoc:P82a_begin_of_the_begin </xsl:text><xsl:value-of select="$begin-date"/><xsl:text> ;
  cidoc:P82b_end_of_the_end </xsl:text><xsl:value-of select="$end-date"/><xsl:text> .  
    
</xsl:text>      
    </xsl:if>
  </xsl:template>

  <!-- helpers -->

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
    <xsl:value-of select="translate($uri, '#', '')"/>
  </xsl:template>

  <xsl:template name="get-issue-title">
    <xsl:choose>
      <xsl:when test="tei:title[@level = 'j']">
        <xsl:value-of select="tei:title[@level = 'j'][1]/text()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="tei:title[@level = 'm'][1]/text()"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>

  <xsl:template name="get-issue-title-text">
    <xsl:choose>
      <xsl:when test="tei:title[@level = 'j']">
        <xsl:value-of select="concat('Issue: ', tei:title[@level = 'j'][1]/text())"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('Expression: ', tei:title[@level = 'm'][1]/text())"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
    
  <xsl:template name="get-periodical-uri">
    <xsl:value-of
      select="concat(translate(tei:title[@level = 'j']/@key, '#', ''), '/published-expression')"/>
  </xsl:template>

  <xsl:template name="get-F22-uri">
    <xsl:choose>
      <xsl:when
        test="tei:citedRange[@wholePeriodical = 'yes'] or tei:citedRange[@wholeText = 'yes']">
        <xsl:value-of select="tei:citedRange[@wholeText = 'yes']/@xml:id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@xml:id"/>
      </xsl:otherwise>
    </xsl:choose>
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
            <xsl:when test="tei:citedRange[@wholeText = 'yes']">
              <xsl:value-of select="tei:citedRange[@wholeText = 'yes']/@xml:id"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@xml:id"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="translate($uri, '#', '')"/>
  </xsl:template>

  <xsl:template name="get-F22-title">
    <xsl:choose>
      <xsl:when test="tei:title[@level = 'a']">
        <xsl:value-of select="replace(translate(tei:title[@level = 'a' and not(@type)], '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"        />
      </xsl:when>
      <xsl:when test="tei:title[@level = 'm']">
        <xsl:value-of
          select="replace(translate(tei:title[@level = 'm' and not(@type)], '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"
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
    <xsl:value-of
      select="concat('Published Expression: ', replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' '))"
    />
  </xsl:template>

  <xsl:template name="get-timespan-title">
    <xsl:choose>
      <xsl:when test="tei:date/@notBefore and tei:date/@notAfter">
        <xsl:value-of select="tei:date/@notBefore"/><xsl:text> - </xsl:text><xsl:value-of select="tei:date/@notAfter"/>
      </xsl:when>
      <xsl:when test="tei:date/@when">
        <xsl:value-of select="tei:date/@when"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="get-timespan-begin">
    <xsl:choose>
      <xsl:when test="tei:date/@notBefore">
        <xsl:call-template name="format-date-and-type">
          <xsl:with-param name="date" select="tei:date/@notBefore"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="tei:date/@when">
        <xsl:call-template name="format-date-and-type">
          <xsl:with-param name="date" select="tei:date/@when"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="get-timespan-end">
    <xsl:choose>
      <xsl:when test="tei:date/@notAfter">
        <xsl:call-template name="format-date-and-type">
          <xsl:with-param name="date" select="tei:date/@notAfter"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="tei:date/@when">
        <xsl:call-template name="format-date-and-type">
          <xsl:with-param name="date" select="tei:date/@when"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>  
  </xsl:template>
  
  <xsl:template name="format-date-and-type">
    <xsl:param name="date"/>
    
    <xsl:choose>
      <xsl:when test="string-length($date)=4">
        <!-- YYYY -->
        <xsl:value-of select="concat('&quot;', $date, '&quot;^^xs:gYear')"/>
      </xsl:when>
      <xsl:when test="string-length($date)=5 and substring($date,1,1)='-'">
        <!-- YYYY -->
        <xsl:value-of select="concat('&quot;', $date, '&quot;^^xs:gYear')"/>
      </xsl:when>
      <xsl:when test="string-length($date)=7 and substring($date,5,1)='-'">
        <!-- YYYY-MM -->
        <xsl:value-of select="concat('&quot;', $date, '&quot;^^xs:gYearMonth')"/>
      </xsl:when>
      <xsl:when test="string-length($date)=8 and substring($date,1,1)='-' and substring($date,6,1)='-'">
        <!-- -YYYY-MM -->
        <xsl:value-of select="concat('&quot;', $date, '&quot;^^xs:gYearMonth')"/>
      </xsl:when>
      <xsl:when test="string-length($date)=10 and substring($date,5,1)='-' and substring($date,8,1)='-'">
        <!-- YYYY-MM-DD -->
        <xsl:value-of select="concat('&quot;', $date, '&quot;^^xs:date')"/>
      </xsl:when>
      <xsl:when test="string-length($date)=11 and substring($date,1,1)='-' and substring($date,6,1)='-' and substring($date,9,1)='-'">
        <!-- -YYYY-MM-DD -->
        <xsl:value-of select="concat('&quot;', $date, '&quot;^^xs:date')"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
