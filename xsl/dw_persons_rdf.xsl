<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
  <xsl:output method="text" encoding="UTF-8" media-type="text/plain" indent="no"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <xsl:call-template name="get-header"/>

    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="result">
    <xsl:variable name="count-quotes" select="number(1947)"/>

    <xsl:for-each select="item">
      <xsl:call-template name="create-INT1-textpassage">
        <xsl:with-param name="n" select="position() + $count-quotes"/>
      </xsl:call-template>
      <xsl:call-template name="create-E42-id-identifier">
        <xsl:with-param name="n" select="position() + $count-quotes"/>
      </xsl:call-template>
      <xsl:call-template name="create-E42-permalink-identifier">
        <xsl:with-param name="n" select="position() + $count-quotes"/>
      </xsl:call-template>
      <xsl:call-template name="create-INT16-segment">
        <xsl:with-param name="n" select="position() + $count-quotes"/>
      </xsl:call-template>
      <xsl:call-template name="create-INT2-actualized-feature">
        <xsl:with-param name="n" select="position() + $count-quotes"/>
      </xsl:call-template>
      <xsl:call-template name="create-INT18-reference">
        <xsl:with-param name="n" select="position() + $count-quotes"/>
      </xsl:call-template>
      <xsl:call-template name="create-entities"/>
    </xsl:for-each>

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
    <xsl:call-template name="newline-dot"/>
    <xsl:text>@prefix prov: &lt;http://www.w3.org/ns/prov#&gt;</xsl:text>
    <xsl:call-template name="newline-dot-newline"/>
  </xsl:template>

  <xsl:template name="create-INT1-textpassage">
    <xsl:param name="n"/>

    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="'#INT1 textpassage'"/>
    </xsl:call-template>

    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/DWbibl00000/passage/</xsl:text>
    <xsl:value-of select="$n"/>
    <xsl:text>&gt; a ns1:INT1_TextPassage</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  rdfs:label &quot;Text passage from: Dritte Walpurgisnacht&quot;@en</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  cidoc:P1_is_identified_by &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="id"/>
    <xsl:text>/identifier/idno/0&gt;</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  cidoc:P1_is_identified_by &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="id"/>
    <xsl:text>/identifier/idno/1&gt;</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  ns1:R10_is_Text_Passage_of &lt;https://sk.acdh.oeaw.ac.at/DWbibl00000&gt;</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  ns1:R18_shows_actualization &lt;https://sk.acdh.oeaw.ac.at/DWbibl00000/actualization/</xsl:text>
    <xsl:value-of select="$n"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  ns1:R41_has_location &quot;</xsl:text>
    <xsl:value-of select="paragraph"/>
    <xsl:text>&quot;^^xsd:string</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  ns1:R44_has_wording &quot;</xsl:text>
    <xsl:value-of select="replace(translate(content, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
    <xsl:text>&quot;</xsl:text>
    <xsl:call-template name="newline-dot-newline"/>
  </xsl:template>

  <xsl:template name="create-INT16-segment">
    <xsl:param name="n"/>

    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="'#INT16 segment'"/>
    </xsl:call-template>

    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/DWbibl00000/segment/</xsl:text>
    <xsl:value-of select="$n"/>
    <xsl:text>&gt; a ns1:INT16_Segment</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  rdfs:label &quot;Segment from: Dritte Walpurgisnacht"@en</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  ns1:R16_incorporates &lt;https://sk.acdh.oeaw.ac.at/DWbibl00000/passage/</xsl:text>
    <xsl:value-of select="$n"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  ns1:R25_is_segment_of &lt;https://sk.acdh.oeaw.ac.at/DWbibl00000/published-expression&gt;</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  ns1:R41_has_location &quot;</xsl:text>
    <xsl:value-of select="paragraph"/>
    <xsl:text>&quot;^^xsd:string</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  ns1:R44_has_wording &quot;</xsl:text>
    <xsl:value-of select="replace(translate(content, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
    <xsl:text>&quot;</xsl:text>
    <xsl:call-template name="newline-dot-newline"/>
  </xsl:template>

  <xsl:template name="create-E42-id-identifier">
    <xsl:param name="n"/>

    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="'#E42 id identifier'"/>
    </xsl:call-template>

    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="id"/>
    <xsl:text>/identifier/idno/0&gt; a cidoc:E42_Identifier</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  rdfs:label &quot;Identifier: </xsl:text>
    <xsl:value-of select="id"/>
    <xsl:text>&quot;@en</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/idno/xml-id&gt;</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  cidoc:P1i_identifies &lt;https://sk.acdh.oeaw.ac.at/DWbibl00000/passage/</xsl:text>
    <xsl:value-of select="$n"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  rdf:value &quot;</xsl:text>
    <xsl:value-of select="id"/>
    <xsl:text>&quot;</xsl:text>
    <xsl:call-template name="newline-dot-newline"/>
  </xsl:template>

  <xsl:template name="create-E42-permalink-identifier">
    <xsl:param name="n"/>

    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="'#E42 permalink identifier'"/>
    </xsl:call-template>

    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="id"/>
    <xsl:text>/identifier/idno/1&gt; a cidoc:E42_Identifier</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  rdfs:label &quot;Identifier: </xsl:text>
    <xsl:value-of select="permalink"/>
    <xsl:text>&quot;@en</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/idno/URL/dritte-walpurgisnacht&gt;</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  cidoc:P1i_identifies &lt;https://sk.acdh.oeaw.ac.at/DWbibl00000/passage/</xsl:text>
    <xsl:value-of select="$n"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  rdf:value &quot;</xsl:text>
    <xsl:value-of select="permalink"/>
    <xsl:text>&quot;</xsl:text>
    <xsl:call-template name="newline-dot-newline"/>
  </xsl:template>

  <xsl:template name="create-INT2-actualized-feature">
    <xsl:param name="n"/>

    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="'#INT2 Actualized Feature'"/>
    </xsl:call-template>

    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/DWbibl00000/actualization/</xsl:text>
    <xsl:value-of select="$n"/>
    <xsl:text>&gt; a ns1:INT2_ActualizationOfFeature</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  rdfs:label &quot;Actualization on: Dritte Walpurgisnacht&quot;@en</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  ns1:R17_actualizes_feature &lt;https://sk.acdh.oeaw.ac.at/DWbibl00000/reference/</xsl:text>
    <xsl:value-of select="$n"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:call-template name="newline-dot-newline"/>
  </xsl:template>

  <xsl:template name="create-INT18-reference">
    <xsl:param name="n"/>

    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="'#INT18 Reference'"/>
    </xsl:call-template>

    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/DWbibl00000/reference/</xsl:text>
    <xsl:value-of select="$n"/>
    <xsl:text>&gt; a ns1:INT18_Reference</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  rdfs:label &quot;Reference on: Dritte Walpurgisnacht&quot;@en</xsl:text>

    <xsl:if test="subtype = 'exemp'">
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P2_has_type &lt;https://sk.acdh.oeaw.ac.at/types/reference/exemp&gt;</xsl:text>
    </xsl:if>

    <xsl:if test="source[@n]">
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  prov:wasDerivedFrom </xsl:text>
      <xsl:for-each select="source/@n">
        <xsl:if test="position() &gt; 1">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:text> &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&gt;</xsl:text>
      </xsl:for-each>
    </xsl:if>

    <xsl:for-each select="tokenize(key, ' ')">
      <xsl:call-template name="newline-semicolon"/>
      <xsl:text>  cidoc:P67_refers_to &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
      <xsl:value-of select="translate(., '#', '')"/>
      <xsl:text>&gt;</xsl:text>
    </xsl:for-each>

    <xsl:call-template name="newline-dot-newline"/>
  </xsl:template>

<xsl:template name="create-entities">
  <xsl:for-each select="source[@n]">
    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="'#Entity'"/>
    </xsl:call-template>
    
    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="@n"/>    
    <xsl:text>&gt; a prov:Entity, dcterms:BibliographicResource</xsl:text>
    <xsl:call-template name="newline-semicolon"/>
    
    <xsl:text>  dcterms:bibliographicCitation &quot;</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>&quot;</xsl:text> 
    <xsl:call-template name="newline-dot-newline"/>
  </xsl:for-each>
</xsl:template>

  <!-- helpers -->

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
