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
        <xsl:call-template name="create-F22-title"/>
        <xsl:call-template name="create-F22-subtitle"/>
        <xsl:call-template name="create-bibl-F24"/>
      </xsl:otherwise>
    </xsl:choose>    
    <xsl:choose>
      <xsl:when test="tei:title[@level = 'j']">
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
      <xsl:when test="tei:date/tei:note/text()='UA' or tei:date/tei:note/text()='Entst.'"></xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="create-F24-appellation"/>
        <xsl:call-template name="create-F24-appellation-title0"/>
        <xsl:call-template name="create-F24-appellation-title1"/>
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
    <xsl:if test="not(tei:date/tei:note/text()='UA' or tei:date/tei:note/text()='Entst.')">
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
  cidoc:P165_incorporates &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-f22"/><xsl:text>&gt; .

</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-bibl-F24-periodical">

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
  cidoc:P1_is_identified_by &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-period"/><xsl:text>/appellation/0&gt; ;
  frbroo:R5_has_component &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-issue"/><xsl:text>/published-expression&gt; .

</xsl:text>
  </xsl:template>

  <xsl:template name="create-bibl-F24-issue">
    <xsl:if test="not(tei:date/tei:note/text()='UA' or tei:date/tei:note/text()='Entst.')">      
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
  cidoc:P165_incorporates &lt;https://sk.acdh.oeaw.ac.at/</xsl:text><xsl:value-of select="$uri-issue"/><xsl:text>&gt; .

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
    <xsl:variable name="title" select="tei:title[@level='j' and not(@type)]"/>
    
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
    <xsl:variable name="title" select="tei:title[@level='m']"/>
    
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
    
    <xsl:text>#F24 appellation title0 periodical
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
      
      <xsl:text>#F24 appellation title1 periodical
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
      
      <xsl:text>#F24 appellation date periodical
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
      
      <xsl:text>#F24 appellation date/note periodical
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
      
      <xsl:text>#F24 appellation place periodical
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
      
      <xsl:text>#F24 appellation num periodical
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
      
      <xsl:text>#F24 appellation edition periodical
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

</xsl:stylesheet>
