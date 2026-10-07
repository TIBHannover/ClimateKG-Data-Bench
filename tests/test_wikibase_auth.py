import os
import sys
from pathlib import Path

from SPARQLWrapper import BASIC

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from sparql_queries.wikibase_auth import DEFAULT_SPARQL_ENDPOINT, build_sparql_client


def test_default_sparql_endpoint_uses_query_proxy_route():
    assert DEFAULT_SPARQL_ENDPOINT == "https://climatekg.tibwiki.io/query/proxy/sparql"


def test_build_sparql_client_uses_basic_auth_when_credentials_are_present(monkeypatch):
    monkeypatch.setenv("CLIMATEKG_SPARQL_USERNAME", "ckg")
    monkeypatch.setenv("CLIMATEKG_SPARQL_PASSWORD", "fairdata")

    client = build_sparql_client("https://example.test/sparql")

    assert client.endpoint == "https://example.test/sparql"
    assert client.http_auth == BASIC
    assert client.user == "ckg"
    assert client.passwd == "fairdata"


def test_build_sparql_client_uses_default_climatekg_credentials_when_endpoint_is_climatekg(monkeypatch):
    monkeypatch.delenv("CLIMATEKG_SPARQL_USERNAME", raising=False)
    monkeypatch.delenv("CLIMATEKG_SPARQL_PASSWORD", raising=False)

    client = build_sparql_client("https://climatekg.tibwiki.io/query/proxy/sparql")

    assert client.endpoint == "https://climatekg.tibwiki.io/query/proxy/sparql"
    assert client.http_auth == BASIC
    assert client.user == "ckg"
    assert client.passwd == "fairdata"


def test_build_sparql_client_without_credentials_leaves_auth_disabled(monkeypatch):
    monkeypatch.delenv("CLIMATEKG_SPARQL_USERNAME", raising=False)
    monkeypatch.delenv("CLIMATEKG_SPARQL_PASSWORD", raising=False)

    client = build_sparql_client("https://example.test/sparql")

    assert client.endpoint == "https://example.test/sparql"
    assert client.user is None
    assert client.passwd is None
