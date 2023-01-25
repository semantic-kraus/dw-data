rm -rf html
mkdir html
cp README.md ./html/index.md
touch html/.nojekyll

python scripts/make_rdf.py
python scripts/make_index.py
