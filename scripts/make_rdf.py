import os
from slugify import slugify
from acdh_cidoc_pyutils import make_uri, date_to_literal
from acdh_cidoc_pyutils.namespaces import CIDOC, FRBROO
from acdh_tei_pyutils.tei import TeiReader
from rdflib import Graph, Namespace, URIRef, Literal
from rdflib.namespace import RDF, RDFS, OWL, XSD


domain = "https://sk.acdh.oeaw.ac.at/"
SK = Namespace(domain)

rdf_dir = "./rdf"

os.makedirs(rdf_dir, exist_ok=True)

g = Graph()
doc = TeiReader("./data/indices/listperson.xml")
nsmap = doc.nsmap

for x in doc.any_xpath(".//tei:person"):
    xml_id = x.attrib["{http://www.w3.org/XML/1998/namespace}id"]
    item_id = f"{SK}{xml_id}"
    subj = URIRef(item_id)
    g.add((subj, RDF.type, CIDOC["E21_Person"]))
    try:
        gnd = x.xpath('.//tei:idno[@type="GND"]/text()', namespaces=nsmap)[0]
    except IndexError:
        gnd = None
    if gnd:
        gnd_uri = URIRef(f"https://https://d-nb.info/gnd/{gnd}")
        g.add((subj, OWL["sameAs"], gnd_uri))
        g.add((gnd_uri, RDF.type, CIDOC["E42_Identifier"]))
    for y in x.xpath(".//tei:occupation", namespaces=nsmap):
        label = y.text
        uri = URIRef(f"{SK}{slugify(label)}")
        g.add((subj, CIDOC["P14i_performed"], uri))
        g.add((uri, RDF.type, FRBROO["F51"]))
        g.add((uri, RDF.value, Literal(label, lang="de")))
        # ToDo:
        # timespan_uri; timespan_uri, p82a und p82b
        # if only year (in case of @when use XSD.gYear)
    for y in x.xpath(".//tei:affiliation[@ref]", namespaces=nsmap):
        occ_id = y.attrib["ref"][1:]
        uri = URIRef(f"{SK}{occ_id}")
        join_uri = make_uri(domain=domain)
        g.add((join_uri, RDF.type, CIDOC["E85_Joining"]))
        g.add((join_uri, CIDOC["P143_joined"], subj))
        g.add((join_uri, CIDOC["P144_joined_with"], uri))
        try:
            date_str = y.attrib["notBefore"]
        except KeyError:
            continue
        join_timestamp = make_uri(domain=domain)
        g.add((join_timestamp, RDF.type, CIDOC["E52_Time-Span"]))
        g.add((join_uri, CIDOC["P4_has_time-span"], join_timestamp))
        g.add(
            (
                join_timestamp,
                CIDOC["P82a_begin_of_the_begin"],
                date_to_literal(date_str),
            )
        )
        g.add((join_timestamp, CIDOC["P82b_end_of_the_end"], date_to_literal(date_str)))
        # ToDo:
        # E85 (Joining Eent) -> P4 -> E52; E52 P82a/P82b (use notBefore)
        # E86 (Leaving Event) -> E52 P82a/P82b (use notAfter)

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
                date_to_literal(birth),
            )
        )
        g.add(
            (
                b_timestamp,
                CIDOC["P82b_end_of_the_end"],
                date_to_literal(birth),
            )
        )
        g.add((b_timestamp, RDF.value, date_to_literal(birth)))
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
                g.add((b_uri, RDFS.label, Literal(f"Tod von {label}", lang="de")))
            g.add((b_uri, CIDOC["P100_was_death_of"], subj))
            g.add((b_uri, CIDOC["P4_has_time-span"], b_timestamp))
            g.add((b_timestamp, RDF.type, CIDOC["E52_Time-Span"]))
            g.add(
                (
                    b_timestamp,
                    CIDOC["P82a_begin_of_the_begin"],
                    date_to_literal(death),
                )
            )
            g.add(
                (
                    b_timestamp,
                    CIDOC["P82b_end_of_the_end"],
                    date_to_literal(death),
                )
            )
            g.add((b_timestamp, RDF.value, date_to_literal(death)))
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
doc = TeiReader("./data/indices/listplace.xml")
for x in doc.any_xpath(".//tei:place"):
    xml_id = x.attrib["{http://www.w3.org/XML/1998/namespace}id"]
    item_id = f"{SK}{xml_id}"
    subj = URIRef(item_id)
    g.add((subj, RDF.type, CIDOC["E53_Place"]))
    try:
        pmb = x.xpath('.//tei:idno[@type="pmb"]/text()', namespaces=nsmap)[0]
    except IndexError:
        pmb = None
    if pmb:
        pmb_uri = URIRef(pmb)
        g.add((subj, OWL["sameAs"], pmb_uri))
        g.add((pmb_uri, RDF.type, CIDOC["E42_Identifier"]))
doc = TeiReader("./data/indices/listorg.xml")
for x in doc.any_xpath(".//tei:org"):
    xml_id = x.attrib["{http://www.w3.org/XML/1998/namespace}id"]
    item_id = f"{SK}{xml_id}"
    subj = URIRef(item_id)
    g.add((subj, RDF.type, CIDOC["E74_Group"]))
    for y in x.xpath('.//tei:orgName[@type="full"]', namespaces=nsmap):
        g.add((subj, RDFS.label, Literal(y.text, lang="de")))
    for y in x.xpath(".//tei:idno[@type]/text()", namespaces=nsmap):
        g.add((subj, OWL["sameAs"], URIRef(y)))
        g.add((pmb_uri, RDF.type, CIDOC["E42_Identifier"]))
g.serialize(f"{rdf_dir}/data.ttl")
