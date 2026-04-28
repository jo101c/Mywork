import json
from datetime import datetime, timedelta, timezone

from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobSasPermissions, BlobServiceClient, generate_blob_sas

from shared.config import load_settings


def _service_client() -> BlobServiceClient:
    settings = load_settings()
    account_url = f"https://{settings.storage_account_name}.blob.core.windows.net"
    return BlobServiceClient(account_url=account_url, credential=DefaultAzureCredential())


def upload_json(container_name: str, blob_name: str, payload: dict) -> None:
    client = _service_client().get_blob_client(container=container_name, blob=blob_name)
    client.upload_blob(json.dumps(payload, indent=2), overwrite=True)


def upload_bytes(container_name: str, blob_name: str, content: bytes, content_type: str) -> None:
    client = _service_client().get_blob_client(container=container_name, blob=blob_name)
    client.upload_blob(content, overwrite=True, content_type=content_type)


def load_json(container_name: str, blob_name: str) -> dict:
    client = _service_client().get_blob_client(container=container_name, blob=blob_name)
    stream = client.download_blob()
    return json.loads(stream.readall())


def generate_secure_download_url(container_name: str, blob_name: str, expiry_hours: int = 24) -> str:
    settings = load_settings()
    service = _service_client()
    start = datetime.now(timezone.utc)
    expiry = start + timedelta(hours=expiry_hours)
    delegation_key = service.get_user_delegation_key(start, expiry)
    sas = generate_blob_sas(
        account_name=settings.storage_account_name,
        container_name=container_name,
        blob_name=blob_name,
        user_delegation_key=delegation_key,
        permission=BlobSasPermissions(read=True),
        expiry=expiry,
    )
    return f"https://{settings.storage_account_name}.blob.core.windows.net/{container_name}/{blob_name}?{sas}"

