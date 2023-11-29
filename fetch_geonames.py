import requests
import lxml.etree as ET
from AcdhArcheAssets.uri_norm_rules import get_normalized_uri 
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm


file = "./data/indices/listplace.xml"

doc = TeiReader(file)
lookup = dict()
nsmap = doc.nsmap
for x in tqdm(doc.any_xpath(".//tei:place[./tei:idno[@type='pmb']]")):
    uri = x.xpath("./tei:idno[@type='pmb']", namespaces=nsmap)[0].text
    try:
        r = requests.get(uri)
    except:
        print(f"failed to data for {x}")
        continue
    data = r.json()
    uris = data["uris"]
    try:
        geonames = [x["uri"] for x in data["uris"] if "geonames" in x["uri"]][0]
    except:
        continue
    node = ET.Element("{http://www.tei-c.org/ns/1.0}indo")
    node.attrib["type"] = "geonames"
    node.text = get_normalized_uri(geonames)
    x.append(node)
doc.tree_to_file(file)


