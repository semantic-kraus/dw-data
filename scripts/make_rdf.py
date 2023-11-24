import os
from tqdm import tqdm
from acdh_cidoc_pyutils import (
    make_appellations,
    make_birth_death_entities,
    make_occupations,
    make_affiliations,
)
from acdh_cidoc_pyutils.namespaces import CIDOC, FRBROO
from acdh_tei_pyutils.tei import TeiReader
from rdflib import Graph, Namespace, URIRef, plugin, ConjunctiveGraph, Literal
from rdflib.namespace import RDF, DCTERMS, RDFS, VOID
from rdflib.store import Store
from utilities.utilities import (
    make_events,
    create_provenance_props,
    create_triple_from_node,
    create_object_literal_graph,
    create_e42_or_custom_class,
    PROV
)


domain = "https://sk.acdh.oeaw.ac.at/"
SK = Namespace(domain)
DW = Namespace("https://sk.acdh.oeaw.ac.at/project/dritte-walpurgisnacht")

store = plugin.get("Memory", Store)()
project_store = plugin.get("Memory", Store)()

project_uri = URIRef(f"{DW}")
g_prov = Graph(store=project_store, identifier=URIRef(f"{SK}provenance"))
g_prov.bind("dct", DCTERMS)
g_prov.bind("void", VOID)
g_prov.bind("sk", SK)
g_prov.bind("dw", DW)
g_prov.bind("cidoc", CIDOC)
g_prov.bind("frbroo", FRBROO)
g_prov.parse("./data/about.ttl")
g_prov.bind("prov", PROV)

g = Graph(identifier=project_uri, store=project_store)
g.bind("cidoc", CIDOC)
g.bind("frbroo", FRBROO)
g.bind("sk", SK)
g.bind("dw", DW)
g.bind("prov", PROV)
g.bind("dct", DCTERMS)
# adding constants
g.parse("./data/additions.ttl", format="ttl")

rdf_dir = "./rdf"

os.makedirs(rdf_dir, exist_ok=True)


def normalize_string(string: str) -> str:
    return " ".join(" ".join(string.split()).split())


