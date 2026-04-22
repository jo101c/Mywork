# Sample Evidence: Azure Policy Baseline

## Existing Policy Assignments

The following Azure Policy controls are assigned at the `LandingZones` management group:

- Allowed locations: `australiaeast`, `australiasoutheast`.
- Require `owner`, `costCentre`, `environment`, and `workload` tags.
- Deny public IP creation in production subscriptions.

The following Azure Policy controls are assigned at the `Sandbox` management group:

- Require `deleteAfter` tag.
- Audit resources without tags.

## Planned Policy Controls

- Diagnostic settings baseline.
- Defender for Cloud enablement.
- Private endpoint enforcement for selected PaaS services.
- Storage account public network access restrictions.
- Key Vault purge protection.
- Allowed VM SKUs.

## Known Gaps

- No policy initiative structure is documented.
- No policy exemption process exists.
- No remediation identity model exists for DeployIfNotExists policies.
- Policy assignments are not yet fully managed through Terraform.
- Some production policy effects are still set to `Audit` because the team is worried about deployment failures.
