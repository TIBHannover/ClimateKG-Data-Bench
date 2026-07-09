"""
mediawiki-word-count.py

Counts the total number of words across all MediaWiki pages on a
ClimateKG Wikibase instance using the MediaWiki Action API.

No authentication required — all page content is publicly readable.

Usage:
    python scripts/mediawiki-word-count.py [--env local|dev|test|prod]
    python scripts/mediawiki-word-count.py --env prod
    python scripts/mediawiki-word-count.py --env prod --namespace 0
    python scripts/mediawiki-word-count.py --env prod --verbose

Namespaces (MediaWiki):
    0  = Main / article pages
    4  = Project (e.g. ClimateKG:)
   -1  = all namespaces (default)
"""

import argparse
import re
import sys
import time

import requests

# ---------------------------------------------------------------------------
# Per-environment configuration
# ---------------------------------------------------------------------------

ENV_CONFIG = {
    "local": {"api_url": "http://localhost:8080/w/api.php"},
    "dev":   {"api_url": "https://dev-climatekg.semanticclimate.org/w/api.php"},
    "test":  {"api_url": "https://test-climatekg.semanticclimate.org/w/api.php"},
    "prod":  {"api_url": "https://prod-climatekg.semanticclimate.org/w/api.php"},
}

BATCH_SIZE = 10          # pages per API request — kept small due to large page sizes
REQUEST_DELAY = 0.25     # seconds between requests (be polite)


# ---------------------------------------------------------------------------
# MediaWiki markup stripper
# ---------------------------------------------------------------------------

# Order matters: strip inner constructs before outer ones.
_STRIP_PATTERNS = [
    (re.compile(r"<ref[^>]*/>\s*"),             ""),          # self-closing <ref/>
    (re.compile(r"<ref[^>]*>.*?</ref>",
                re.DOTALL | re.IGNORECASE),     ""),          # <ref>...</ref>
    (re.compile(r"<!--.*?-->", re.DOTALL),      ""),          # HTML comments
    (re.compile(r"\{\{[^{}]*\}\}"),             ""),          # {{templates}} (single-level)
    (re.compile(r"\{\{[^{}]*\}\}"),             ""),          # second pass for nested
    (re.compile(r"\{\|.*?\|\}", re.DOTALL),     ""),          # {| wiki tables |}
    (re.compile(r"\[\[File:[^\]]*\]\]",
                re.IGNORECASE),                 ""),          # [[File:...]]
    (re.compile(r"\[\[Image:[^\]]*\]\]",
                re.IGNORECASE),                 ""),          # [[Image:...]]
    (re.compile(r"\[\[(?:[^|\]]+\|)?([^\]]+)\]\]"), r"\1"),  # [[link|display]] -> display
    (re.compile(r"\[https?://\S+\s+([^\]]+)\]"),    r"\1"),  # [URL display text] -> text
    (re.compile(r"\[https?://\S+\]"),           ""),          # bare [URL]
    (re.compile(r"<[^>]+>"),                    " "),         # remaining HTML tags
    (re.compile(r"={2,}([^=]+)={2,}"),          r"\1"),       # ==Headings==
    (re.compile(r"'{2,}"),                      ""),          # bold/italic ''marks''
    (re.compile(r"^\s*[|!].*$", re.MULTILINE), ""),          # table rows/headers
    (re.compile(r"^\s*[*#:;]+\s*", re.MULTILINE), " "),      # list/indent markers
]


def strip_wiki_markup(wikitext: str) -> str:
    text = wikitext
    for pattern, repl in _STRIP_PATTERNS:
        text = pattern.sub(repl, text)
    return text


def count_words(text: str) -> int:
    """Split on whitespace and count non-empty tokens."""
    return len(text.split())


# ---------------------------------------------------------------------------
# API helpers
# ---------------------------------------------------------------------------

def get_all_page_titles(session: requests.Session, api_url: str, namespace: int) -> list[dict]:
    """
    Return a list of {pageid, title} dicts for all pages in the given namespace.
    Pass namespace=-1 to retrieve ALL namespaces.
    """
    pages = []
    params = {
        "action":   "query",
        "list":     "allpages",
        "aplimit":  "max",       # up to 500
        "format":   "json",
        "formatversion": "2",
    }
    if namespace != -1:
        params["apnamespace"] = str(namespace)

    while True:
        resp = session.get(api_url, params=params, timeout=30)
        resp.raise_for_status()
        data = resp.json()

        batch = data.get("query", {}).get("allpages", [])
        pages.extend(batch)

        cont = data.get("continue", {}).get("apcontinue")
        if not cont:
            break
        params["apcontinue"] = cont
        time.sleep(REQUEST_DELAY)

    return pages


