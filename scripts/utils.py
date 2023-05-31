from lxml.etree import Element
from rdflib import Graph, Literal, URIRef, RDF, RDFS
from acdh_cidoc_pyutils.namespaces import CIDOC, NSMAP
from acdh_cidoc_pyutils import normalize_string, extract_begin_end, create_e52


def make_events(
    subj: URIRef,
    node: Element,
    type_domain: str,
    default_prefix="Event:",
    default_lang="de",
    domain="https://sk.acdh.oeaw.ac.at/",
):
    g = Graph()
    date_node_xpath = "./tei:desc/tei:date[@when]"
    place_id_xpath = "./tei:desc/tei:placeName[@key]/@key"
    note_literal_xpath = "./tei:note/text()"
    event_type_xpath = "@type"
    for i, x in enumerate(node.xpath(".//tei:event", namespaces=NSMAP)):
        # create event as E5_type
        event_uri = URIRef(f"{subj}/event/{i}")
        g.add((event_uri, RDF.type, CIDOC["E5_Event"]))
        # create note label
        if note_literal_xpath == "":
            note_label = normalize_string(" ".join(x.xpath(".//text()")))
        else:
            note_label = normalize_string(
                " ".join(x.xpath(note_literal_xpath, namespaces=NSMAP))
            )
        event_label = normalize_string(f"{default_prefix} {note_label}")
        g.add((event_uri, RDFS.label, Literal(event_label, lang=default_lang)))
        # create event time-span
        g.add((event_uri, CIDOC["P4_has_time-span"], URIRef(f"{event_uri}/time-span")))
        # create event placeName
        if place_id_xpath == "":
            place_id = x.xpath(".//tei:placeName[@key]/@key", namespaces=NSMAP)
        else:
            place_id = x.xpath(place_id_xpath, namespaces=NSMAP)
        if place_id:
            g.add(
                (
                    event_uri,
                    CIDOC["P7_took_place_at"],
                    URIRef(f"{domain}{place_id[0].split('#')[-1]}"),
                )
            )
        # create event type
        if event_type_xpath == "":
            event_type = normalize_string(x.xpath(".//tei:event[@type]/@type")[0])
        else:
            event_type = normalize_string(
                x.xpath(event_type_xpath, namespaces=NSMAP)[0]
            )
        g.add(
            (
                event_uri,
                CIDOC["P2_has_type"],
                URIRef(f"{type_domain}/event/{event_type}"),
            )
        )
        if date_node_xpath == "":
            date_node = x.xpath(".//tei:desc/tei:date[@when]")[0]
        else:
            date_node = x.xpath(date_node_xpath, namespaces=NSMAP)[0]
        begin, end = extract_begin_end(date_node)
        if begin:
            ts_uri = URIRef(f"{event_uri}/time-span")
            g.add((ts_uri, RDF.type, CIDOC["E52_Time-Span"]))
            g += create_e52(ts_uri, begin_of_begin=begin, end_of_end=begin)
        if end:
            ts_uri = URIRef(f"{event_uri}/time-span")
            label = date_node.attrib["when"]
            g.add((ts_uri, RDFS.label, Literal(label, lang=default_lang)))
            g += create_e52(ts_uri, begin_of_begin=end, end_of_end=end)
    return g
