import json

import requests
from azure.identity import DefaultAzureCredential
from azure.mgmt.resourcegraph import ResourceGraphClient
from azure.mgmt.resourcegraph.models import QueryRequest

from shared.config import load_settings


ARM_SCOPE = "https://management.azure.com/.default"
GRAPH_SCOPE = "https://graph.microsoft.com/.default"


def get_credential() -> DefaultAzureCredential:
    return DefaultAzureCredential()


def get_resource_graph_client() -> ResourceGraphClient:
    settings = load_settings()
    return ResourceGraphClient(get_credential(), settings.subscription_id)


def query_resource_graph(query: str, subscriptions: list[str]) -> list[dict]:
    client = get_resource_graph_client()
    request = QueryRequest(subscriptions=subscriptions, query=query)
    response = client.resources(request)
    return json.loads(response.data.serialize()) if hasattr(response.data, "serialize") else response.data


def get_arm_token() -> str:
    return get_credential().get_token(ARM_SCOPE).token


def get_graph_token() -> str:
    return get_credential().get_token(GRAPH_SCOPE).token


def arm_get(url: str) -> dict:
    response = requests.get(
        url,
        headers={"Authorization": f"Bearer {get_arm_token()}"},
        timeout=60,
    )
    response.raise_for_status()
    return response.json()


def arm_post(url: str, payload: dict) -> dict:
    response = requests.post(
        url,
        headers={
            "Authorization": f"Bearer {get_arm_token()}",
            "Content-Type": "application/json",
        },
        json=payload,
        timeout=60,
    )
    response.raise_for_status()
    return response.json()

