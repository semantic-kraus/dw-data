#!/bin/bash
echo "downloading saxon"
wget https://github.com/Saxonica/Saxon-HE/raw/main/12/Java/SaxonHE12-1J.zip && unzip SaxonHE12-1J.zip -d saxon && rm -rf SaxonHE12-1J.zip

echo "transform"

java -jar saxon/saxon-he-12.1.jar -s:'data/indices/listperson.xml' -xsl:'xsl/fixtures.xsl' -o:'data/indices/listperson.xml'
java -jar saxon/saxon-he-12.1.jar -s:'data/indices/listbibl.xml' -xsl:'xsl/dw_rdf.xsl' -o:'rdf/texts.ttl'
java -jar saxon/saxon-he-12.1.jar -s:'data/DW_passages/person_permalinks_2023_04.xml' -xsl:'xsl/dw_persons_rdf.xsl' -o:'rdf/persons.ttl'
java -jar saxon/saxon-he-12.1.jar -s:'data/DW_passages/quote_permalinks_2023_04_additional_info.xml' -xsl:'xsl/dw_quotes_rdf.xsl' -o:'rdf/quotes.ttl'

rm -rf saxon
