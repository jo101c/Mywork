from dataclasses import asdict, dataclass, field
from datetime import datetime, timezone


@dataclass
class Finding:
    source: str
    subscription_id: str
    resource_id: str
    resource_type: str
    title: str
    description: str
    severity: str
    category: str
    remediation: str
    evidence_link: str | None = None
    public_exposure: bool = False
    policy_linkage: str | None = None
    impact_score: int = 0
    metadata: dict = field(default_factory=dict)

    def to_dict(self) -> dict:
        return asdict(self)


@dataclass
class ScanRun:
    run_id: str
    generated_at_utc: str
    total_findings: int
    total_impact_score: int
    severity_counts: dict[str, int]
    findings: list[Finding]
    ai_summary_markdown: str = ""
    report_blob_name: str | None = None
    report_download_url: str | None = None

    @staticmethod
    def now(run_id: str, findings: list[Finding], total_impact_score: int) -> "ScanRun":
        severity_counts = {"high": 0, "medium": 0, "low": 0}
        for finding in findings:
            severity_counts[finding.severity.lower()] = severity_counts.get(finding.severity.lower(), 0) + 1
        return ScanRun(
            run_id=run_id,
            generated_at_utc=datetime.now(timezone.utc).isoformat(),
            total_findings=len(findings),
            total_impact_score=total_impact_score,
            severity_counts=severity_counts,
            findings=findings,
        )

    def to_dict(self) -> dict:
        return {
            "run_id": self.run_id,
            "generated_at_utc": self.generated_at_utc,
            "total_findings": self.total_findings,
            "total_impact_score": self.total_impact_score,
            "severity_counts": self.severity_counts,
            "findings": [finding.to_dict() for finding in self.findings],
            "ai_summary_markdown": self.ai_summary_markdown,
            "report_blob_name": self.report_blob_name,
            "report_download_url": self.report_download_url,
        }

