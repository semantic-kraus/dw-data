from lxml.etree import Element
from rdflib import Graph, Literal, URIRef, RDF, RDFS, Namespace
from acdh_cidoc_pyutils.namespaces import CIDOC, NSMAP
from acdh_cidoc_pyutils import normalize_string, extract_begin_end, create_e52


PROV = Namespace("http://www.w3.org/ns/prov#")


def make_events(
    subj: URIRef,
    node: Element,
    type_domain: str,
    xpath: str | bool = ".//tei:event",
    default_prefix: str | bool = "Event:",
    default_lang: str | bool = "en",
    domain: Namespace | bool = "https://sk.acdh.oeaw.ac.at/",
    date_node_xpath: str | bool = "./tei:desc/tei:date[@when]",
    place_id_xpath: str | bool = "./tei:desc/tei:placeName[@key]/@key",
    note_literal_xpath: str | bool = "./tei:note/text()",
    event_type_xpath: str | bool = "@type",
) -> Graph():
    g = Graph()
    try:
        event = node.xpath(xpath, namespaces=NSMAP)
    except (SyntaxError, IndexError):
        event = None
    if isinstance(event, list):
        for i, x in enumerate(event):
            # create event type
            if event_type_xpath:
                event_type = normalize_string(
                    x.xpath(event_type_xpath, namespaces=NSMAP)[0]
                )
            else:
                event_type = normalize_string(x.xpath(".//tei:event[@type]/@type")[0])
            event_uri = URIRef(f"{subj}/event/{i}")
            g.add(
                (
                    event_uri,
                    CIDOC["P2_has_type"],
                    URIRef(f"{type_domain}/event/{event_type}"),
                )
            )
            # create note label
            if note_literal_xpath:
                note_label = normalize_string(
                    " ".join(x.xpath(note_literal_xpath, namespaces=NSMAP))
                )
            else:
                note_label = normalize_string(" ".join(x.xpath(".//text()")))
            if event_type == "burial":
                # create event as E5_type
                g.add((event_uri, RDF.type, CIDOC["E5_Event"]))
                event_label = normalize_string(f"{default_prefix} {note_label}")
                g.add((event_uri, CIDOC["P12_occurred_in_the_presence_of"], subj))
            elif event_type == "missing" or "decl-dead":
                g.add((event_uri, RDF.type, CIDOC["E13_Attribute_Assignment"]))
                event_label = normalize_string(note_label)
                g.add((event_uri, CIDOC["P140_assigned_attribute_to"], subj))
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


def create_provenance_props(
    subj: URIRef,
    node: Element,
    xpath: str | bool = False,
    domain: URIRef = URIRef("https://sk.acdh.oeaw.ac.at/"),
    attribute: str | bool = False
) -> Graph():
    g = Graph()
    if xpath:
        try:
            node = node.xpath(xpath, namespaces=NSMAP)
        except (SyntaxError, IndexError):
            node = None
        if isinstance(node, list):
            for i, n in enumerate(node):
                try:
                    object_uri_id = n.attrib["n"]
                except KeyError:
                    object_uri_id = None
                if object_uri_id is not None:
                    object_uri = URIRef(f"{domain}{object_uri_id}")
                    g.add((subj, PROV["wasDerivedFrom"], object_uri))
    else:
        try:
            object_uri_id = node.attrib[attribute]
        except KeyError:
            object_uri_id = None
        if object_uri_id is not None:
            object_uri = URIRef(f"{domain}{object_uri_id}")
            g.add((subj, PROV["wasDerivedFrom"], object_uri))
    return g
