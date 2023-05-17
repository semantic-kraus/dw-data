import requests
import pandas as pd
from io import BytesIO
from acdh_tei_pyutils.tei import TeiReader

print("runs some search and replace things over listperson.xml")


def gsheet_to_df(sheet_id):
    GDRIVE_BASE_URL = "https://docs.google.com/spreadsheet/ccc?key="
    url = f"{GDRIVE_BASE_URL}{sheet_id}&output=csv"
    r = requests.get(url)
    print(r.status_code)
    data = r.content
    df = pd.read_csv(BytesIO(data))
    return df


df = gsheet_to_df("1wpoZJPKj4CjEuwyVYahGVST9tPKR1aohAJBq4w49Kq0")
print(df)

with open("./data/indices/listperson.xml", "r") as f:
    data = f.read()

for i, row in df.iterrows():
    search_term = f'<note type="source" subtype="publ">{row["abbr"].strip()}</note>'
    replace_term = f'<note type="source" subtype="publ">{row["expan"].strip()}</note>'
    data = data.replace(search_term, replace_term)

data = data.replace("&", "&amp;")
doc = TeiReader(data)

doc.tree_to_file("./data/indices/listperson.xml")
