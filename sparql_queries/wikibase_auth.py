import os

from SPARQLWrapper import BASIC, SPARQLWrapper

DEFAULT_WIKIBASE_URL = os.getenv("CLIMATEKG_WIKIBASE_URL", "https://climatekg.tibwiki.io")
DEFAULT_SPARQL_ENDPOINT = os.getenv(
    "CLIMATEKG_SPARQL_ENDPOINT",
    f"{DEFAULT_WIKIBASE_URL}/query/proxy/sparql",
)


def get_sparql_credentials(username=None, password=None, endpoint=None):
    """Return the current credentials for a Wikibase SPARQL endpoint.

    The live ClimateKG instance is protected by HTTP basic auth and uses the
    project-default credentials when no explicit env vars are provided.
    """
    endpoint_url = endpoint or DEFAULT_SPARQL_ENDPOINT
    username = username or os.getenv("CLIMATEKG_SPARQL_USERNAME")
    password = password or os.getenv("CLIMATEKG_SPARQL_PASSWORD")

    if not username and not password and endpoint_url.startswith("https://climatekg.tibwiki.io"):
        username = "ckg"
        password = "fairdata"

    return username, password


def build_sparql_client(endpoint=None, username=None, password=None):
    """Create a SPARQLWrapper configured with HTTP basic auth when credentials are available."""
    endpoint_url = endpoint or DEFAULT_SPARQL_ENDPOINT
    client = SPARQLWrapper(endpoint_url)
    client.setTimeout(60)

    auth_user, auth_password = get_sparql_credentials(username, password, endpoint_url)
    if auth_user and auth_password:
        client.setHTTPAuth(BASIC)
        client.setCredentials(auth_user, auth_password)

    return client