doc = TeiReader("./data/indices/listperson.xml")
nsmap = doc.nsmap
items = doc.any_xpath(".//tei:person")
for x in tqdm(items, total=len(items)):
    xml_id = x.attrib["{http://www.w3.org/XML/1998/namespace}id"]
    item_id = f"{SK}{xml_id}"
    subj = URIRef(item_id)
    type_domain = f"{SK}types/"
    app_uri = URIRef(f"{subj}/identifier/{xml_id}")
    type_uri = URIRef(f"{type_domain}idno/xml-id")
    approx_uri = URIRef(f"{type_domain}date/approx")
    xml_id = x.attrib["{http://www.w3.org/XML/1998/namespace}id"]
    label_prefix = "Identifier: "
    label_value = normalize_string(f"{label_prefix}{xml_id}")
    lang = "en"
    g.add((approx_uri, RDF.type, CIDOC["E55_Type"]))
    g.add((approx_uri, RDFS.label, Literal("approx")))
    g.add((type_uri, RDF.type, CIDOC["E55_Type"]))
    g.add((subj, CIDOC["P1_is_identified_by"], app_uri))
    g.add((app_uri, RDF.type, CIDOC["E42_Identifier"]))
    g.add((app_uri, RDFS.label, Literal(label_value, lang=lang)))
    g.add((app_uri, RDF.value, Literal(normalize_string(xml_id))))
    g.add((app_uri, CIDOC["P2_has_type"], type_uri))
    g.add((subj, RDF.type, CIDOC["E21_Person"]))
    # try:
    #     label = x.xpath(
    #         './/tei:persName[@type="sk"][@subtype="pref"]/text()',
    #         namespaces=doc.nsmap
    #     )[0]
    # except IndexError:
    #     label = None
    try:
        obj = x.xpath('.//tei:persName[@type="sk"][@subtype="pref"]', namespaces=doc.nsmap)[0]
        gl1, label = create_object_literal_graph(
            node=obj,
            subject_uri=subj,
            l_prefix="",
            default_lang="und",
            predicate=RDFS.label
        )
        g += gl1
    except IndexError:
        label = None
    g += create_e42_or_custom_class(
        subj,
        x,
        default_lang="en",
        uri_prefix=type_domain,
        xpath=".//tei:idno",
        attribute="type",
        label_prefix=label_prefix,
        type_suffix="idno/URL"
    )
    g += create_e42_or_custom_class(
        subj,
        x,
        default_lang="en",
        uri_prefix=type_domain,
        xpath=".//tei:idno",
        attribute="subtype",
        label_prefix=label_prefix,
        type_suffix="idno/URL"
    )
    # g += make_e42_identifiers(
    #     subj, x, type_domain=f"{SK}types", default_lang="en", same_as=False, set_lang=True
    # )
    subject = f"{SK}{xml_id}/identifier/idno/1"
    label_url = "https://kraus1933.ace.oeaw.ac.at/Gesamt.xml?template=register_personen.html&letter="
    try:
        label_key = x.attrib["sortKey"][0]
    except KeyError:
        label_key = ""
    g.add((URIRef(subject), RDF.type, CIDOC["E42_Identifier"]))
    g.add((URIRef(subject), CIDOC["P1i_identifies"], URIRef(subj)))
    g.add((URIRef(subject), CIDOC["P2_has_type"], URIRef(f"{SK}types/idno/URL/dritte-walpurgisnacht")))
    g.add((URIRef(subject), RDF.value, Literal(f"{label_url}{label_key}#{xml_id}")))
    g.add((URIRef(subject), RDFS.label, Literal(f"Identifier: {label_url}{label_key}#{xml_id}", lang="en")))
    # g += make_appellations(subj, x, type_domain=f"{SK}types",
    #                        default_lang="und",
    #                        type_attribute="subtype",
    #                        special_xpath="[@type='sk']")
    # add appellations
    g += create_triple_from_node(
        node=x,
        subj=subj,
        subj_suffix="appellation",
        pred=CIDOC["P2_has_type"],
        sbj_class=CIDOC["E33_E41_Linguistic_Appellation"],
        obj_class=CIDOC["E55_Type"],
        obj_node_xpath="./tei:persName[@type='sk']",
        obj_node_value_xpath="./@subtype",
        obj_node_value_alt_xpath_or_str="pref",
        obj_prefix=f"{SK}types",
        default_lang="und",
        value_literal=True,
        identifier=CIDOC["P1_is_identified_by"],
        special_sorting=True,
    )
    # add additional type for appellations
    g += create_triple_from_node(
        node=x,
        subj=subj,
        subj_suffix="appellation",
        sbj_class=CIDOC["E33_E41_Linguistic_Appellation"],
        pred=CIDOC["P2_has_type"],
        default_lang="und",
        obj_class=CIDOC["E55_Type"],
        obj_node_xpath="./tei:persName",
        obj_node_value_xpath="./@sex",
        obj_node_value_alt_xpath_or_str="./parent::tei:person/tei:sex/@value",
        obj_prefix=f"{SK}types",
        skip_value="not-set",
        identifier=CIDOC["P1_is_identified_by"],
        special_sorting=True,
    )
    g += make_occupations(subj, x, default_lang="de", id_xpath="@n")[0]
    for y in x.xpath(".//tei:affiliation[@ref]", namespaces=nsmap):
        g += make_affiliations(
            subj,
            x,
            domain,
            person_label=f"{label}",
        )
    # create provenance properties
    g += create_provenance_props(
        subj,
        x,
        xpath="./tei:note[@type='source' and @subtype='publ']",
        domain=SK,
        attribute="n"
    )
    # event
    g += make_events(
        subj,
        x,
        type_domain=f"{SK}types",
        default_lang="en",
        domain=domain,
        date_node_xpath="./tei:desc/tei:date[@when]",
        place_id_xpath="./tei:desc/tei:placeName[@key]/@key",
        note_literal_xpath="./tei:note/text()",
        event_type_xpath="@type"
    )
    # birth
    try:
        birth = x.xpath(".//tei:birth[@when]/@when",
                        namespaces=doc.nsmap)[0]
    except IndexError:
        birth = None
    try:
        birth_type = x.xpath(".//tei:birth[@type]/@type",
                             namespaces=doc.nsmap)[0]
        birth_type_uri = URIRef(f"{SK}types/date/{birth_type}")
    except IndexError:
        birth_type_uri = None
    if birth:
        birth_g, b_uri, birth_timestamp = make_birth_death_entities(
            subj,
            x,
            domain=SK,
            type_uri=birth_type_uri,
            event_type="birth",
            verbose=True,
            default_prefix="Birth of",
            default_lang="en"
        )
        g += birth_g
    # death
    try:
        death = x.xpath(".//tei:death[@when]/@when",
                        namespaces=doc.nsmap)[0]
    except IndexError:
        death = None
    try:
        death_type = x.xpath(".//tei:death[@type]/@type",
                             namespaces=doc.nsmap)[0]
    except IndexError:
        death_type = None
    if death:
        death_g, b_uri, death_timestamp = make_birth_death_entities(
            subj,
            x,
            domain=SK,
            type_uri=birth_type_uri,
            event_type="death",
            verbose=True,
            default_prefix="Death of",
            default_lang="en",
        )
        g += death_g
