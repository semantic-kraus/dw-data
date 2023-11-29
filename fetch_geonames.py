import lxml.etree as ET
from AcdhArcheAssets.uri_norm_rules import get_normalized_uri, get_norm_id
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm


file = "./data/indices/listplace.xml"
tei_uri = "https://pmb.acdh.oeaw.ac.at/apis/entities/tei/place/{}"


doc = TeiReader(file)
lookup = dict()
nsmap = doc.nsmap
no_geonames = []
failed = []
for x in tqdm(
    doc.any_xpath(
        ".//tei:place[./tei:idno[@type='pmb'] and not(./tei:idno[@type='geonames'])]"
    )
):
    uri = x.xpath("./tei:idno[@type='pmb']", namespaces=nsmap)[0].text
    pmb_id = get_norm_id(uri)
    pmb_uri = tei_uri.format(pmb_id)
    try:
        place_doc = TeiReader(pmb_uri)
    except Exception as e:
        failed.append([x, e])
    try:
        geonames = place_doc.any_xpath(".//idno[@subtype='geonames']")[0]
    except IndexError:
        no_geonames.append(uri)
        continue
    node = ET.Element("{http://www.tei-c.org/ns/1.0}idno")
    node.attrib["type"] = "geonames"
    node.text = get_normalized_uri(geonames.text)
    x.append(node)
doc.tree_to_file(file)

print("NO geonames")
print(no_geonames)

print("#####")
print("failed")
print(failed)