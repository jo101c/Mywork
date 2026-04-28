from shared.arg_queries import (
    AKS_HARDENING_QUERY,
    APPSERVICE_PUBLIC_ACCESS_QUERY,
    COSMOS_PUBLIC_ACCESS_QUERY,
    DEFENDER_RECOMMENDATIONS_QUERY,
    KEY_VAULT_HARDENING_QUERY,
    PUBLIC_IP_EXPOSURE_QUERY,
    PUBLIC_STORAGE_ACCESS_QUERY,
    SQL_PUBLIC_ACCESS_QUERY,
)
from shared.azure_clients import arm_get, arm_post, query_resource_graph
from shared.models import Finding


def collect_defender_findings(subscriptions: list[str]) -> list[Finding]:
    rows = query_resource_graph(DEFENDER_RECOMMENDATIONS_QUERY, subscriptions)
    findings = []
    for row in rows:
        findings.append(
            Finding(
                source="Defender for Cloud",
                subscription_id=row.get("subscriptionId", ""),
                resource_id=row.get("resourceId", ""),
                resource_type=row.get("resourceType", "unknown"),
                title=row.get("title", "Defender recommendation"),
                description=row.get("description", ""),
                severity=(row.get("severity") or "Medium").lower(),
                category="defender",
                remediation=row.get("remediation", "Review the recommendation in Defender for Cloud."),
                metadata={"assessment_key": row.get("assessmentKey")},
            )
        )
    return findings


def collect_advisor_findings(subscription_id: str) -> list[Finding]:
    url = f"https://management.azure.com/subscriptions/{subscription_id}/providers/Microsoft.Advisor/recommendations?api-version=2025-01-01"
    response = arm_get(url)
    findings = []
    for item in response.get("value", []):
        properties = item.get("properties", {})
        category = properties.get("category", "")
        if category.lower() != "security":
            continue
        findings.append(
            Finding(
                source="Azure Advisor",
                subscription_id=subscription_id,
                resource_id=properties.get("resourceMetadata", {}).get("resourceId", ""),
                resource_type=properties.get("resourceMetadata", {}).get("resourceType", "unknown"),
                title=properties.get("shortDescription", {}).get("problem", item.get("name", "Advisor recommendation")),
                description=properties.get("shortDescription", {}).get("solution", ""),
                severity="medium",
                category="advisor",
                remediation=properties.get("remediationDescription", "Review the Advisor recommendation."),
                evidence_link=item.get("id"),
            )
        )
    return findings


def collect_policy_findings(subscription_id: str) -> list[Finding]:
    policy_url = (
        f"https://management.azure.com/subscriptions/{subscription_id}"
        "/providers/Microsoft.PolicyInsights/policyStates/latest/queryResults?api-version=2022-04-01"
    )
    response = arm_post(
        policy_url,
        {
            "query": "PolicyStates | where ComplianceState == 'NonCompliant' | take 500"
        },
    )
    findings = []
    for row in response.get("value", []):
        findings.append(
            Finding(
                source="Azure Policy",
                subscription_id=subscription_id,
                resource_id=row.get("resourceId", ""),
                resource_type=row.get("resourceType", "unknown"),
                title=row.get("policyDefinitionName", "Policy non-compliance"),
                description=row.get("policyDefinitionAction", "Non-compliant policy state detected"),
                severity="medium",
                category="policy",
                remediation="Review the non-compliant resource and either remediate or process an approved exemption.",
                policy_linkage=row.get("policyAssignmentName"),
                metadata={
                    "policy_assignment_id": row.get("policyAssignmentId"),
                    "policy_definition_id": row.get("policyDefinitionId"),
                },
            )
        )
    return findings


def _resource_graph_posture_findings(query: str, subscriptions: list[str], title_prefix: str, severity: str, category: str, public_exposure: bool = False, remediation: str = "") -> list[Finding]:
    rows = query_resource_graph(query, subscriptions)
    findings = []
    for row in rows:
        findings.append(
            Finding(
                source="Azure Resource Graph",
                subscription_id=row.get("subscriptionId", ""),
                resource_id=row.get("resourceId", ""),
                resource_type=row.get("resourceType", "unknown"),
                title=f"{title_prefix}: {row.get('title', 'resource')}",
                description=row.get("description", ""),
                severity=severity,
                category=category,
                remediation=remediation,
                public_exposure=public_exposure,
            )
        )
    return findings


def collect_custom_posture_findings(subscriptions: list[str]) -> list[Finding]:
    findings: list[Finding] = []
    findings.extend(
        _resource_graph_posture_findings(
            PUBLIC_STORAGE_ACCESS_QUERY,
            subscriptions,
            "Storage exposure",
            "high",
            "public-access",
            public_exposure=True,
            remediation="Disable public network access or public blob access and prefer private endpoints plus approved network rules.",
        )
    )
    findings.extend(
        _resource_graph_posture_findings(
            KEY_VAULT_HARDENING_QUERY,
            subscriptions,
            "Key Vault hardening gap",
            "high",
            "hardening",
            public_exposure=True,
            remediation="Disable public access and enable purge protection for Key Vault.",
        )
    )
    findings.extend(
        _resource_graph_posture_findings(
            SQL_PUBLIC_ACCESS_QUERY,
            subscriptions,
            "SQL public access",
            "high",
            "public-access",
            public_exposure=True,
            remediation="Disable SQL public network access and use private endpoints where feasible.",
        )
    )
    findings.extend(
        _resource_graph_posture_findings(
            APPSERVICE_PUBLIC_ACCESS_QUERY,
            subscriptions,
            "App Service posture gap",
            "medium",
            "hardening",
            remediation="Enable HTTPS only and review public network exposure requirements.",
        )
    )
    findings.extend(
        _resource_graph_posture_findings(
            COSMOS_PUBLIC_ACCESS_QUERY,
            subscriptions,
            "Cosmos DB public access",
            "high",
            "public-access",
            public_exposure=True,
            remediation="Disable public network access and prefer private endpoints.",
        )
    )
    findings.extend(
        _resource_graph_posture_findings(
            AKS_HARDENING_QUERY,
            subscriptions,
            "AKS hardening gap",
            "medium",
            "hardening",
            remediation="Use private clusters and disable local accounts where possible.",
        )
    )
    findings.extend(
        _resource_graph_posture_findings(
            PUBLIC_IP_EXPOSURE_QUERY,
            subscriptions,
            "Public IP exposure",
            "medium",
            "public-access",
            public_exposure=True,
            remediation="Confirm public IP necessity and enforce network controls or remove unused exposure.",
        )
    )
    return findings
