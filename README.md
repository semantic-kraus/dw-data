# dw_data

[![Build and publish](https://github.com/semantic-kraus/dw_data/actions/workflows/build.yml/badge.svg)](https://github.com/semantic-kraus/dw_data/actions/workflows/build.yml)

Daten in `data/indices` stammen aus dem nicht öffentlichen GitLab Repo [DritteWalpurgsnacht Index](https://gitlab.oeaw.ac.at/acdh-ch/ace/semanticKraus/DritteWalpurgisnacht_Index)

* `python scripts/make_rdf.py` transformiert Index-Daten nach RDF

Verallgemeinerbare Schritte wie z.B
* das Konvertieren von `tei:persName` Elementen in (`cidoc:E55_Type` typisierte) `cidoc:E33_E41_Linguistic_Appellation` Triple,
* das Generieren von `cidoc:E42_Identifier` aus `@xml:id` und `tei:idno` Elementen,
* oder die Extraktion und korrekte Typisierung von Datumsangaben aus den diversen Datums-Attributen der TEI

werden in ein eigenes Python-Package [acdh-cidoc-pyutils](https://github.com/acdh-oeaw/acdh-cidoc-pyutils) ausgelagert.

Bei jedem Push ins Repo wird eine einfache [GitHub-Page](https://semantic-kraus.github.io/dw_data/) erstellt von der die aktuelle Version des RDF-Graphen heruntergeladen werden kann.

## Licensing

All code unless otherwise noted is licensed under the terms [MIT License](https://opensource.org/licenses/MIT).

For licensing information of the data in this repository, please look into the individual folders/files for further information.


### notes

`curl -X POST -H "Content-Type:application/trig" -T data.trig  http://localhost:7200/repositories/play/statements -u "admin:root"`
(to post data into graphdh repo called `play`)