from io import BytesIO

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle

from shared.models import ScanRun


def generate_pdf(scan_run: ScanRun) -> bytes:
    buffer = BytesIO()
    doc = SimpleDocTemplate(buffer, pagesize=A4)
    styles = getSampleStyleSheet()
    story = []

    story.append(Paragraph("Azure Tenant Security Specialist Report", styles["Title"]))
    story.append(Spacer(1, 12))
    story.append(Paragraph(f"Run ID: {scan_run.run_id}", styles["BodyText"]))
    story.append(Paragraph(f"Generated: {scan_run.generated_at_utc}", styles["BodyText"]))
    story.append(Paragraph(f"Total Findings: {scan_run.total_findings}", styles["BodyText"]))
    story.append(Paragraph(f"Total Impact Score: {scan_run.total_impact_score}", styles["BodyText"]))
    story.append(Spacer(1, 12))

    story.append(Paragraph("AI Summary", styles["Heading2"]))
    for paragraph in scan_run.ai_summary_markdown.split("\n\n"):
        if paragraph.strip():
            story.append(Paragraph(paragraph.replace("\n", "<br/>"), styles["BodyText"]))
            story.append(Spacer(1, 8))

    story.append(Paragraph("Detailed Findings", styles["Heading2"]))
    table_data = [["Severity", "Source", "Subscription", "Resource Type", "Title", "Impact"]]
    for finding in scan_run.findings[:100]:
        table_data.append(
            [
                finding.severity.upper(),
                finding.source,
                finding.subscription_id,
                finding.resource_type,
                finding.title,
                str(finding.impact_score),
            ]
        )

    table = Table(table_data, repeatRows=1)
    table.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#1f4e78")),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
                ("GRID", (0, 0), (-1, -1), 0.25, colors.grey),
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("FONTSIZE", (0, 0), (-1, -1), 8),
            ]
        )
    )
    story.append(table)

    doc.build(story)
    return buffer.getvalue()

