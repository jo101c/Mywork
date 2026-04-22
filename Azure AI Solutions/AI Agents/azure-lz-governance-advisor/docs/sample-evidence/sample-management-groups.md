# Sample Evidence: Management Groups And Subscriptions

## Current Structure

The organisation has started an Azure landing zone redesign.

Current management group hierarchy:

- Tenant Root Group
  - Platform
    - Connectivity
    - Management
    - Identity
  - LandingZones
    - Corp
    - Online
    - Sandbox
  - Decommissioned

## Subscriptions

- `sub-platform-connectivity-prod`
- `sub-platform-management-prod`
- `sub-platform-identity-prod`
- `sub-app-payments-dev`
- `sub-app-payments-prod`
- `sub-sandbox-shared`

## Known Decisions

- Platform subscriptions are separated from application subscriptions.
- Production and non-production application environments are separated by subscription.
- Sandbox subscriptions are allowed but should have stricter budget controls.
- A subscription vending process is planned but not yet implemented.

## Known Gaps

- Management group naming standard is not documented.
- No formal owner metadata standard exists for subscriptions.
- There is no documented process for moving subscriptions between management groups.
- Subscription creation is manual today.
