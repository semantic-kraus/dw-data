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
    <xsl:call-template name="create-bibl-F22"/>
    <xsl:call-template name="create-F22-title"/>
    <xsl:call-template name="create-E42-xmlid-identifier"/>
    <xsl:call-template name="create-E42-permalink-identifier"/>
    <xsl:call-template name="create-E42-url-identifier"/>

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
        <xsl:call-template name="create-bibl-F22-edText"/>
        <xsl:call-template name="create-F28-edText"/>
        <xsl:call-template name="create-F28-ed"/>
        <xsl:call-template name="create-F22-title-edText"/>
        <xsl:call-template name="create-F22-subtitle-edText"/>
        <xsl:call-template name="create-bibl-F24-issue"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="create-F28"/>
        <xsl:call-template name="create-E52-creation-timespan"/>
        <xsl:call-template name="create-F22-subtitle"/>
        <xsl:call-template name="create-bibl-F24"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:call-template name="create-bibl-F22-orig"/>
    <xsl:call-template name="create-F28-orig"/>

    <xsl:call-template name="create-F30-issue"/>
    <xsl:call-template name="create-E52-publication-timespan"/>
    <xsl:call-template name="create-F31"/>
    <xsl:call-template name="create-E52-performance-timespan"/>
    <xsl:call-template name="create-INT3"/>

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
      <xsl:when
        test="not(tei:date) or tei:date/tei:note/text() = 'UA' or tei:date/tei:note/text() = 'Entst.'"/>
      <xsl:otherwise>
        <xsl:call-template name="create-F24-appellation"/>
        <xsl:call-template name="create-F24-appellation-title0"/>
        <xsl:call-template name="create-F24-appellation-title1"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="create-INT1-textpassage"/>
    <xsl:call-template name="create-E42-INT1-xmlid-identifier"/>
    <xsl:call-template name="create-E42-INT1-url-identifier"/>
    <xsl:call-template name="create-INT1-INT16-segment"/>
  </xsl:template>

  <!-- functions aka. named templates -->

  <xsl:template name="get-header">
    <xsl:text>@prefix cidoc: &lt;http://www.cidoc-crm.org/cidoc-crm/&gt;</xsl:text>
    <xsl:call-template name="newline-dot"/>
    <xsl:text>@prefix dcterms: &lt;http://purl.org/dc/terms/&gt;</xsl:text>
    <xsl:call-template name="newline-dot"/>
    <xsl:text>@prefix frbroo: &lt;https://cidoc-crm.org/frbroo/sites/default/files/FRBR2.4-draft.rdfs#&gt;</xsl:text>
    <xsl:call-template name="newline-dot"/>
    <xsl:text>@prefix lk: &lt;https://sk.acdh.oeaw.ac.at/project/legal-kraus&gt;</xsl:text>
    <xsl:call-template name="newline-dot"/>
    <xsl:text>@prefix ns1: &lt;https://w3id.org/lso/intro/beta202304#&gt;</xsl:text>
    <xsl:call-template name="newline-dot"/>
    <xsl:text>@prefix rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;</xsl:text>
    <xsl:call-template name="newline-dot"/>
    <xsl:text>@prefix rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;</xsl:text>
    <xsl:call-template name="newline-dot"/>
    <xsl:text>@prefix schema: &lt;https://schema.org/&gt;</xsl:text>
    <xsl:call-template name="newline-dot"/>
    <xsl:text>@prefix sk: &lt;https://sk.acdh.oeaw.ac.at/&gt;</xsl:text>
    <xsl:call-template name="newline-dot"/>
    <xsl:text>@prefix xsd: &lt;http://www.w3.org/2001/XMLSchema#&gt;</xsl:text>
    <xsl:call-template name="newline-dot-newline"/>
  </xsl:template>

  <xsl:template name="create-bibl-F22">

    <xsl:variable name="title">
      <xsl:call-template name="get-F22-title"/>
    </xsl:variable>
    <xsl:variable name="uri-f22">
      <xsl:call-template name="get-F22-uri"/>
    </xsl:variable>

    <xsl:variable name="uri-origin">
      <xsl:call-template name="get-F24-uri-origin"/>
    </xsl:variable>

    <xsl:if test="not(tei:citedRange[@wholePeriodical = 'yes'] and $uri-origin = 'id')">
      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#F22'"/>
      </xsl:call-template>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f22"/>
      <xsl:text>&gt; a frbroo:F22_Self-Contained_Expression</xsl:text>
      <xsl:call-template name="newline-semicolon"/>

      <xsl:text>  rdfs:label &quot;Expression: </xsl:text>
      <xsl:choose>
        <xsl:when test="$title != ''">
          <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>[Expression]</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>&quot;@en</xsl:text>

      <xsl:if test="$title != ''">
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P102_has_title &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f22"/>
        <xsl:text>/title/0&gt;</xsl:text>
      </xsl:if>

      <xsl:if test="tei:title[@level = 'm' and @type = 'subtitle']">
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P102_has_title &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f22"/>
        <xsl:text>/title/1&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="tei:title[@level = 'm' and @key]">
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P165i_is_incorporated_in &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="translate(tei:title[@level = 'm']/@key, '#', '')"/>
        <xsl:text>&gt;</xsl:text>
      </xsl:if>
      <xsl:call-template name="newline-dot-newline"/>
    </xsl:if>
  </xsl:template>

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

    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="'#F22 art-issue'"/>
    </xsl:call-template>
    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri-f22"/>
    <xsl:text>&gt; a frbroo:F22_Self-Contained_Expression</xsl:text>
    <xsl:call-template name="newline-semicolon"/>
    <xsl:text>  rdfs:label &quot;Expression: </xsl:text>
    <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
    <xsl:text>&quot;@en</xsl:text>
    <xsl:call-template name="newline-semicolon"/>
    <xsl:text>  cidoc:P102_has_title &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri-f22"/>
    <xsl:text>/title/0&gt;</xsl:text>
    <xsl:if test="tei:title[@level = 'a' and @type = 'subtitle']">
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P102_has_title &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f22"/>
      <xsl:text>/title/1&gt;</xsl:text>
    </xsl:if>
    <xsl:call-template name="newline-semicolon"/>
    <xsl:text>  cidoc:P165i_is_incorporated_in &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri-issue"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:call-template name="newline-dot-newline"/>
  </xsl:template>

  <xsl:template name="create-bibl-F22-orig">
    <xsl:if test="tei:author[@role = 'pretext']">
      <xsl:variable name="title">
        <xsl:call-template name="get-F22-title"/>
      </xsl:variable>
      <xsl:variable name="uri-f22">
        <xsl:call-template name="get-F22-uri"/>
      </xsl:variable>

      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#F22'"/>
      </xsl:call-template>

      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f22"/>
      <xsl:text>orig&gt; a frbroo:F22_Self-Contained_Expression</xsl:text>
      <xsl:call-template name="newline-semicolon"/>

      <xsl:text>  rdfs:label &quot;Original Expression: </xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;@en</xsl:text>
      <xsl:call-template name="newline-semicolon"/>

      <xsl:text>  cidoc:P16i_was_used_for &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f22"/>
      <xsl:text>/creation&gt;</xsl:text>
      <xsl:call-template name="newline-dot-newline"/>

      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f22"/>
      <xsl:text>/creation&gt; cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/event/translation&gt;</xsl:text>
      <xsl:call-template name="newline-dot-newline"/>
    </xsl:if>
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

    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="'#INT16 segment'"/>
    </xsl:call-template>
    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri-f22"/>
    <xsl:text>/segment&gt; a ns1:INT16_Segment</xsl:text>
    <xsl:call-template name="newline-semicolon"/>
    <xsl:text>  rdfs:label &quot;Segment: </xsl:text>
    <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
    <xsl:text>&quot;@en</xsl:text>
    <xsl:call-template name="newline-semicolon"/>
    <xsl:text>  ns1:R16_incorporates &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri-f22"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:if test="tei:biblScope">
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  ns1:R41_has_location &quot;</xsl:text>
      <xsl:value-of select="tei:biblScope/text()"/>
      <xsl:text>&quot;^^xsd:string</xsl:text>
    </xsl:if>
    <xsl:call-template name="newline-semicolon"/>
    <xsl:text>  ns1:R25_is_segment_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri-issue"/>
    <xsl:text>/published-expression&gt;</xsl:text>
    <xsl:call-template name="newline-dot-newline"/>
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
      <xsl:for-each select="tei:citedRange">
        <xsl:if test="not(@wholeText) and not(@wholePeriodical)">
          <xsl:variable name="citedRange"
            select="replace(translate(text(), '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>

          <xsl:call-template name="comment">
            <xsl:with-param name="text" select="'#INT1-INT16 textpassage segment'"/>
          </xsl:call-template>

          <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
          <xsl:value-of select="$uri-f22"/>
          <xsl:text>/segment/</xsl:text>
          <xsl:value-of select="position() - 1"/>
          <xsl:text>&gt; a ns1:INT16_Segment</xsl:text>
          <xsl:call-template name="newline-semicolon"/>

          <xsl:text>  rdfs:label &quot;Text segment from: </xsl:text>
          <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
          <xsl:text>&quot;@en</xsl:text>
          <xsl:if test="starts-with($citedRange, 'S. ')">
            <xsl:call-template name="newline-semicolon"/>
            <xsl:text>  schema:pagination &quot;</xsl:text>
            <xsl:value-of select="$citedRange"/>
            <xsl:text>&quot;</xsl:text>
          </xsl:if>
          <xsl:call-template name="newline-semicolon"/>

          <xsl:text>  ns1:R16_incorporates &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
          <xsl:value-of select="$uri-f22"/>
          <xsl:text>/passage/</xsl:text>
          <xsl:value-of select="position() - 1"/>
          <xsl:text>&gt;</xsl:text>

          <xsl:if test="$citedRange != ''">
            <xsl:call-template name="newline-semicolon"/>
            <xsl:text>  ns1:R41_has_location &quot;</xsl:text>
            <xsl:value-of select="$citedRange"/>
            <xsl:text>&quot;^^xsd:string</xsl:text>
          </xsl:if>

          <xsl:variable name="segmentOf">
            <xsl:choose>
              <xsl:when test="../tei:date/@key">
                <xsl:value-of select="substring-after(../tei:date/@key, '#')"/>
              </xsl:when>
              <xsl:when test="../tei:title[@level = 'm']/@key">
                <xsl:value-of select="substring-after(../tei:title[@level = 'm']/@key, '#')"/>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>

          <xsl:if test="$segmentOf != ''">
            <xsl:call-template name="newline-semicolon"/>
            <xsl:text>  ns1:R25_is_segment_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
            <xsl:value-of select="$segmentOf"/>
            <xsl:text>/published-expression&gt;</xsl:text>
          </xsl:if>

          <xsl:if test="tei:note[@type = 'context']">
            <xsl:call-template name="newline-semicolon"/>
            <xsl:text>   ns1:R44_has_wording &quot;</xsl:text>
            <xsl:value-of
              select="replace(translate(tei:note[@type = 'context']/text(), '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
            <xsl:text>&quot;@und</xsl:text>
          </xsl:if>
          <xsl:if test="tei:title[@level = 'm']">
            <xsl:variable name="uri-m">
              <xsl:call-template name="get-F24-uri-m"/>
            </xsl:variable>
            <xsl:call-template name="newline-semicolon"/>
            <xsl:text>   ns1:R25_is_segment_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
            <xsl:value-of select="$uri-m"/>
            <xsl:text>/published-expression&gt;</xsl:text>
          </xsl:if>
          <xsl:call-template name="newline-dot-newline"/>
        </xsl:if>
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

    <xsl:for-each select="tei:citedRange">
      <xsl:if test="not(@wholeText) and not(@wholePeriodical)">
        <xsl:variable name="citedRange"
          select="replace(translate(text(), '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>

        <xsl:call-template name="comment">
          <xsl:with-param name="text" select="'#INT1 textpassage'"/>
        </xsl:call-template>
        <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f22"/>
        <xsl:text>/passage/</xsl:text>
        <xsl:value-of select="position() - 1"/>
        <xsl:text>&gt; a ns1:INT1_TextPassage</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  rdfs:label &quot;Text passage from: </xsl:text>
        <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
        <xsl:text>&quot;@en</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  ns1:R10_is_Text_Passage_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f22"/>
        <xsl:text>&gt;</xsl:text>
        <xsl:if test="not($citedRange = '') and not(starts-with($citedRange, 'S. '))">
          <xsl:call-template name="newline-semicolon"/>
          <xsl:text>  ns1:R41_has_location &quot;</xsl:text>
          <xsl:value-of select="$citedRange"/>
          <xsl:text>&quot;^^xsd:string</xsl:text>
        </xsl:if>
        <xsl:if test="tei:note[@type = 'context']">
          <xsl:call-template name="newline-semicolon"/>
          <xsl:text>  ns1:R44_has_wording &quot;</xsl:text>
          <xsl:value-of
            select="replace(translate(tei:note[@type = 'context'], '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
          <xsl:text>&quot;@und</xsl:text>
        </xsl:if>
        <xsl:call-template name="newline-dot-newline"/>
      </xsl:if>
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

    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="'#F22 issue'"/>
    </xsl:call-template>

    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri-issue"/>
    <xsl:text>&gt; a frbroo:F22_Self-Contained_Expression</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  rdfs:label &quot;</xsl:text>
    <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
    <xsl:text>&quot;@en</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  cidoc:P102_has_title &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri-issue"/>
    <xsl:text>/title/0&gt;</xsl:text>

    <xsl:if test="tei:title[@level = 'a' and @type = 'subtitle']">
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P102_has_title &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-issue"/>
      <xsl:text>/title/1&gt;</xsl:text>
    </xsl:if>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  cidoc:P165_incorporates &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri-f22"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:call-template name="newline-dot-newline"/>
  </xsl:template>

  <xsl:template name="create-bibl-F24">
    <xsl:if
      test="tei:date and not(tei:date/tei:note/text() = 'UA' or tei:date/tei:note/text() = 'Entst.')">
      <xsl:variable name="uri-f22">
        <xsl:call-template name="get-F22-uri"/>
      </xsl:variable>
      <xsl:variable name="uri-f24">
        <xsl:call-template name="get-F24-uri"/>
      </xsl:variable>
      <xsl:variable name="title">
        <xsl:choose>
          <xsl:when test="$uri-f24 = @xml:id">
            <xsl:text>Publication carrying: </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Published Expression: </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="get-F24-title"/>
      </xsl:variable>
      <xsl:variable name="uri-origin">
        <xsl:call-template name="get-F24-uri-origin"/>
      </xsl:variable>

      <xsl:if test="not(tei:citedRange[@wholePeriodical = 'yes'] and $uri-origin = 'id')">
        <xsl:call-template name="comment">
          <xsl:with-param name="text" select="'#F24'"/>
        </xsl:call-template>
        <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f24"/>
        <xsl:text>/published-expression&gt; a frbroo:F24_Publication_Expression</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  rdfs:label &quot;</xsl:text>
        <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
        <xsl:text>&quot;@en</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:if test="tei:title[@level = 'j' or @level = 's'] or tei:pubPlace">
          <xsl:text>  cidoc:P1_is_identified_by &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
          <xsl:value-of select="$uri-f22"/>
          <xsl:text>/appellation/0&gt;</xsl:text>
          <xsl:call-template name="newline-semicolon"/>
        </xsl:if>
        <xsl:text>  cidoc:P165_incorporates &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f22"/>
        <xsl:text>&gt;</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  frbroo:R24i_was_created_through &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f22"/>
        <xsl:text>/publication&gt;</xsl:text>
        <xsl:call-template name="newline-dot-newline"/>
      </xsl:if>
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

      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#F24 periodical'"/>
      </xsl:call-template>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-period"/>
      <xsl:text>&gt; a frbroo:F24_Publication_Expression</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  rdfs:label &quot;Periodical: </xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;@en</xsl:text>
      <xsl:if test="tei:date[@key]">
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  frbroo:R5_has_component &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-issue"/>
        <xsl:text>/published-expression&gt;</xsl:text>
      </xsl:if>
      <xsl:call-template name="newline-dot-newline"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-bibl-F24-issue">
    <xsl:if
      test="tei:date and not(tei:date/tei:note/text() = 'UA' or tei:date/tei:note/text() = 'Entst.')">
      <xsl:variable name="title">
        <xsl:text>Published Expression: </xsl:text>
        <xsl:call-template name="get-F24-title"/>
      </xsl:variable>
      <xsl:variable name="uri-f22">
        <xsl:call-template name="get-F22-uri"/>
      </xsl:variable>
      <xsl:variable name="uri-f24">
        <xsl:choose>
          <xsl:when test="tei:title[@level = 'm']">
            <xsl:call-template name="get-F24-uri-m"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="get-F24-uri"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#F24 issue'"/>
      </xsl:call-template>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f24"/>
      <xsl:text>/published-expression&gt; a frbroo:F24_Publication_Expression</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  rdfs:label &quot;</xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;@en </xsl:text>
      <xsl:if test="tei:title[level = 'j']">
        <xsl:variable name="uri-period">
          <xsl:call-template name="get-periodical-uri"/>
        </xsl:variable>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>frbrooR5i_is_component_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-period"/>
        <xsl:text>&gt; </xsl:text>
      </xsl:if>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P1_is_identified_by &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f24"/>
      <xsl:text>/appellation/0&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P165_incorporates &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f24"/>
      <xsl:text>&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  frbroo:R24i_was_created_through &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f24"/>
      <xsl:text>/publication&gt;</xsl:text>
      <xsl:call-template name="newline-dot-newline"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F22-title-art-issue">
    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="'#F22 title art-issue'"/>
    </xsl:call-template>
    <xsl:call-template name="create-F22-title-param">
      <xsl:with-param name="title" select="tei:title[@level = 'a' and not(@type)]/text()"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="create-F22-subtitle-art-issue">
    <xsl:if test="tei:title[@level = 'a' and @type = 'subtitle']">
      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#F22 subtitle art-issue'"/>
      </xsl:call-template>
      <xsl:call-template name="create-F22-subtitle-art-issue-param">
        <xsl:with-param name="title" select="tei:title[@level = 'a' and @type = 'subtitle']/text()"
        />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F22-title-issue">
    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="'#F22 title issue'"/>
    </xsl:call-template>
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
    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="'#F22 title'"/>
    </xsl:call-template>
    <xsl:call-template name="create-F22-title-param">
      <xsl:with-param name="title">
        <xsl:call-template name="get-F22-title"/>
      </xsl:with-param>
      <!-- 
      select="tei:title[@level = 'm' and not(@type)]/text()"
       -->
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="create-F22-subtitle">
    <xsl:if test="tei:title[@level = 'm' and @type = 'subtitle']">
      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#F22 subtitle'"/>
      </xsl:call-template>
      <xsl:call-template name="create-F22-subtitle-param">
        <xsl:with-param name="title" select="tei:title[@level = 'm' and @type = 'subtitle']/text()"
        />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-bibl-F22-edText">
    <xsl:variable name="title">
      <xsl:call-template name="get-F22-title"/>
    </xsl:variable>
    <xsl:variable name="uri-f22ed" select="translate(tei:title[@level = 'm']/@key, '#', '')"/>
    <xsl:variable name="uri-issue">
      <xsl:call-template name="get-F22-uri"/>
    </xsl:variable>

    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="'#F22 edText'"/>
    </xsl:call-template>
    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri-f22ed"/>
    <xsl:text>&gt; a frbroo:F22_Self-Contained_Expression</xsl:text>
    <xsl:call-template name="newline-semicolon"/>
    <xsl:text>  rdfs:label &quot;Expression: </xsl:text>
    <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
    <xsl:text>&quot;@en</xsl:text>
    <xsl:call-template name="newline-semicolon"/>
    <xsl:text>  cidoc:P102_has_title &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri-f22ed"/>
    <xsl:text>/title/0&gt;</xsl:text>
    <xsl:if test="tei:title[@level = 'm' and @type = 'subtitle']">
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P102_has_title &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f22ed"/>
      <xsl:text>/title/1&gt;</xsl:text>
    </xsl:if>
    <xsl:call-template name="newline-dot-newline"/>
  </xsl:template>

  <xsl:template name="create-F22-title-edText">
    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="'#F22 title edText'"/>
    </xsl:call-template>
    <xsl:call-template name="create-F22-title-param">
      <xsl:with-param name="title">
        <xsl:call-template name="get-issue-title"/>
      </xsl:with-param>
      <xsl:with-param name="uri-f22" select="translate(tei:title[@level = 'm']/@key, '#', '')"/>
    </xsl:call-template>

  </xsl:template>

  <xsl:template name="create-F22-subtitle-edText">
    <xsl:if test="tei:title[@level = 'm' and @type = 'subtitle']">
      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#F22 subtitle edText'"/>
      </xsl:call-template>
      <xsl:call-template name="create-F22-subtitle-art-issue-param">
        <xsl:with-param name="uri-f22" select="translate(tei:title[@level = 'm']/@key, '#', '')"/>
        <xsl:with-param name="title" select="tei:title[@level = 'm' and @type = 'subtitle']/text()"
        />
      </xsl:call-template>
    </xsl:if>

  </xsl:template>

  <xsl:template name="create-F22-title-param">
    <xsl:param name="title"/>
    <xsl:param name="uri-f22">
      <xsl:call-template name="get-F22-uri"/>
    </xsl:param>

    <xsl:if test="$title != ''">
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f22"/>
      <xsl:text>/title/0&gt; a cidoc:E35_Title</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P102i_is_title_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f22"/>
      <xsl:text>&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  rdfs:label &quot;Title: </xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;@en</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/title/main&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:if test="starts-with($title, '[') and ends-with($title, ']')">
        <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/title/prov&gt;</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
      </xsl:if>
      <xsl:text>  rdf:value &quot;</xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;</xsl:text>
      <xsl:call-template name="newline-dot-newline"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F22-subtitle-param">
    <xsl:param name="title"/>
    <xsl:param name="uri-f22">
      <xsl:call-template name="get-F22-uri"/>
    </xsl:param>

    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri-f22"/>
    <xsl:text>/title/1&gt; a cidoc:E35_Title</xsl:text>
    <xsl:call-template name="newline-semicolon"/>
    <xsl:text>  cidoc:P102i_is_title_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri-f22"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:call-template name="newline-semicolon"/>
    <xsl:text>  rdfs:label &quot;Title: </xsl:text>
    <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
    <xsl:text>&quot;@en</xsl:text>
    <xsl:call-template name="newline-semicolon"/>
    <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/title/sub&gt;</xsl:text>
    <xsl:call-template name="newline-semicolon"/>
    <xsl:if test="starts-with($title, '[') and ends-with($title, ']')">
      <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/title/prov&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
    </xsl:if>
    <xsl:text>  rdf:value &quot;</xsl:text>
    <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
    <xsl:text>&quot;</xsl:text>
    <xsl:call-template name="newline-dot-newline"/>
  </xsl:template>

  <xsl:template name="create-F22-subtitle-art-issue-param">
    <xsl:param name="uri-f22">
      <xsl:call-template name="get-F22-uri"/>
    </xsl:param>
    <xsl:param name="title"/>

    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri-f22"/>
    <xsl:text>/title/1&gt; a cidoc:E35_Title</xsl:text>
    <xsl:call-template name="newline-semicolon"/>
    <xsl:text>  cidoc:P102i_is_title_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri-f22"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:call-template name="newline-semicolon"/>
    <xsl:text>  rdfs:label &quot;Title: </xsl:text>
    <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
    <xsl:text>&quot;@en</xsl:text>
    <xsl:call-template name="newline-semicolon"/>
    <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/title/sub&gt;</xsl:text>
    <xsl:call-template name="newline-semicolon"/>
    <xsl:if test="starts-with($title, '[') and ends-with($title, ']')">
      <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/title/prov&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
    </xsl:if>
    <xsl:text>  rdf:value &quot;</xsl:text>
    <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
    <xsl:text>&quot;</xsl:text>
    <xsl:call-template name="newline-dot-newline"/>
  </xsl:template>

  <xsl:template name="create-F24-appellation">
    <xsl:if test="tei:title[@level = 'j' or @level = 's'] or tei:pubPlace">
      <xsl:variable name="uri-f24">
        <xsl:choose>
          <xsl:when test="tei:title[@level = 'm']">
            <xsl:call-template name="get-F24-uri-m"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="get-F24-uri"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="title" select="tei:title[@level = 'm' and not(@type)]/text()"/>

      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#F24 appellation'"/>
      </xsl:call-template>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f24"/>
      <xsl:text>/appellation/0&gt; a cidoc:E33_E41_Linguistic_Appellation</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  rdfs:label &quot;Appellation for: </xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;@en</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P1i_identifies &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f24"/>
      <xsl:text>/published-expression&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>cidoc:P106_is_composed_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f24"/>
      <xsl:text>/appellation-title/0&gt;</xsl:text>
      <xsl:if test="tei:title[@level = 'm' and @type = 'subtitle']">
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P106_is_composed_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f24"/>
        <xsl:text>/appellation-title/1&gt;</xsl:text>
      </xsl:if>
      <xsl:call-template name="newline-dot-newline"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-bibl-F24-appellation-periodical">
    <xsl:if test="not(tei:citedRange[@wholePeriodical])">
      <xsl:variable name="uri-f24">
        <xsl:call-template name="get-F24-uri"/>
      </xsl:variable>
      <xsl:variable name="title" select="tei:title[@level = 'j' and not(@type)]/text()"/>

      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#F24 appellation periodical'"/>
      </xsl:call-template>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f24"/>
      <xsl:text>/appellation/0&gt; a cidoc:E33_E41_Linguistic_Appellation</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  rdfs:label &quot;Appellation for: </xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;@en</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P1i_identifies &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f24"/>
      <xsl:text>/published-expression&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P106_is_composed_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f24"/>
      <xsl:text>/appellation-title/0&gt;</xsl:text>
      <xsl:if test="tei:title[@level = 'm' and @type = 'subtitle']">
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P106_is_composed_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f24"/>
        <xsl:text>/appellation-title/1&gt;</xsl:text>
      </xsl:if>

      <xsl:if test="tei:date">
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P106_is_composed_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f24"/>
        <xsl:text>/appellation-date/0&gt;</xsl:text>
      </xsl:if>

      <xsl:if test="tei:date/tei:note">
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P106_is_composed_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f24"/>
        <xsl:text>/appellation-ed/0&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="tei:pubPlace">
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P106_is_composed_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f24"/>
        <xsl:text>/appellation-place/0&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="tei:num">
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P106_is_composed_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f24"/>
        <xsl:text>/appellation-num/0&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="tei:edition">
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P106_is_composed_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f24"/>
        <xsl:text>/appellation-ed/1&gt;</xsl:text>
      </xsl:if>
      <xsl:call-template name="newline-dot-newline"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F24-appellation-title0">
    <xsl:if test="tei:title[@level = 'j' or @level = 's'] or tei:pubPlace">
      <xsl:variable name="uri-f24">
        <xsl:choose>
          <xsl:when test="tei:title[@level = 'm']">
            <xsl:call-template name="get-F24-uri-m"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="get-F24-uri"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="title" select="tei:title[@level = 'm' and not(@type)]"/>

      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#F24 appellation title0'"/>
      </xsl:call-template>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f24"/>
      <xsl:text>/appellation-title/0&gt; a cidoc:E90_Symbolic_Object</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  rdfs:label &quot;Appellation Part: </xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;@en</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P106i_forms_part_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f24"/>
      <xsl:text>/appellation/0&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/appellation/title/main&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  rdf:value &quot;</xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;</xsl:text>
      <xsl:call-template name="newline-dot-newline"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F24-appellation-title1">
    <xsl:if test="tei:title[@level = 'm' and @type = 'subtitle']">
      <xsl:variable name="uri-f24">
        <xsl:call-template name="get-F24-uri"/>
      </xsl:variable>
      <xsl:variable name="title"
        select="replace(translate(tei:title[@level = 'm' and @type = 'subtitle'], '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>

      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#F24 appellation title1'"/>
      </xsl:call-template>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f24"/>
      <xsl:text>/appellation-title/1&gt; a cidoc:E90_Symbolic_Object</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  rdfs:label &quot;Appellation Part: </xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;@en</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P106i_forms_part_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f24"/>
      <xsl:text>/appellation/0&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/appellation/title/sub&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  rdf:value &quot;</xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;</xsl:text>
      <xsl:call-template name="newline-dot-newline"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F24-appellation-title0-periodical">
    <xsl:if test="not(tei:citedRange[@wholePeriodical])">
      <xsl:variable name="uri-f24">
        <xsl:call-template name="get-F24-uri"/>
      </xsl:variable>
      <xsl:variable name="title" select="tei:title[@level = 'j' and not(@type)]"/>

      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#F24 appellation title0 periodical issue'"/>
      </xsl:call-template>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f24"/>
      <xsl:text>/appellation-title/0&gt; a cidoc:E90_Symbolic_Object</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  rdfs:label &quot;Appellation Part: </xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;@en</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P106i_forms_part_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f24"/>
      <xsl:text>/appellation/0&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/appellation/title/main&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  rdf:value &quot;</xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;</xsl:text>
      <xsl:call-template name="newline-dot-newline"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F24-appellation-title1-periodical">
    <xsl:if test="tei:title[@level = 'j' and @type = 'subtitle']">
      <xsl:if test="not(tei:citedRange[@wholePeriodical])">
        <xsl:variable name="uri-f24">
          <xsl:call-template name="get-F24-uri"/>
        </xsl:variable>
        <xsl:variable name="title"
          select="replace(translate(tei:title[@level = 'j' and @type = 'subtitle'], '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>

        <xsl:call-template name="comment">
          <xsl:with-param name="text" select="'#F24 appellation title1 periodical issue'"/>
        </xsl:call-template>
        <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f24"/>
        <xsl:text>/appellation-title/1&gt; a cidoc:E90_Symbolic_Object</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  rdfs:label &quot;Appellation Part: </xsl:text>
        <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
        <xsl:text>&quot;@en </xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P106i_forms_part_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f24"/>
        <xsl:text>/appellation/0&gt;</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/appellation/title/sub&gt;</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  rdf:value &quot;</xsl:text>
        <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
        <xsl:text>&quot;</xsl:text>
        <xsl:call-template name="newline-dot-newline"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F24-appellation-date-periodical">
    <xsl:if test="not(tei:citedRange[@wholePeriodical])">
      <xsl:if test="tei:date">
        <xsl:variable name="uri-f24">
          <xsl:call-template name="get-F24-uri"/>
        </xsl:variable>
        <xsl:variable name="title" select="tei:date/text()"/>

        <xsl:if test="$title != ''">
          <xsl:call-template name="comment">
            <xsl:with-param name="text" select="'#F24 appellation date periodical issue'"/>
          </xsl:call-template>
          <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
          <xsl:value-of select="$uri-f24"/>
          <xsl:text>/appellation-date/0&gt; a cidoc:E90_Symbolic_Object</xsl:text>
          <xsl:call-template name="newline-semicolon"/>
          <xsl:text>  rdfs:label &quot;Appellation Part: </xsl:text>
          <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
          <xsl:text>&quot;@en</xsl:text>
          <xsl:call-template name="newline-semicolon"/>
          <xsl:text>  cidoc:P106i_forms_part_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
          <xsl:value-of select="$uri-f24"/>
          <xsl:text>/appellation/0&gt;</xsl:text>
          <xsl:call-template name="newline-semicolon"/>
          <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/appellation/date&gt;</xsl:text>
          <xsl:call-template name="newline-semicolon"/>
          <xsl:text>  rdf:value &quot;</xsl:text>
          <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
          <xsl:text>&quot;</xsl:text>
          <xsl:call-template name="newline-dot-newline"/>
        </xsl:if>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F24-appellation-datenote-periodical">
    <xsl:if test="not(tei:citedRange[@wholePeriodical])">
      <xsl:if test="tei:date/tei:note">
        <xsl:variable name="uri-f24">
          <xsl:call-template name="get-F24-uri"/>
        </xsl:variable>
        <xsl:variable name="title" select="tei:date/tei:note/text()"/>

        <xsl:call-template name="comment">
          <xsl:with-param name="text" select="'#F24 appellation date/note periodical issue'"/>
        </xsl:call-template>
        <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f24"/>
        <xsl:text>/appellation-ed/0&gt; a cidoc:E90_Symbolic_Object</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  rdfs:label &quot;Appellation Part: </xsl:text>
        <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
        <xsl:text>&quot;@en</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P106i_forms_part_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f24"/>
        <xsl:text>/appellation/0&gt;</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/appellation/ed&gt;</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  rdf:value &quot;</xsl:text>
        <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
        <xsl:text>&quot;</xsl:text>
        <xsl:call-template name="newline-dot-newline"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F24-appellation-place-periodical">
    <xsl:if test="not(tei:citedRange[@wholePeriodical])">
      <xsl:if test="tei:pubPlace">
        <xsl:variable name="uri-f24">
          <xsl:call-template name="get-F24-uri"/>
        </xsl:variable>
        <xsl:variable name="title">
          <xsl:for-each select="tei:pubPlace/text()">
            <xsl:value-of select="."/>
            <xsl:if test="not(position() = last())">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </xsl:variable>

        <xsl:call-template name="comment">
          <xsl:with-param name="text" select="'#F24 appellation place periodical issue'"/>
        </xsl:call-template>
        <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f24"/>
        <xsl:text>/appellation-place/0&gt; a cidoc:E90_Symbolic_Object</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  rdfs:label &quot;Appellation Part: </xsl:text>
        <xsl:value-of select="$title"/>
        <xsl:text>&quot;@en</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P106i_forms_part_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f24"/>
        <xsl:text>/appellation/0&gt;</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/appellation/place&gt;</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  rdf:value &quot;</xsl:text>
        <xsl:value-of select="$title"/>
        <xsl:text>&quot;</xsl:text>
        <xsl:call-template name="newline-dot-newline"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F24-appellation-num-periodical">
    <xsl:if test="not(tei:citedRange[@wholePeriodical])">
      <xsl:if test="tei:num">
        <xsl:variable name="uri-f24">
          <xsl:call-template name="get-F24-uri"/>
        </xsl:variable>
        <xsl:variable name="title" select="tei:num/text()"/>

        <xsl:call-template name="comment">
          <xsl:with-param name="text" select="'#F24 appellation num periodical issue'"/>
        </xsl:call-template>
        <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f24"/>
        <xsl:text>/appellation-num/0&gt; a cidoc:E90_Symbolic_Object</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  rdfs:label &quot;Appellation Part: </xsl:text>
        <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
        <xsl:text>&quot;@en </xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P106i_forms_part_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f24"/>
        <xsl:text>/appellation/0&gt;</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/appellation/num&gt;</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  rdf:value &quot;</xsl:text>
        <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
        <xsl:text>&quot;</xsl:text>
        <xsl:call-template name="newline-dot-newline"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F24-appellation-edition-periodical">
    <xsl:if test="not(tei:citedRange[@wholePeriodical])">
      <xsl:if test="tei:edition">
        <xsl:variable name="uri-f24">
          <xsl:call-template name="get-F24-uri"/>
        </xsl:variable>
        <xsl:variable name="title" select="tei:edition/text()"/>

        <xsl:call-template name="comment">
          <xsl:with-param name="text" select="'#F24 appellation edition periodical issue'"/>
        </xsl:call-template>
        <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f24"/>
        <xsl:text>/appellation-ed/1&gt; a cidoc:E90_Symbolic_Object</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  rdfs:label &quot;Appellation Part: </xsl:text>
        <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
        <xsl:text>&quot;@en </xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P106i_forms_part_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f24"/>
        <xsl:text>/appellation/0&gt;</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/appellation/ed&gt;</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  rdf:value &quot;</xsl:text>
        <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
        <xsl:text>&quot;</xsl:text>
        <xsl:call-template name="newline-dot-newline"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F22-subtitle-issue">
    <xsl:if test="tei:title[@level = 'a' and @type = 'subtitle']">
      <xsl:variable name="uri-f22">
        <xsl:call-template name="get-F22-uri"/>
      </xsl:variable>
      <xsl:variable name="title" select="tei:title[@level = 'a' and @type = 'subtitle']/text()"/>

      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#F22 subtitle issue'"/>
      </xsl:call-template>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f22"/>
      <xsl:text>/title/1&gt; a cidoc:E35_Title</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P102i_is_title_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f22"/>
      <xsl:text>&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  rdfs:label &quot;Title: </xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;@en</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/title/sub&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:if test="starts-with($title, '[') and ends-with($title, ']')">
        <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/title/prov&gt;</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
      </xsl:if>
      <xsl:text>  rdf:value &quot;</xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;</xsl:text>
      <xsl:call-template name="newline-dot-newline"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F28">
    <xsl:if
      test="tei:author[not(@role) or (@role != 'pretext' and @role != 'Gründerin' and @role != 'Herausgeber')] or contains(tei:date/tei:note/text(), 'Entst.')">
      <xsl:variable name="title">
        <xsl:call-template name="get-F22-title"/>
      </xsl:variable>
      <xsl:variable name="uri">
        <xsl:call-template name="get-F22-uri"/>
      </xsl:variable>

      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#F28'"/>
      </xsl:call-template>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri"/>
      <xsl:text>/creation&gt; a frbroo:F28_Expression_Creation</xsl:text>
      <xsl:call-template name="newline-semicolon"/>

      <xsl:text>  rdfs:label &quot;Creation of: </xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;@en</xsl:text>
      <xsl:call-template name="newline-semicolon"/>

      <xsl:text>  frbroo:R17_created &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri"/>
      <xsl:text>&gt;</xsl:text>
      <xsl:if test="contains(tei:date/tei:note/text(), 'Entst.')">
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P4_has_time-span &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri"/>
        <xsl:text>/creation/time-span&gt;</xsl:text>
      </xsl:if>

      <xsl:for-each
        select="tei:author[not(@role) or (@role != 'pretext' and @role != 'Gründerin' and @role != 'Herausgeber')]">
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P14_carried_out_by &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="translate(@key, '#', '')"/>
        <xsl:text>&gt;</xsl:text>
      </xsl:for-each>
      <xsl:call-template name="newline-dot-newline"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F28-edText">
    <xsl:if test="tei:editor">
      <xsl:variable name="title">
        <xsl:call-template name="get-F22-title"/>
      </xsl:variable>
      <xsl:variable name="uri-f22ed" select="translate(tei:title[@level = 'm']/@key, '#', '')"/>

      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#F28 edText'"/>
      </xsl:call-template>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f22ed"/>
      <xsl:text>/creation&gt; a frbroo:F28_Expression_Creation</xsl:text>
      <xsl:call-template name="newline-semicolon"/>

      <xsl:text>  rdfs:label &quot;Creation: </xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;@en</xsl:text>
      <xsl:call-template name="newline-semicolon"/>

      <xsl:text>  frbroo:R17_created &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f22ed"/>
      <xsl:text>&gt;</xsl:text>

      <xsl:for-each select="tei:editor">
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P14_carried_out_by &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="translate(@key, '#', '')"/>
        <xsl:text>&gt;</xsl:text>
      </xsl:for-each>
      <xsl:call-template name="newline-dot-newline"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F28-ed">
    <xsl:if test="tei:author">
      <xsl:variable name="title">
        <xsl:call-template name="get-F22-title"/>
      </xsl:variable>
      <xsl:variable name="uri">
        <xsl:call-template name="get-F22-uri"/>
      </xsl:variable>

      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#F28 ed'"/>
      </xsl:call-template>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri"/>
      <xsl:text>/creation&gt; a frbroo:F28_Expression_Creation</xsl:text>
      <xsl:call-template name="newline-semicolon"/>

      <xsl:text>  rdfs:label &quot;Edition: </xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;@en</xsl:text>
      <xsl:call-template name="newline-semicolon"/>

      <xsl:text>  frbroo:R17_created &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri"/>
      <xsl:text>&gt;</xsl:text>

      <xsl:for-each select="tei:author">
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P14_carried_out_by &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="translate(@key, '#', '')"/>
        <xsl:text>&gt;</xsl:text>
      </xsl:for-each>
      <xsl:call-template name="newline-dot-newline"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F28-orig">
    <xsl:if test="tei:author[@role = 'pretext']">
      <xsl:variable name="title">
        <xsl:call-template name="get-F22-title"/>
      </xsl:variable>
      <xsl:variable name="uri">
        <xsl:call-template name="get-F22-uri"/>
      </xsl:variable>

      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#F28 orig'"/>
      </xsl:call-template>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri"/>
      <xsl:text>orig/creation&gt; a frbroo:F28_Expression_Creation</xsl:text>
      <xsl:call-template name="newline-semicolon"/>

      <xsl:text>  rdfs:label &quot;Creation of original: </xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;@en</xsl:text>
      <xsl:call-template name="newline-semicolon"/>

      <xsl:text>  frbroo:R17_created &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri"/>
      <xsl:text>orig&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>

      <xsl:text>  cidoc:P14_carried_out_by &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="translate(tei:author[@role = 'pretext']/@key, '#', '')"/>
      <xsl:text>&gt;</xsl:text>

      <xsl:call-template name="newline-dot-newline"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-E52-creation-timespan">
    <xsl:if test="contains(tei:date/tei:note/text(), 'Entst.')">
      <xsl:if test="tei:date[@when or @notBefore or @notAfter]">
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

        <xsl:call-template name="comment">
          <xsl:with-param name="text" select="'#E52 creation time-span'"/>
        </xsl:call-template>
        <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri"/>
        <xsl:text>/creation/time-span&gt; a cidoc:E52_Time-Span</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  rdfs:label &quot;</xsl:text>
        <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
        <xsl:text>&quot;@en</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P4i_is_time-span_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri"/>
        <xsl:text>/creation&gt;</xsl:text>
        <xsl:if test="$begin-date != ''">
          <xsl:call-template name="newline-semicolon"/>
          <xsl:text>  cidoc:P82a_begin_of_the_begin </xsl:text>
          <xsl:value-of select="$begin-date"/>
        </xsl:if>
        <xsl:if test="$end-date != ''">
          <xsl:call-template name="newline-semicolon"/>
          <xsl:text>  cidoc:P82b_end_of_the_end </xsl:text>
          <xsl:value-of select="$end-date"/>
        </xsl:if>
        <xsl:if test="tei:date[@type = 'approx'] or $begin-date = '' or $end-date = ''">
          <xsl:call-template name="newline-semicolon"/>
          <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/date/approx&gt;</xsl:text>
        </xsl:if>
        <xsl:call-template name="newline-dot-newline"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F30">
    <xsl:if
      test="tei:date and not(tei:date/tei:note/text() = 'UA' or tei:date/tei:note/text() = 'Entst.')">
      <xsl:variable name="title">
        <xsl:call-template name="get-F22-title"/>
      </xsl:variable>
      <xsl:variable name="uri">
        <xsl:call-template name="get-F22-uri"/>
      </xsl:variable>

      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#F30'"/>
      </xsl:call-template>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri"/>
      <xsl:text>/publication&gt; a frbroo:F30_Publication_Event</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  rdfs:label &quot;Publication of: </xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;@en</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  frbroo:R24_created &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri"/>
      <xsl:text>/published-expression&gt;</xsl:text>
      <xsl:for-each select="tei:pubPlace">
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P7_took_place_at &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="translate(@key, '#', '')"/>
        <xsl:text>&gt;</xsl:text>
      </xsl:for-each>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P4_has_time-span &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri"/>
      <xsl:text>/publication/time-span&gt;</xsl:text>
      <xsl:call-template name="newline-dot-newline"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F30-issue">
    <xsl:if
      test="tei:date and not(tei:date/tei:note/text() = 'UA' or tei:date/tei:note/text() = 'Entst.')">
      <xsl:variable name="title">
        <xsl:call-template name="get-F24-title"/>
      </xsl:variable>
      <xsl:variable name="uri">
        <xsl:choose>
          <xsl:when test="tei:title[@level = 'm'][@key]">
            <xsl:call-template name="get-F24-uri-m"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="get-F24-uri"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="uri-origin">
        <xsl:call-template name="get-F24-uri-origin"/>
      </xsl:variable>

      <xsl:if test="not(tei:citedRange[@wholePeriodical = 'yes'] and $uri-origin = 'id')">
        <xsl:call-template name="comment">
          <xsl:with-param name="text" select="'#F30 issue'"/>
        </xsl:call-template>
        <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri"/>
        <xsl:text>/publication&gt; a frbroo:F30_Publication_Event</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  rdfs:label &quot;Publication of: </xsl:text>
        <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
        <xsl:text>&quot;@en</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  frbroo:R24_created &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri"/>
        <xsl:text>/published-expression&gt;</xsl:text>
        <xsl:for-each select="tei:pubPlace">
          <xsl:call-template name="newline-semicolon"/>
          <xsl:text>  cidoc:P7_took_place_at &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
          <xsl:value-of select="translate(@key, '#', '')"/>
          <xsl:text>&gt;</xsl:text>
        </xsl:for-each>
        <xsl:if test="not(tei:date/tei:note/text() = 'UA' or tei:date/tei:note/text() = 'Entst.')">
          <xsl:call-template name="newline-semicolon"/>
          <xsl:text>  cidoc:P4_has_time-span &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
          <xsl:value-of select="$uri"/>
          <xsl:text>/publication/time-span&gt;</xsl:text>
        </xsl:if>
        <xsl:call-template name="newline-dot-newline"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-E52-publication-timespan">
    <xsl:if test="not(tei:date/tei:note/text() = 'UA' or tei:date/tei:note/text() = 'Entst.')">
      <xsl:if test="tei:date[@when or @notBefore or @notAfter]">
        <xsl:variable name="uri">
          <xsl:choose>
            <xsl:when test="tei:citedRange[@wholeText = 'yes']">
              <xsl:value-of select="tei:citedRange[@wholeText = 'yes']/@xml:id"/>
            </xsl:when>
            <xsl:when test="tei:title[@level = 'm']">
              <xsl:call-template name="get-F24-uri-m"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="get-F24-uri"/>
            </xsl:otherwise>
          </xsl:choose>
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

        <xsl:variable name="uri-origin">
          <xsl:call-template name="get-F24-uri-origin"/>
        </xsl:variable>

        <xsl:if test="not(tei:citedRange[@wholePeriodical = 'yes'] and $uri-origin = 'id')">
          <xsl:call-template name="comment">
            <xsl:with-param name="text" select="'#E52 publication time-span'"/>
          </xsl:call-template>
          <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
          <xsl:value-of select="$uri"/>
          <xsl:text>/publication/time-span&gt; a cidoc:E52_Time-Span</xsl:text>
          <xsl:call-template name="newline-semicolon"/>
          <xsl:text>  rdfs:label &quot;</xsl:text>
          <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
          <xsl:text>&quot;@en</xsl:text>
          <xsl:call-template name="newline-semicolon"/>
          <xsl:text>  cidoc:P4i_is_time-span_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
          <xsl:value-of select="$uri"/>
          <xsl:text>/publication&gt;</xsl:text>
          <xsl:if test="$begin-date != ''">
            <xsl:call-template name="newline-semicolon"/>
            <xsl:text>  cidoc:P82a_begin_of_the_begin </xsl:text>
            <xsl:value-of select="$begin-date"/>
          </xsl:if>
          <xsl:if test="$end-date != ''">
            <xsl:call-template name="newline-semicolon"/>
            <xsl:text>  cidoc:P82b_end_of_the_end </xsl:text>
            <xsl:value-of select="$end-date"/>
          </xsl:if>
          <xsl:if test="tei:date[@type = 'approx'] or $begin-date = '' or $end-date = ''">
            <xsl:call-template name="newline-semicolon"/>
            <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/date/approx&gt;</xsl:text>
          </xsl:if>
          <xsl:call-template name="newline-dot-newline"/>
        </xsl:if>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-E52-publication-timespan-issue">
    <xsl:if test="not(tei:date/tei:note/text() = 'UA' or tei:date/tei:note/text() = 'Entst.')">
      <xsl:if test="tei:date[@when or @notBefore or @notAfter]">
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

        <xsl:call-template name="comment">
          <xsl:with-param name="text" select="'#E52 issue publication time-span'"/>
        </xsl:call-template>
        <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri"/>
        <xsl:text>/publication/time-span&gt; a cidoc:E52_Time-Span</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  rdfs:label &quot;</xsl:text>
        <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
        <xsl:text>&quot;@en</xsl:text>
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P4i_is_time-span_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri"/>
        <xsl:text>/publication&gt;</xsl:text>
        <xsl:if test="$begin-date != ''">
          <xsl:call-template name="newline-semicolon"/>
          <xsl:text>  cidoc:P82a_begin_of_the_begin </xsl:text>
          <xsl:value-of select="$begin-date"/>
        </xsl:if>
        <xsl:if test="$end-date != ''">
          <xsl:call-template name="newline-semicolon"/>
          <xsl:text>  cidoc:P82b_end_of_the_end </xsl:text>
          <xsl:value-of select="$end-date"/>
        </xsl:if>
        <xsl:if test="tei:date[@type = 'approx'] or $begin-date = '' or $end-date = ''">
          <xsl:call-template name="newline-semicolon"/>
          <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/date/approx&gt;</xsl:text>
        </xsl:if>
        <xsl:call-template name="newline-dot-newline"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-F31">
    <xsl:if test="tei:date/tei:note/text() = 'UA'">
      <xsl:variable name="title">
        <xsl:call-template name="get-F22-title"/>
      </xsl:variable>
      <xsl:variable name="uri">
        <xsl:call-template name="get-F22-uri"/>
      </xsl:variable>

      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#F31 performance for F22'"/>
      </xsl:call-template>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri"/>
      <xsl:text>/performance&gt; a frbroo:F31_Performance</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  rdfs:label &quot;Performance / Recital of: </xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;@en</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  frbroo:R66_included_performed_version_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri"/>
      <xsl:text>&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P4_has_time-span &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri"/>
      <xsl:text>/performance/time-span&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/event/first&gt;</xsl:text>
      <xsl:call-template name="newline-dot-newline"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-E52-performance-timespan">
    <xsl:if test="tei:date/tei:note/text() = 'UA' and tei:date[@when or @notBefore or @notAfter]">
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

      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#E52 performance time-span'"/>
      </xsl:call-template>
      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri"/>
      <xsl:text>/performance/time-span&gt; a cidoc:E52_Time-Span</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  rdfs:label &quot;</xsl:text>
      <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
      <xsl:text>&quot;@en</xsl:text>
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P4i_is_time-span_of &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri"/>
      <xsl:text>/performance&gt;</xsl:text>
      <xsl:if test="$begin-date != ''">
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P82a_begin_of_the_begin </xsl:text>
        <xsl:value-of select="$begin-date"/>
      </xsl:if>
      <xsl:if test="$end-date != ''">
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P82b_end_of_the_end </xsl:text>
        <xsl:value-of select="$end-date"/>
      </xsl:if>
      <xsl:if test="tei:date[@type = 'approx'] or $begin-date = '' or $end-date = ''">
        <xsl:call-template name="newline-semicolon"/>
        <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/date/approx&gt;</xsl:text>
      </xsl:if>
      <xsl:call-template name="newline-dot-newline"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-E42-xmlid-identifier">
    <xsl:variable name="uri-f22">
      <xsl:call-template name="get-F22-uri"/>
    </xsl:variable>

    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="'#E42 xml:id identifier'"/>
    </xsl:call-template>
    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri-f22"/>
    <xsl:text>/identifier/idno/0&gt; a cidoc:E42_Identifier</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  rdfs:label &quot;Identifier: </xsl:text>
    <xsl:value-of select="$uri-f22"/>
    <xsl:text>&quot;@en</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/idno/xml-id&gt;</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  cidoc:P1i_identifies &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri-f22"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  rdf:value &quot;</xsl:text>
    <xsl:value-of select="$uri-f22"/>
    <xsl:text>&quot;</xsl:text>
    <xsl:call-template name="newline-dot-newline"/>
  </xsl:template>

  <xsl:template name="create-E42-permalink-identifier">
    <xsl:variable name="uri-f22">
      <xsl:call-template name="get-F22-uri"/>
    </xsl:variable>
    <xsl:variable name="permalink">
      <xsl:text>https://kraus1933.ace.oeaw.ac.at/Gesamt.xml?template=register_intertexte.html&amp;letter=</xsl:text>
      <xsl:value-of select="substring(@sortKey, 1, 1)"/>
      <xsl:text>#</xsl:text>
      <xsl:value-of select="@xml:id"/>
    </xsl:variable>

    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="'#E42 permalink identifier'"/>
    </xsl:call-template>
    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri-f22"/>
    <xsl:text>/identifier/idno/2&gt; a cidoc:E42_Identifier</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  rdfs:label &quot;Identifier: </xsl:text>
    <xsl:value-of select="$permalink"/>
    <xsl:text>&quot;@en</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/idno/URL/dritte-walpurgisnacht&gt;</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  cidoc:P1i_identifies &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri-f22"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  rdf:value &quot;</xsl:text>
    <xsl:value-of select="$permalink"/>
    <xsl:text>&quot;</xsl:text>
    <xsl:call-template name="newline-dot-newline"/>
  </xsl:template>

  <xsl:template name="create-E42-url-identifier">
    <xsl:variable name="uri-f22">
      <xsl:call-template name="get-F22-uri"/>
    </xsl:variable>

    <xsl:variable name="target" select="tei:ref[@type = 'gen']/@target"/>
    <xsl:if test="$target != ''">
      <xsl:call-template name="comment">
        <xsl:with-param name="text" select="'#E42 url type identifier'"/>
      </xsl:call-template>

      <xsl:variable name="type">
        <xsl:text>https://sk.acdh.oeaw.ac.at/types/idno/URL</xsl:text>
        <xsl:choose>
          <xsl:when test="contains($target, '://anno.onb')">
            <xsl:text>/anno</xsl:text>
          </xsl:when>
          <xsl:when test="contains($target, '://faustedition')">
            <xsl:text>/faust-edition</xsl:text>
          </xsl:when>
          <xsl:when test="contains($target, '://nietzschesource')">
            <xsl:text>/nietzsche-source</xsl:text>
          </xsl:when>
          <xsl:when test="contains($target, '://archive.org')">
            <xsl:text>/archive-org</xsl:text>
          </xsl:when>
          <xsl:when
            test="contains($target, '://de.wikisource') or contains($target, '://la.wikisource')">
            <xsl:text>/wikisource</xsl:text>
          </xsl:when>
          <xsl:when test="contains($target, '://fackel')">
            <xsl:text>/fackel</xsl:text>
          </xsl:when>
          <xsl:when test="contains($target, '://gallica')">
            <xsl:text>/gallica</xsl:text>
          </xsl:when>
          <xsl:when test="contains($target, '://textgridrep')">
            <xsl:text>/textgrid</xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f22"/>
      <xsl:text>/identifier/idno/3&gt; a cidoc:E42_Identifier</xsl:text>
      <xsl:call-template name="newline-semicolon"/>

      <xsl:text>  rdfs:label &quot;Identifier: </xsl:text>
      <xsl:value-of select="$target"/>
      <xsl:text>&quot;@en</xsl:text>
      <xsl:call-template name="newline-semicolon"/>

      <xsl:text>  cidoc:P2_has_type &lt;</xsl:text>
      <xsl:value-of select="$type"/>
      <xsl:text>&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>

      <xsl:text>  cidoc:P1i_identifies &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="$uri-f22"/>
      <xsl:text>&gt;</xsl:text>
      <xsl:call-template name="newline-semicolon"/>

      <xsl:text>  rdf:value &quot;</xsl:text>
      <xsl:value-of select="$target"/>
      <xsl:text>&quot;</xsl:text>
      <xsl:call-template name="newline-dot-newline"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="create-E42-INT1-xmlid-identifier">
    <xsl:variable name="uri-f22">
      <xsl:call-template name="get-F22-uri"/>
    </xsl:variable>

    <xsl:for-each select="tei:citedRange">
      <xsl:if test="not(@wholeText) and not(@wholePeriodical)">
        <xsl:variable name="uri-citedrange" select="@xml:id"/>

        <xsl:call-template name="comment">
          <xsl:with-param name="text" select="'#E42 textpassage xml:id identifier'"/>
        </xsl:call-template>

        <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-citedrange"/>
        <xsl:text>/identifier/idno/0&gt; a cidoc:E42_Identifier</xsl:text>
        <xsl:call-template name="newline-semicolon"/>

        <xsl:text>  rdfs:label &quot;Identifier: </xsl:text>
        <xsl:value-of select="$uri-citedrange"/>
        <xsl:text>&quot;@en</xsl:text>
        <xsl:call-template name="newline-semicolon"/>

        <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/idno/xml-id&gt;</xsl:text>
        <xsl:call-template name="newline-semicolon"/>

        <xsl:text>  cidoc:P1i_identifies &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri-f22"/>
        <xsl:text>/passage/</xsl:text>
        <xsl:value-of select="position() - 1"/>
        <xsl:text>&gt;</xsl:text>
        <xsl:call-template name="newline-semicolon"/>

        <xsl:text>  rdf:value &quot;</xsl:text>
        <xsl:value-of select="$uri-citedrange"/>
        <xsl:text>&quot;</xsl:text>
        <xsl:call-template name="newline-dot-newline"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="create-E42-INT1-url-identifier">
    <xsl:variable name="uri-f22">
      <xsl:call-template name="get-F22-uri"/>
    </xsl:variable>

    <xsl:for-each select="tei:citedRange">
      <xsl:if test="not(@wholeText) and not(@wholePeriodical)">
        <xsl:variable name="uri-citedrange" select="@xml:id"/>

        <xsl:for-each select="tei:ref[@type = 'ext']">
          <xsl:call-template name="comment">
            <xsl:with-param name="text" select="'#E42 url type identifier'"/>
          </xsl:call-template>

          <xsl:variable name="type">
            <xsl:text>https://sk.acdh.oeaw.ac.at/types/idno/URL</xsl:text>
            <xsl:choose>
              <xsl:when test="contains(@target, '://anno.onb')">
                <xsl:text>/anno</xsl:text>
              </xsl:when>
              <xsl:when test="contains(@target, '://faustedition')">
                <xsl:text>/faust-edition</xsl:text>
              </xsl:when>
              <xsl:when test="contains(@target, '://nietzschesource')">
                <xsl:text>/nietzsche-source</xsl:text>
              </xsl:when>
              <xsl:when test="contains(@target, '://archive.org')">
                <xsl:text>/archive-org</xsl:text>
              </xsl:when>
              <xsl:when
                test="contains(@target, '://de.wikisource') or contains(@target, '://la.wikisource')">
                <xsl:text>/wikisource</xsl:text>
              </xsl:when>
              <xsl:when test="contains(@target, '://fackel')">
                <xsl:text>/fackel</xsl:text>
              </xsl:when>
              <xsl:when test="contains(@target, '://gallica')">
                <xsl:text>/gallica</xsl:text>
              </xsl:when>
              <xsl:when test="contains(@target, '://textgridrep')">
                <xsl:text>/textgrid</xsl:text>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>

          <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
          <xsl:value-of select="$uri-citedrange"/>
          <xsl:text>/identifier/idno/</xsl:text>
          <xsl:value-of select="position()"/>
          <xsl:text>&gt; a cidoc:E42_Identifier</xsl:text>
          <xsl:call-template name="newline-semicolon"/>

          <xsl:text>  rdfs:label &quot;Identifier: </xsl:text>
          <xsl:value-of select="@target"/>
          <xsl:text>&quot;@en</xsl:text>
          <xsl:call-template name="newline-semicolon"/>

          <xsl:text>  cidoc:P2_has_type &lt;</xsl:text>
          <xsl:value-of select="$type"/>
          <xsl:text>&gt;</xsl:text>
          <xsl:call-template name="newline-semicolon"/>

          <xsl:text>  cidoc:P1i_identifies &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
          <xsl:value-of select="$uri-f22"/>
          <xsl:text>/passage/</xsl:text>
          <xsl:value-of select="position() - 1"/>
          <xsl:text>&gt;</xsl:text>
          <xsl:call-template name="newline-semicolon"/>

          <xsl:text>  rdf:value &quot;</xsl:text>
          <xsl:value-of select="@target"/>
          <xsl:text>&quot;</xsl:text>
          <xsl:call-template name="newline-dot-newline"/>
        </xsl:for-each>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="create-INT3">
    <xsl:variable name="uri">
      <xsl:call-template name="get-F22-uri"/>
    </xsl:variable>

    <xsl:for-each select="tei:citedRange">
      <xsl:variable name="n" select="position() - 1"/>
      <xsl:if test="tei:ref[@type = 'int']">
        <xsl:call-template name="comment">
          <xsl:with-param name="text" select="'#INT3 intertext relationship'"/>
        </xsl:call-template>
        <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$uri"/>
        <xsl:text>/relation/</xsl:text>
        <xsl:value-of select="$n"/>
        <xsl:text>&gt; a ns1:INT3_IntertextualRelationship </xsl:text>
        <xsl:call-template name="newline-semicolon"/>

        <xsl:text>  rdfs:label &quot;Intertextual relation&quot;@en</xsl:text>
        <xsl:call-template name="newline-semicolon"/>

        <xsl:variable name="r13-uri">
          <xsl:call-template name="get-ref-uri">
            <xsl:with-param name="selector" select="."/>
            <xsl:with-param name="n" select="$n"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="r12-uri">
          <xsl:variable name="xmlid" select="translate(tei:ref[@type = 'int']/@target, '#', '')"/>
          <xsl:variable name="selector" select="//tei:citedRange[@xml:id = $xmlid]"/>
          <xsl:variable name="bibl" select="$selector/parent::tei:bibl"/>
          <xsl:variable name="id">
            <xsl:choose>
              <xsl:when test="$selector[@wholeText = 'yes']">
                <xsl:value-of select="$selector/@xml:id"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$bibl/@xml:id"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:value-of select="$id"/>

          <xsl:if test="not(//tei:citedRange[@xml:id = $id and @wholeText = 'yes'])">
            <xsl:text>/passage/</xsl:text>
            <xsl:value-of select="count($selector/preceding-sibling::tei:citedRange)"/>
          </xsl:if>
        </xsl:variable>

        <xsl:text>  ns1:R12_has_referred_to_entity &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$r12-uri"/>
        <xsl:text>&gt;</xsl:text>
        <xsl:call-template name="newline-semicolon"/>

        <xsl:text>  ns1:R13_has_referring_entity &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="$r13-uri"/>
        <xsl:text>&gt;</xsl:text>
        <xsl:call-template name="newline-dot-newline"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- 
