import os
from tqdm import tqdm
from acdh_cidoc_pyutils import (
    make_appelations,
    make_ed42_identifiers,
    make_birth_death_entities,
    make_occupations,
    make_affiliations,
)
from acdh_cidoc_pyutils.namespaces import CIDOC
from acdh_tei_pyutils.tei import TeiReader
from rdflib import Graph, Namespace, URIRef
from rdflib.namespace import RDF


domain = "https://sk.acdh.oeaw.ac.at/"
SK = Namespace(domain)

rdf_dir = "./rdf"

os.makedirs(rdf_dir, exist_ok=True)

g = Graph()
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
            './/tei:persName[@type="sk"][@subtype="pref"]/text()', namespaces=doc.nsmap
        )[0]
    except IndexError:
        label = None
    g += make_ed42_identifiers(subj, x, type_domain=f"{SK}types", default_lang="und")
    g += make_appelations(subj, x, type_domain=f"{SK}types", default_lang="und")
    g += make_occupations(subj, x, default_lang="und", id_xpath="@n")[0]
    for y in x.xpath(".//tei:affiliation[@ref]", namespaces=nsmap):
        g += make_affiliations(
            subj,
            x,
            domain,
            person_label=f"{label}",
        )
    # birth
    try:
        birth = x.xpath(".//tei:birth[@when]/@when", namespaces=doc.nsmap)[0]
    except IndexError:
        birth = None
    if birth:
        birth_g, b_uri, birth_timestamp = make_birth_death_entities(
            subj, x, domain=SK, event_type="birth", verbose=True
        )
        g += birth_g
    # death
    try:
        death = x.xpath(".//tei:death[@when]/@when", namespaces=doc.nsmap)[0]
    except IndexError:
        death = None
    if death:
        death_g, b_uri, death_timestamp = make_birth_death_entities(
            subj,
            x,
            domain=SK,
            event_type="death",
            verbose=True,
            default_prefix="Tod von",
        )
        g += death_g
doc = TeiReader("./data/indices/listplace.xml")
for x in doc.any_xpath(".//tei:place"):
    xml_id = x.attrib["{http://www.w3.org/XML/1998/namespace}id"]
    item_id = f"{SK}{xml_id}"
    subj = URIRef(item_id)
    g.add((subj, RDF.type, CIDOC["E53_Place"]))
    g += make_appelations(subj, x, type_domain=f"{SK}types/", default_lang="und")
    g += make_ed42_identifiers(subj, x, type_domain=f"{SK}types", default_lang="und")
doc = TeiReader("./data/indices/listorg.xml")
for x in doc.any_xpath(".//tei:org"):
    xml_id = x.attrib["{http://www.w3.org/XML/1998/namespace}id"]
    item_id = f"{SK}{xml_id}"
    subj = URIRef(item_id)
    g.add((subj, RDF.type, CIDOC["E74_Group"]))
    g += make_appelations(subj, x, type_domain=f"{SK}types/", default_lang="und")
    g += make_ed42_identifiers(subj, x, type_domain=f"{SK}types", default_lang="und")
g.serialize(f"{rdf_dir}/data.ttl")
