import requests

from shared.config import load_settings
from shared.models import ScanRun


def post_summary(scan_run: ScanRun) -> None:
    settings = load_settings()
    card = {
        "type": "message",
        "attachments": [
            {
                "contentType": "application/vnd.microsoft.card.adaptive",
                "content": {
                    "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
                    "type": "AdaptiveCard",
                    "version": "1.5",
                    "body": [
                        {"type": "TextBlock", "size": "Large", "weight": "Bolder", "text": "Azure Tenant Security Specialist Report"},
                        {"type": "TextBlock", "text": f"Run ID: {scan_run.run_id}", "wrap": True},
                        {"type": "TextBlock", "text": f"Total findings: {scan_run.total_findings}", "wrap": True},
                        {"type": "TextBlock", "text": f"Total impact score: {scan_run.total_impact_score}", "wrap": True},
                        {"type": "TextBlock", "text": f"High: {scan_run.severity_counts.get('high', 0)} | Medium: {scan_run.severity_counts.get('medium', 0)} | Low: {scan_run.severity_counts.get('low', 0)}", "wrap": True},
                        {"type": "TextBlock", "text": (scan_run.ai_summary_markdown[:700] + "...") if len(scan_run.ai_summary_markdown) > 700 else scan_run.ai_summary_markdown, "wrap": True},
                    ],
                    "actions": [
                        {
                            "type": "Action.OpenUrl",
                            "title": "Open Secure PDF Report",
                            "url": scan_run.report_download_url or "",
                        }
                    ],
                },
            }
        ],
    }
    response = requests.post(settings.teams_summary_webhook_url, json=card, timeout=60)
    response.raise_for_status()