Intertextuelle Relation

Da ist noch ein Wurm drin:

<https://sk.acdh.oeaw.ac.at/DWbibl04009/relation/0> a ns1:INT3_IntertextualRelationship ;
        rdfs:label "Intertextual relation"@en ;
        ns1:R12_has_referred_to_entity <https://sk.acdh.oeaw.ac.at/DWbibl04009/passage/0> ;
        ns1:R13_has_referring_entity <https://sk.acdh.oeaw.ac.at//passage/0> .

 * Die URI der referred to entity sollte eigentlich unten bei der referring entity stehen.
 * Die URI der (wirklichen) referred to entity richtet sich danach, ob im in @target anvisierten citedRange ein @wholeText, ein @wholePeriodical oder nichts davon befindet
    * Fall 1: @wholeText="yes": referred-to-URI baut auf ref[@type="int"/@target auf, ohne "#", einfach https://sk.acdh.oeaw.ac.at/DWbibl01075
    * Fall 2: @wholePeriodical="yes": referred-to-URI baut auf ref[@type="int"/@target auf, ohne "#", und hängt ein "/published-expression" dran - also https://sk.acdh.oeaw.ac.at/DWbibl01075/published-expression
    * Fall 3: nichts davon: referred-to-URI ist eine Textpassage und baut auf der Basis-ID des bibls auf, in dem das citedRange steckt, auf das das ref[@type="int"]/@target verweist, und hängt "/" und den Zähler hinten dran. Hier also: https://sk.acdh.oeaw.ac.at/DWbibl00025/passage/5
  -->

  <!-- helpers -->

  <xsl:template name="get-ref-uri">
    <xsl:param name="selector"/>
    <xsl:param name="n"/>
    <xsl:variable name="uri">
      <xsl:call-template name="get-F22-uri">
        <xsl:with-param name="base" select="$selector"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="uri-f24">
      <xsl:call-template name="get-F24-uri">
        <xsl:with-param name="base" select="$selector"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="not($selector/@wholeText = 'yes') and not($selector/@wholePeriodical = 'yes')">
        <xsl:value-of select="$uri"/>
        <xsl:text>/passage/</xsl:text>
        <xsl:value-of select="$n"/>
      </xsl:when>
      <xsl:when test="$selector/@wholeText = 'yes'">
        <xsl:value-of select="$uri"/>
      </xsl:when>
      <xsl:when test="$selector/@wholePeriodical = 'yes'">
        <xsl:value-of select="$uri-f24"/>
        <xsl:text>/published-expression</xsl:text>
      </xsl:when>
    </xsl:choose>
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
    <xsl:param name="base" select="."/>
    <xsl:variable name="bibl" select="$base/ancestor-or-self::tei:bibl"/>
    <xsl:choose>
      <xsl:when test="$bibl/tei:citedRange[@wholePeriodical = 'yes']">
        <xsl:value-of select="$bibl/tei:citedRange[@wholePeriodical = 'yes']/@xml:id"/>
      </xsl:when>
      <xsl:when test="$bibl/tei:citedRange[@wholeText = 'yes']">
        <xsl:value-of select="$bibl/tei:citedRange[@wholeText = 'yes']/@xml:id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$bibl/@xml:id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="get-F24-uri">
    <xsl:param name="base" select="."/>
    <xsl:variable name="bibl" select="$base/ancestor-or-self::tei:bibl"/>

    <xsl:variable name="uri">
      <xsl:choose>
        <xsl:when test="$bibl/tei:title[@level = 'a']">
          <xsl:choose>
            <xsl:when test="$bibl/tei:date[@key]">
              <xsl:value-of select="$bibl/tei:date/@key"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$bibl/tei:title[@level = 'm']/@key"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$bibl/tei:citedRange[@wholeText = 'yes']">
              <xsl:value-of select="$bibl/tei:citedRange[@wholeText = 'yes']/@xml:id"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$bibl/@xml:id"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="translate($uri, '#', '')"/>
  </xsl:template>

  <xsl:template name="get-F24-uri-origin">
    <xsl:param name="base" select="."/>
    <xsl:variable name="bibl" select="$base/ancestor-or-self::tei:bibl"/>

    <xsl:variable name="uri">
      <xsl:choose>
        <xsl:when test="$bibl/tei:title[@level = 'a']">
          <xsl:choose>
            <xsl:when test="$bibl/tei:date[@key]">
              <xsl:text>date-key</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>title-m-key</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$bibl/tei:citedRange[@wholeText = 'yes']">
              <xsl:text>cited-wholetext-id</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>id</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="translate($uri, '#', '')"/>
  </xsl:template>

  <xsl:template name="get-F24-uri-m">
    <xsl:param name="base" select="."/>
    <xsl:variable name="bibl" select="$base/ancestor-or-self::tei:bibl"/>

    <xsl:variable name="uri">
      <xsl:choose>
        <xsl:when test="$bibl/tei:title[@level = 'm'][@key]">
          <xsl:value-of select="$bibl/tei:title[@level = 'm']/@key"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$bibl/@xml:id"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="translate($uri, '#', '')"/>
  </xsl:template>

  <xsl:template name="get-F22-title">
    <xsl:choose>
      <xsl:when test="tei:title[@level = 'a']">
        <xsl:value-of
          select="replace(translate(tei:title[@level = 'a' and not(@type)], '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"
        />
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
    <xsl:value-of select="replace(translate($title, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
  </xsl:template>

  <xsl:template name="get-timespan-title">
    <xsl:choose>
      <xsl:when test="tei:date/@notBefore and tei:date/@notAfter">
        <xsl:value-of select="tei:date/@notBefore"/>
        <xsl:text> - </xsl:text>
        <xsl:value-of select="tei:date/@notAfter"/>
      </xsl:when>
      <xsl:when test="tei:date/@when">
        <xsl:value-of select="tei:date/@when"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="tei:date/text()"/>
      </xsl:otherwise>
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
      <xsl:otherwise>
        <xsl:text/>
      </xsl:otherwise>
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
      <xsl:otherwise>
        <xsl:text/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="format-date-and-type">
    <xsl:param name="date"/>

    <xsl:choose>
      <xsl:when test="string-length($date) = 4">
        <!-- YYYY -->
        <xsl:value-of select="concat('&quot;', $date, '&quot;^^xsd:gYear')"/>
      </xsl:when>
      <xsl:when test="string-length($date) = 5 and substring($date, 1, 1) = '-'">
        <!-- YYYY -->
        <xsl:value-of select="concat('&quot;', $date, '&quot;^^xsd:gYear')"/>
      </xsl:when>
      <xsl:when test="string-length($date) = 7 and substring($date, 5, 1) = '-'">
        <!-- YYYY-MM -->
        <xsl:value-of select="concat('&quot;', $date, '&quot;^^xsd:gYearMonth')"/>
      </xsl:when>
      <xsl:when
        test="string-length($date) = 8 and substring($date, 1, 1) = '-' and substring($date, 6, 1) = '-'">
        <!-- -YYYY-MM -->
        <xsl:value-of select="concat('&quot;', $date, '&quot;^^xsd:gYearMonth')"/>
      </xsl:when>
      <xsl:when
        test="string-length($date) = 10 and substring($date, 5, 1) = '-' and substring($date, 8, 1) = '-'">
        <!-- YYYY-MM-DD -->
        <xsl:value-of select="concat('&quot;', $date, '&quot;^^xsd:date')"/>
      </xsl:when>
      <xsl:when
        test="string-length($date) = 11 and substring($date, 1, 1) = '-' and substring($date, 6, 1) = '-' and substring($date, 9, 1) = '-'">
        <!-- -YYYY-MM-DD -->
        <xsl:value-of select="concat('&quot;', $date, '&quot;^^xsd:date')"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="comment">
    <xsl:param name="text"/>
    <xsl:value-of select="$text"/>
    <xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template name="newline-semicolon">
    <xsl:text> ;
</xsl:text>
  </xsl:template>

  <xsl:template name="newline-dot">
    <xsl:text> .
</xsl:text>
  </xsl:template>

  <xsl:template name="newline-dot-newline">
    <xsl:text> .

</xsl:text>
  </xsl:template>

</xsl:stylesheet>
