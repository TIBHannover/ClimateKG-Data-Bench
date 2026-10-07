import os
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from sparql_queries.wikibase_auth import build_sparql_client


def test_build_sparql_client_uses_basic_auth_when_credentials_are_present(monkeypatch):
    monkeypatch.setenv("CLIMATEKG_SPARQL_USERNAME", "ckg")
    monkeypatch.setenv("CLIMATEKG_SPARQL_PASSWORD", "fairdata")

    client = build_sparql_client("https://example.test/sparql")

    assert client.endpoint == "https://example.test/sparql"
    assert client.auth is not None
    assert client.username == "ckg"
    assert client.password == "fairdata"


def test_build_sparql_client_without_credentials_leaves_auth_disabled(monkeypatch):
    monkeypatch.delenv("CLIMATEKG_SPARQL_USERNAME", raising=False)
    monkeypatch.delenv("CLIMATEKG_SPARQL_PASSWORD", raising=False)

    client = build_sparql_client("https://example.test/sparql")

    assert client.endpoint == "https://example.test/sparql"
    assert client.auth is None
