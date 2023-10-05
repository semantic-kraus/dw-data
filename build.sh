rm -rf html
mkdir html
touch html/.nojekyll

python scripts/make_rdf.py
python scripts/owl_inverse_props.py
python scripts/make_index.py
cp rdf/*.ttl html/
cp rdf/*.trig html/