import os
from dataclasses import dataclass


@dataclass(frozen=True)
class Settings:
    subscription_id: str
    azure_openai_endpoint: str
    azure_openai_deployment: str
    report_container: str
    findings_container: str
    report_mailbox_from: str
    report_mailbox_to: list[str]
    teams_summary_webhook_url: str
    teams_qna_shared_secret: str
    storage_account_name: str
    resource_graph_tenant_scope: str


def _split_csv(value: str) -> list[str]:
    return [item.strip() for item in value.split(",") if item.strip()]


def load_settings() -> Settings:
    return Settings(
        subscription_id=os.environ.get("AZURE_SUBSCRIPTION_ID", ""),
        azure_openai_endpoint=os.environ["AZURE_OPENAI_ENDPOINT"],
        azure_openai_deployment=os.environ["AZURE_OPENAI_DEPLOYMENT"],
        report_container=os.environ.get("REPORT_BLOB_CONTAINER", "reports"),
        findings_container=os.environ.get("FINDINGS_BLOB_CONTAINER", "findings"),
        report_mailbox_from=os.environ["REPORT_MAILBOX_FROM"],
        report_mailbox_to=_split_csv(os.environ["REPORT_MAILBOX_TO"]),
        teams_summary_webhook_url=os.environ["TEAMS_SUMMARY_WEBHOOK_URL"],
        teams_qna_shared_secret=os.environ["TEAMS_QNA_SHARED_SECRET"],
        storage_account_name=os.environ["STORAGE_ACCOUNT_NAME"],
        resource_graph_tenant_scope=os.environ.get("RESOURCE_GRAPH_SCOPE", "tenant"),
    )

