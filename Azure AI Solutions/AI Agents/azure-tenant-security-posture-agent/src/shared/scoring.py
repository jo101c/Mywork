from shared.models import Finding


BASE_SCORES = {
    "high": 10,
    "medium": 5,
    "low": 2,
}


def score_finding(severity: str, public_exposure: bool) -> int:
    base = BASE_SCORES.get(severity.lower(), 2)
    if public_exposure:
        return base + 5
    return base


def score_findings(findings: list[Finding]) -> int:
    total = 0
    for finding in findings:
        finding.impact_score = score_finding(finding.severity, finding.public_exposure)
        total += finding.impact_score
    return total