def fetch_page_content_batch(session: requests.Session, api_url: str,
                              titles: list[str]) -> dict[str, str]:
    """
    Fetch current wikitext for up to BATCH_SIZE page titles.
    Follows 'continue' tokens so that large responses don't silently
    drop pages that exceed the server's response-size limit.
    Returns {title: wikitext} mapping.
    """
    base_params = {
        "action":   "query",
        "prop":     "revisions",
        "titles":   "|".join(titles),
        "rvprop":   "content",
        "rvslots":  "main",
        "format":   "json",
        "formatversion": "2",
    }

    result = {}
    params = dict(base_params)

    while True:
        resp = session.get(api_url, params=params, timeout=60)
        resp.raise_for_status()
        data = resp.json()

        for page in data.get("query", {}).get("pages", []):
            title = page.get("title", "")
            revisions = page.get("revisions", [])
            if not revisions:
                continue
            content = revisions[0].get("slots", {}).get("main", {}).get("content", "")
            if content:
                result[title] = content

        # Follow continue token if the server split the response
        cont = data.get("continue", {})
        if not cont:
            break
        params = {**base_params, **cont}
        time.sleep(REQUEST_DELAY)

    return result


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description="Count total words across all MediaWiki pages via the Action API."
    )
    parser.add_argument(
        "--env", default="prod",
        choices=list(ENV_CONFIG.keys()),
        help="Target environment (default: prod)",
    )
    parser.add_argument(
        "--namespace", type=int, default=-1,
        metavar="NS",
        help="MediaWiki namespace number to restrict to (default: -1 = all). "
             "Use 0 for main/article pages only.",
    )
    parser.add_argument(
        "--verbose", "-v", action="store_true",
        help="Print per-page word counts",
    )
    args = parser.parse_args()

    api_url = ENV_CONFIG[args.env]["api_url"]
    ns_label = f"namespace {args.namespace}" if args.namespace != -1 else "all namespaces"
    print(f"Environment : {args.env}")
    print(f"API URL     : {api_url}")
    print(f"Namespace   : {ns_label}")
    print()

    session = requests.Session()
    session.headers.update({"User-Agent": "ClimateKG-WordCount/1.0 (research tool)"})

    # Step 1: get all page titles
    print("Fetching page list...", end="", flush=True)
    pages = get_all_page_titles(session, api_url, args.namespace)
    print(f" {len(pages)} pages found.")

    if not pages:
        print("No pages found. Check environment and namespace settings.")
        sys.exit(0)

    # Step 2: fetch content in batches and count words
    total_words = 0
    page_results = []

    for i in range(0, len(pages), BATCH_SIZE):
        batch = pages[i : i + BATCH_SIZE]
        titles = [p["title"] for p in batch]

        print(f"  Fetching pages {i+1}–{min(i+BATCH_SIZE, len(pages))} of {len(pages)}...",
              end="", flush=True)

        content_map = fetch_page_content_batch(session, api_url, titles)

        batch_words = 0
        for title, wikitext in content_map.items():
            plain = strip_wiki_markup(wikitext)
            wc = count_words(plain)
            batch_words += wc
            page_results.append((title, wc))

        total_words += batch_words
        print(f" {batch_words:,} words in this batch.")
        time.sleep(REQUEST_DELAY)

    # Step 3: report
    print()
    if args.verbose:
        print(f"{'Title':<60} {'Words':>8}")
        print("-" * 70)
        for title, wc in sorted(page_results, key=lambda x: x[1], reverse=True):
            print(f"{title:<60} {wc:>8,}")
        print("-" * 70)

    print(f"Pages with content : {len(page_results):,}")
    print(f"Pages without content (redirects/empty) : {len(pages) - len(page_results):,}")
    print(f"TOTAL WORD COUNT   : {total_words:,}")


if __name__ == "__main__":
    main()
