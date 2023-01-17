import os
from slugify import slugify
from tqdm import tqdm
from acdh_tei_pyutils.tei import TeiReader
from rdflib import Graph, Namespace, URIRef, Literal
from rdflib.namespace import RDF, RDFS, OWL, XSD

SK = Namespace("https://sk.acdh.oeaw.ac.at/")
CIDOC = Namespace("http://www.cidoc-crm.org/cidoc-crm/")
FRBROO = Namespace("http://iflastandards.info/ns/fr/frbr/frbroo#")

rdf_dir = "./rdf"

os.makedirs(rdf_dir, exist_ok=True)

g = Graph()
doc = TeiReader("./data/indices/listbibl.xml")
nsmap = doc.nsmap

main_title_type = URIRef('https://sk.acdh.oeaw.ac.at/types/main-title')
sub_title_type = URIRef('https://sk.acdh.oeaw.ac.at/types/sub-title')

items = doc.any_xpath(".//tei:bibl")
for x in tqdm(items, total=len(items)):
    xml_id = x.attrib["{http://www.w3.org/XML/1998/namespace}id"]
    item_id = f"{SK}{xml_id}"
    subj = URIRef(item_id)
    g.add((subj, RDF.type, FRBROO["F22"]))
    title_uri = URIRef(f"{subj}/title")
    try:
        title_value = x.xpath('.//tei:title[@level="m"][1]/text()', namespaces=nsmap)[0]
    except IndexError:
        title_value = "kein titel"
    g.add((subj, CIDOC["P102_has_title"], title_uri))
    g.add((title_uri, RDF.type, CIDOC["E35_Title"]))
    g.add((title_uri, RDF.value, Literal(title_value)))
    g.add((title_uri, CIDOC["P2i_is_type_of"], main_title_type))
    g.add((title_uri, CIDOC["P102i_is_title_of"], subj))
    # creation F28
    subj_creation = URIRef(f"{subj}/F28")
    g.add((
        subj_creation, RDF.type, FRBROO["F28"]
    )),
    g.add((subj, FRBROO["R17i"], subj_creation))
    try:
        creation_date = x.xpath('.//tei:date[@when]/@when', namespaces=nsmap)[0]
    except IndexError:
        creation_date = None
    if creation_date:
        b_timestamp = URIRef(f"{SK}timestamp/{creation_date}")
        g.add((
            b_timestamp, RDF.type, CIDOC["E52_Time-Span"]
        ))

g.add((
    main_title_type, RDF.type, CIDOC["E55_Type"]
))
g.add((
    sub_title_type, RDF.type, CIDOC["E55_Type"]
))

g.serialize(f"{rdf_dir}/texts.ttl")
