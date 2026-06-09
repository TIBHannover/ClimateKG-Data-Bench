import csv

with open('research_data/data-xml-dtd/corpus-ar6.csv', encoding='utf-8') as f:
    r = csv.DictReader(f)
    rows = list(r)

# normalize keys
def col(row, name):
    for k in row:
        if name in k:
            return row[k]
    return ''

keywords = ['building', 'urban', 'architect', 'city', 'cities', 'settlement', 'infrastructure']
matches = []
for row in rows:
    title = col(row, 'TITLE').lower()
    tags = col(row, 'TAGLIST').lower()
    if any(k in title or k in tags for k in keywords):
        matches.append({
            'title': col(row, 'TITLE'),
            'wiki_url': col(row, 'WIKI').strip(),
            'source_url': col(row, 'SOURCE').strip(),
            'doi': col(row, 'DOI').strip(),
            'tags': col(row, 'TAGLIST').strip(),
        })

print(f'Found {len(matches)} chapters/entries:')
for m in matches:
    print(m['title'], '|', m['wiki_url'])