doc = TeiReader("./data/indices/listplace.xml")
for x in doc.any_xpath(".//tei:place"):
    xml_id = x.attrib["{http://www.w3.org/XML/1998/namespace}id"]
    item_id = f"{SK}{xml_id}"
    subj = URIRef(item_id)
    g.add((subj, RDF.type, CIDOC["E53_Place"]))
    g += make_appellations(subj, x, type_domain=f"{SK}types/",
                           default_lang="und", type_attribute="type",
                           woke_type="pref")
    type_domain = f"{SK}types/"
    label_prefix = "Identifier: "
    g += create_e42_or_custom_class(
        subj,
        x,
        default_lang="en",
        uri_prefix=type_domain,
        xpath=".//tei:idno",
        attribute="type",
        label_prefix=label_prefix,
        type_suffix="idno/URL"
    )
    g += create_e42_or_custom_class(
        subj,
        x,
        default_lang="en",
        uri_prefix=type_domain,
        xpath=".//tei:idno",
        attribute="subtype",
        label_prefix=label_prefix,
        type_suffix="idno/URL"
    )
doc = TeiReader("./data/indices/listorg.xml")
for x in doc.any_xpath(".//tei:org"):
    xml_id = x.attrib["{http://www.w3.org/XML/1998/namespace}id"]
    item_id = f"{SK}{xml_id}"
    subj = URIRef(item_id)
    g.add((subj, RDF.type, CIDOC["E74_Group"]))
    app_uri = URIRef(f"{subj}/identifier/{xml_id}")
    g.add((subj, CIDOC["P1_is_identified_by"], app_uri))
    g += make_appellations(subj, x, type_domain=f"{SK}types/",
                           type_attribute="type", default_lang="und",
                           woke_type="pref")
    type_domain = f"{SK}types/"
    label_prefix = "Identifier: "
    g += create_e42_or_custom_class(
        subj,
        x,
        default_lang="en",
        uri_prefix=type_domain,
        xpath=".//tei:idno",
        attribute="type",
        label_prefix=label_prefix,
        type_suffix="idno/URL"
    )
    g += create_e42_or_custom_class(
        subj,
        x,
        default_lang="en",
        uri_prefix=type_domain,
        xpath=".//tei:idno",
        attribute="subtype",
        label_prefix=label_prefix,
        type_suffix="idno/URL"
    )
g_all = ConjunctiveGraph(store=project_store)
g_all.serialize(f"{rdf_dir}/data.trig", format="trig")
g_all.serialize(f"{rdf_dir}/data.ttl", format="ttl")
