# Demo Prompts

Use these prompts in the Microsoft Foundry agent playground.

## Test Prompt 1: Governance Gaps

```text
Review this landing zone evidence and identify the top governance gaps.

Evidence:
- Management groups: Tenant Root > Platform > LandingZones > Sandbox.
- Policies: only allowed locations and required tags are assigned.
- RBAC: subscription owners can assign roles directly.
- Networking: hub-and-spoke planned, but no firewall or private endpoint standard is documented.
- Monitoring: no diagnostic setting baseline is defined.
- Security: Defender for Cloud is not documented.
- DevOps: Terraform is planned, but no pipeline identity standard is documented.
```

Expected result:

- Governance score.
- Findings table.
- Missing evidence.
- 30/60/90-day roadmap.

## Test Prompt 2: Roadmap

```text
Create a 30/60/90-day remediation roadmap for the uploaded landing zone evidence. Keep it realistic for a small platform team.
```

Expected result:

- 30-day quick wins.
- 60-day foundational controls.
- 90-day maturity improvements.

## Test Prompt 3: Azure Policy Priorities

```text
Which Azure Policy initiatives or policy areas should I prioritise for this landing zone, and why?
```

Expected result:

- Tagging.
- Allowed locations.
- Diagnostics.
- Defender/security.
- Private endpoint and network controls.
- RBAC separation.
- Policy assignment structure.

## Test Prompt 4: Incomplete Evidence

```text
Review this evidence. Only use what is provided and clearly state what is missing.

Evidence:
- We use Terraform for most Azure deployments.
- Production subscriptions are separate from non-production subscriptions.
- Some policies are assigned.
```

Expected result:

- Conservative score.
- Missing evidence called out clearly.
- No invented details.

## Test Prompt 5: Portfolio Demo

```text
Act as if you are presenting this to a cloud platform steering committee. Summarise the landing zone governance risk, the most important remediation themes, and the first five actions I should take.
```
