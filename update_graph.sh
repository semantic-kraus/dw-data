# bin/bash

echo "delete namedgraphs"
curl -D- -X DELETE \
    -u $R_USER \
    'https://sk-blazegraph.acdh-dev.oeaw.ac.at/blazegraph/sparql?c=<https://sk.acdh.oeaw.ac.at/project/dritte-walpurgisnacht>&c=<https://sk.acdh.oeaw.ac.at/provenance>&c=<https://sk.acdh.oeaw.ac.at/model>&c=<https://sk.acdh.oeaw.ac.at/general>'
sleep 60

echo "add namedgraph data.trig"
curl -u $R_USER \
    $R_ENDPOINT \
    -H 'Content-Type: application/x-trig; charset=UTF-8' \
    -H 'Accept: text/boolean' \
    -d @rdf/data.trig
sleep 60

echo "add namedgraph quotes.trig"
curl -u $R_USER \
    $R_ENDPOINT \
    -H 'Content-Type: application/x-trig; charset=UTF-8' \
    -H 'Accept: text/boolean' \
    -d @rdf/quotes.trig
sleep 60

echo "add namedgraph persons.trig"
curl -u $R_USER \
    $R_ENDPOINT \
    -H 'Content-Type: application/x-trig; charset=UTF-8' \
    -H 'Accept: text/boolean' \
    -d @rdf/persons.trig
sleep 60

echo "add namedgraph texts.trig"
curl -u $R_USER \
    $R_ENDPOINT \
    -H 'Content-Type: application/x-trig; charset=UTF-8' \
    -H 'Accept: text/boolean' \
    -d @rdf/texts.trig