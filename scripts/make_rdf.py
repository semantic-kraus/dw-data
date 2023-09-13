import os
from tqdm import tqdm
from acdh_cidoc_pyutils import (
    make_appellations,
    make_e42_identifiers,
    make_birth_death_entities,
    make_occupations,
    make_affiliations,
)
from acdh_cidoc_pyutils.namespaces import CIDOC, FRBROO
from acdh_tei_pyutils.tei import TeiReader
from rdflib import Graph, Namespace, URIRef, plugin, ConjunctiveGraph
from rdflib.namespace import RDF, VOID, DCTERMS
from rdflib.store import Store
from utils import make_events


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

g = Graph(identifier=project_uri, store=project_store)
g.bind("cidoc", CIDOC)
g.bind("frbroo", FRBROO)
g.bind("sk", SK)
g.bind("dw", DW)


rdf_dir = "./rdf"

os.makedirs(rdf_dir, exist_ok=True)

doc = TeiReader("./data/indices/listperson.xml")
nsmap = doc.nsmap
items = doc.any_xpath(".//tei:person")
for x in tqdm(items, total=len(items)):
    xml_id = x.attrib["{http://www.w3.org/XML/1998/namespace}id"]
    item_id = f"{SK}{xml_id}"
    subj = URIRef(item_id)
    g.add((subj, RDF.type, CIDOC["E21_Person"]))
    try:
        label = x.xpath(
            './/tei:persName[@type="sk"][@subtype="pref"]/text()',
            namespaces=doc.nsmap
        )[0]
    except IndexError:
        label = None
    g += make_e42_identifiers(
        subj, x, type_domain=f"{SK}types", default_lang="en", same_as=False, set_lang=True
    )
    g += make_appellations(subj, x, type_domain=f"{SK}types",
                           default_lang="und",
                           type_attribute="subtype",
                           special_xpath="[@type='sk']")
    g += make_occupations(subj, x, default_lang="de", id_xpath="@n")[0]
    for y in x.xpath(".//tei:affiliation[@ref]", namespaces=nsmap):
        g += make_affiliations(
            subj,
            x,
            domain,
            person_label=f"{label}",
        )
    # event
    g += make_events(
        subj,
        x,
        type_domain=f"{SK}types",
        default_lang="und",
        domain=domain)
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
            verbose=True
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
            default_prefix="Tod von"
        )
        g += death_g
doc = TeiReader("./data/indices/listplace.xml")
for x in doc.any_xpath(".//tei:place"):
    xml_id = x.attrib["{http://www.w3.org/XML/1998/namespace}id"]
    item_id = f"{SK}{xml_id}"
    subj = URIRef(item_id)
    g.add((subj, RDF.type, CIDOC["E53_Place"]))
    g += make_appellations(subj, x, type_domain=f"{SK}types/",
                           default_lang="und")
    g += make_e42_identifiers(subj, x, type_domain=f"{SK}types",
                              default_lang="en", set_lang=True)
doc = TeiReader("./data/indices/listorg.xml")
for x in doc.any_xpath(".//tei:org"):
    xml_id = x.attrib["{http://www.w3.org/XML/1998/namespace}id"]
    item_id = f"{SK}{xml_id}"
    subj = URIRef(item_id)
    g.add((subj, RDF.type, CIDOC["E74_Group"]))
    g += make_appellations(subj, x, type_domain=f"{SK}types/",
                           default_lang="und")
    g += make_e42_identifiers(subj, x, type_domain=f"{SK}types",
                              default_lang="en", set_lang=True)
g_all = ConjunctiveGraph(store=project_store)
g_all.serialize(f"{rdf_dir}/data.trig", format="trig")
g_all.serialize(f"{rdf_dir}/data.ttl", format="ttl")
