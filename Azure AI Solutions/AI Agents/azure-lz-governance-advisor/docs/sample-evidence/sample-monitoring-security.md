# Sample Evidence: Monitoring And Security

## Monitoring

The platform team plans to use Azure Monitor and Log Analytics.

Current monitoring controls:

- Central Log Analytics workspace exists in the management subscription.
- Activity Log export is configured for the platform subscriptions.
- Basic service health alerts are configured.

Planned monitoring controls:

- Diagnostic settings baseline for supported resource types.
- Action Groups for critical platform alerts.
- Dashboard for policy compliance and Defender recommendations.
- Integration with an ITSM or incident response tool.

## Security

Current security controls:

- Microsoft Entra MFA is enabled for administrators.
- Privileged Identity Management is used for some platform roles.
- Defender for Cloud is enabled manually on some subscriptions.

## Known Gaps

- Defender for Cloud configuration is not consistent across all subscriptions.
- No documented incident response process exists for Azure platform alerts.
- Diagnostic settings are not enforced through policy.
- No clear retention standard exists for platform logs.
- Break-glass account process is not documented.
- Reader access is not consistently governed through groups.
