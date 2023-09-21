from acdh_cidoc_pyutils.namespaces import CIDOC, FRBROO
from rdflib import Graph, Namespace, URIRef, plugin, ConjunctiveGraph
from rdflib.namespace import VOID, DCTERMS
from rdflib.store import Store


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

try:
    g.parse("./html/texts.ttl")
except Exception as e:
    print(e)

g_all = ConjunctiveGraph(store=project_store)
g_all.serialize("./html/texts.trig", format="trig")
