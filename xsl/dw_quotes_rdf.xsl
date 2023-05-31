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
    <xsl:for-each select="item">
      <xsl:call-template name="create-INT1-textpassage">
        <xsl:with-param name="n" select="position() - 1"/>
      </xsl:call-template>
      <xsl:call-template name="create-INT3">
        <xsl:with-param name="n" select="position() - 1"/>
      </xsl:call-template>
      <xsl:call-template name="create-INT16-segment">
        <xsl:with-param name="n" select="position() - 1"/>
      </xsl:call-template>
      <xsl:call-template name="create-E42-id-identifier">
        <xsl:with-param name="n" select="position() - 1"/>
      </xsl:call-template>
      <xsl:call-template name="create-E42-permalink-identifier">
        <xsl:with-param name="n" select="position() - 1"/>
      </xsl:call-template>
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
    <xsl:text>@prefix ns1: &lt;https://w3id.org/lso/intro/Vx/#&gt;</xsl:text>
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

    <xsl:text>  ns1:R41_has_location &quot;</xsl:text>
    <xsl:value-of select="paragraph"/>
    <xsl:text>&quot;^^xsd:string</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  ns1:R44_has_wording &quot;</xsl:text>
    <xsl:value-of select="replace(translate(content, '&#x9;&#xa;&#xd;', ' '), '(\s)+', ' ')"/>
    <xsl:text>&quot;</xsl:text>
    <xsl:call-template name="newline-dot-newline"/>
  </xsl:template>

  <!-- 
  #INT3 intertext relationship
<https://sk.acdh.oeaw.ac.at/DWbibl0000/relation/[n]> a ns1:INT3_IntertextualRelationship  ;
  rdfs:label "Intertextual relation"@en ;
  ns1:R12_has_referred_to_entity [referred-to-URI] ;
  ns1:R13_has_referring_entity <https://sk.acdh.oeaw.ac.at/DWbibl0000/passage/[n]> .

 <info source="DWbibl00906" wholeText="no" wholePeriodical="no" refInt="no" refIntSubtype="no" refLevel="none" posCitedRange="1"/>
  -->

  <xsl:template name="create-INT3">
    <xsl:param name="n"/>

    <xsl:variable name="uri">
      <xsl:choose>
        <xsl:when test="(info[@wholeText = 'no' and @wholePeriodical = 'no' and @refInt = 'no']) or (info[@refIntSubtype='nonexcl' and @refInt != 'no'] and type/text() != 'exemp')">
          <!-- 
            citedRange[not(./ref[@type="int"]) and not(@wholeText) and not(@wholePeriodical)]
            
            > Verweis auf simple Textstelle; referred-to-URI ist die der Textpassage: aus der Basis-URI + "/passage/" plus 
            Ordinalzahl aus Zählung der citedRange-Elemente
          -->
          <xsl:text>/passage/</xsl:text>
          <xsl:value-of select="info/@posCitedRange"/>
        </xsl:when>
        <xsl:when test="(info[@wholeText = 'yes' and @refInt = 'no']) or (info[@refIntSubtype='nonexcl' and @refInt != 'no'] and type/text() != 'exemp')">
          <!-- 
            citedRange[not(./ref[@type="int"]) and @wholeText]
            
            > Verweis auf gesamten Text; referred-to-URI ist die F22-URI aus citedRange/@xml:id
          -->
          <xsl:value-of select="info/@source"/>
        </xsl:when>
        <xsl:when test="(info[@wholePeriodical = 'yes' and @refInt = 'no']) or (info[@refIntSubtype='nonexcl' and @refInt != 'no'] and type/text() != 'exemp')">
          <!-- 
            citedRange[not(./ref[@type="int"]) and @wholePeriodical]
            > Verweis auf gesamte Zeitschrift; referred-to-URI ist die F24-URI der Zeitschrift aus citedRange/@xml:id + "/published-expression"
          -->
          <xsl:value-of select="info/@source"/>
          <xsl:text>/published-expression</xsl:text>
        </xsl:when>
          <!-- 
            Teil 3 der referred-to-entities der INT3 aus Barbaras xml:
            
            Weist der Wert im source-Element auf ein citedRange[./ref[@type="int"]]?
            
            Fall 2: Und gilt außerdem, dass //item[./type!="exemp" and info/@refIntSubtype="nonexcl"]?
            
            Fall 2.1: Wenn für das wiederum im @refInt refrenzierte citedRange gilt: ref[@type="int" and @subtype="specific"]
            
            Dann ist die referred-to URI auf Grundlage des Wertes aus @refInt zu bauen, und zwar: 
          -->
        <xsl:when test="info[@refIntSubtype='nonexcl' and @refInt = 'yes' and @refIntSubtype='specific' and @refLevel='text'] and type/text() != 'exemp'">
          <!-- 
            wenn @refLevel="text" als F22-URI, also https://sk.acdh.oeaw.ac.at/[@refInt]
          -->
          <xsl:value-of select="info/@refInt"/>
        </xsl:when>
        <xsl:when test="info[@refIntSubtype='nonexcl' and @refInt = 'yes' and @refIntSubtype='specific' and @refLevel='none'] and type/text() != 'exemp'">
          <!-- 
            wenn @refLevel="none" als Textpassagen-URI, das heißt: 
            
            bei dem im @refInt referenzierten citedRange nachsehen, das wievielte es innerhalb seines eigenen bibl es ist (Zählung ab Null)
            nachsehen, was dort die Basis-URI ist (einen citedRange[@wholeText]/@xml:id, sonst bibl/@xml:id)
            daraus die Textpassagen-URI bauen: https://sk.acdh.oeaw.ac.at/Basis-URI/passage/[n]
          -->
          <xsl:text>/passage/</xsl:text><xsl:value-of select="info/@posCitedRange"/>
        </xsl:when>
        <!-- 
            Teil 3 der referred-to-entities der INT3 aus Barbaras xml:

            Weist der Wert im source-Element auf ein citedRange[./ref[@type="int"]]?
            
            Fall 2: Und gilt außerdem, dass //item[./type!="exemp" and info/@refIntSubtype="nonexcl"]?
            
            Fall 2.2: Wenn für das wiederum im @refInt referenzierte citedRange gilt: ref[@type="int" and @subtype="nonexcl"]
            
            Dann wird gleich verfahren, bloß wird die referred-to-URI aus dem citedRange gebaut, das im ref[@type="int"] des 
            citedRange referenziert wird, das in @refInt referenziert wird.
            
            Das heißt, dass auch hier wieder zwischen @wholeText und nicht-@wholeText unterschieden werden muss, entweder muss 
            die F22 oder die Textpassage gebaut werden, wie oben.
        -->
      </xsl:choose>
    </xsl:variable>


    <xsl:call-template name="comment">
      <xsl:with-param name="text" select="'#INT3 intertext relationship'"/>
    </xsl:call-template>

    <xsl:text>&lt;https://sk.acdh.oeaw.ac.at/DWbibl00000/relation/</xsl:text>
    <xsl:value-of select="$n"/>
    <xsl:text>&gt; a ns1:INT3_IntertextualRelationship</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  rdfs:label &quot;Intertextual relation&quot;@en</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  ns1:R12_has_referred_to_entity &lt;https://sk.acdh.oeaw.ac.at/</xsl:text>
    <xsl:value-of select="$uri"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:call-template name="newline-semicolon"/>

    <xsl:text>  ns1:R13_has_referring_entity &lt;https://sk.acdh.oeaw.ac.at/DWbibl00000/passage/</xsl:text>
    <xsl:value-of select="$n"/>
    <xsl:text>&gt;</xsl:text>
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
