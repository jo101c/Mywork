import logging
from datetime import datetime, timezone

from shared.azure_clients import get_credential
from shared.collectors import collect_advisor_findings, collect_custom_posture_findings, collect_defender_findings, collect_policy_findings
from shared.config import load_settings
from shared.mail import send_report_mail
from shared.models import ScanRun
from shared.openai_client import summarise_run
from shared.reporting import generate_pdf
from shared.scoring import score_findings
from shared.storage import generate_secure_download_url, upload_bytes, upload_json
from shared.subscriptions import list_enabled_subscriptions
from shared.teams import post_summary


def run_daily_scan(past_due: bool) -> None:
    if past_due:
        logging.warning("Timer trigger is running late.")

    settings = load_settings()
    subscriptions = list_enabled_subscriptions()
    findings = []

    findings.extend(collect_defender_findings(subscriptions))
    findings.extend(collect_custom_posture_findings(subscriptions))
    for subscription_id in subscriptions:
        findings.extend(collect_advisor_findings(subscription_id))
        findings.extend(collect_policy_findings(subscription_id))

    total_impact_score = score_findings(findings)
    run_id = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    scan_run = ScanRun.now(run_id, findings, total_impact_score)

    bearer_token = get_credential().get_token("https://cognitiveservices.azure.com/.default").token
    scan_run.ai_summary_markdown = summarise_run(scan_run, bearer_token)

    findings_blob = f"runs/{run_id}/findings.json"
    upload_json(settings.findings_container, findings_blob, scan_run.to_dict())

    pdf_bytes = generate_pdf(scan_run)
    report_blob = f"runs/{run_id}/report.pdf"
    upload_bytes(settings.report_container, report_blob, pdf_bytes, "application/pdf")

    scan_run.report_blob_name = report_blob
    scan_run.report_download_url = generate_secure_download_url(settings.report_container, report_blob)
    upload_json(settings.findings_container, "latest.json", scan_run.to_dict())

    send_report_mail(pdf_bytes, f"{run_id}-security-report.pdf", scan_run.ai_summary_markdown)
    post_summary(scan_run)
