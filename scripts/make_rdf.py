import os
from acdh_tei_pyutils.tei import TeiReader
from rdflib import Graph, Namespace, URIRef, Literal
from rdflib.namespace import RDF, RDFS, OWL, XSD

SK = Namespace("https://sk.acdh.oeaw.ac.at/")
CIDOC = Namespace("http://www.cidoc-crm.org/cidoc-crm/")
FRBROO = Namespace("http://iflastandards.info/ns/fr/frbr/frbroo#")
doc = TeiReader("./data/indices/listperson.xml")
doc.nsmap

rdf_dir = "./rdf"

os.makedirs(rdf_dir, exist_ok=True)

g = Graph()
for x in doc.any_xpath(".//tei:person"):
    xml_id = x.attrib["{http://www.w3.org/XML/1998/namespace}id"]
    item_id = f"{SK}{xml_id}"
    subj = URIRef(item_id)
    g.add((subj, RDF.type, CIDOC["E21_Person"]))
    try:
        gnd = x.xpath('.//tei:idno[@type="GND"]/text()', namespaces=doc.nsmap)[0]
    except IndexError:
        gnd = None
    if gnd:
        gnd_uri = URIRef(f"https://https://d-nb.info/gnd/{gnd}")
        g.add((subj, OWL["sameAs"], gnd_uri))
        g.add((gnd_uri, RDF.type, CIDOC["E42_Identifier"]))
    try:
        label = x.xpath(
            './/tei:persName[@type="sk"][@subtype="pref"]/text()', namespaces=doc.nsmap
        )[0]
    except IndexError:
        label = None
    if label:
        g.add((subj, RDFS.label, Literal(label, lang="de")))
    # birth
    try:
        birth = x.xpath(".//tei:birth[@when]/@when", namespaces=doc.nsmap)[0]
    except IndexError:
        birth = None
    if birth:
        b_uri = URIRef(f"{SK}{xml_id}/birth")
        b_timestamp = URIRef(f"{SK}timestamp/{birth}")
        g.add((b_uri, RDF.type, CIDOC["E67_Birth"]))
        if label:
            g.add((b_uri, RDFS.label, Literal(f"Geburt von {label}", lang="de")))
        g.add((b_uri, CIDOC["P98_brought_into_life"], subj))
        g.add((b_uri, CIDOC["P4_has_time-span"], b_timestamp))
        g.add((b_timestamp, RDF.type, CIDOC["E52_Time-Span"]))
        g.add(
            (
                b_timestamp,
                CIDOC["P82a_begin_of_the_begin"],
                Literal(birth, datatype=XSD.date),
            )
        )
        g.add(
            (
                b_timestamp,
                CIDOC["P82b_end_of_the_end"],
                Literal(birth, datatype=XSD.date),
            )
        )
        g.add((b_timestamp, RDF.value, Literal(birth, datatype=XSD.date)))
        try:
            place = x.xpath(".//tei:birth/tei:placeName", namespaces=doc.nsmap)[0]
        except IndexError:
            place = None
        if place is not None:
            place_id = place.attrib["key"][1:]
            place_name = place.text
            place_uri = URIRef(f"{SK}{place_id}")
            g.add((b_uri, CIDOC["P7_took_place_at"], place_uri))
            g.add((place_uri, RDF.type, CIDOC["E53_Place"]))

        # death
        try:
            death = x.xpath(".//tei:death[@when]/@when", namespaces=doc.nsmap)[0]
        except IndexError:
            death = None
        if death:
            b_uri = URIRef(f"{SK}{xml_id}/death")
            b_timestamp = URIRef(f"{SK}timestamp/{death}")
            g.add((b_uri, RDF.type, CIDOC["E67_Death"]))
            if label:
                g.add((b_uri, RDFS.label, Literal(f"Tot von {label}", lang="de")))
            g.add((b_uri, CIDOC["P100_was_death_of"], subj))
            g.add((b_uri, CIDOC["P4_has_time-span"], b_timestamp))
            g.add((b_timestamp, RDF.type, CIDOC["E52_Time-Span"]))
            g.add(
                (
                    b_timestamp,
                    CIDOC["P82a_begin_of_the_begin"],
                    Literal(death, datatype=XSD.date),
                )
            )
            g.add(
                (
                    b_timestamp,
                    CIDOC["P82b_end_of_the_end"],
                    Literal(death, datatype=XSD.date),
                )
            )
            g.add((b_timestamp, RDF.value, Literal(death, datatype=XSD.date)))
            try:
                place = x.xpath(".//tei:death/tei:placeName", namespaces=doc.nsmap)[0]
            except IndexError:
                place = None
            if place is not None:
                place_id = place.attrib["key"][1:]
                place_name = place.text
                place_uri = URIRef(f"{SK}{place_id}")
                g.add((b_uri, CIDOC["P7_took_place_at"], place_uri))
                g.add((place_uri, RDF.type, CIDOC["E53_Place"]))
g.serialize(f"{rdf_dir}/persons.ttl")
