import base64

import requests

from shared.azure_clients import get_graph_token
from shared.config import load_settings


def send_report_mail(pdf_bytes: bytes, filename: str, summary_text: str) -> None:
    settings = load_settings()
    payload = {
        "message": {
            "subject": f"Azure Tenant Security Specialist Report - {filename}",
            "body": {
                "contentType": "Text",
                "content": summary_text[:4000],
            },
            "toRecipients": [{"emailAddress": {"address": address}} for address in settings.report_mailbox_to],
            "attachments": [
                {
                    "@odata.type": "#microsoft.graph.fileAttachment",
                    "name": filename,
                    "contentType": "application/pdf",
                    "contentBytes": base64.b64encode(pdf_bytes).decode("utf-8"),
                }
            ],
        },
        "saveToSentItems": "false",
    }
    response = requests.post(
        f"https://graph.microsoft.com/v1.0/users/{settings.report_mailbox_from}/sendMail",
        headers={
            "Authorization": f"Bearer {get_graph_token()}",
            "Content-Type": "application/json",
        },
        json=payload,
        timeout=60,
    )
    response.raise_for_status()

