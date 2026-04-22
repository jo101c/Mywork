# Sample Evidence: Networking

## Current Design

The target network model is hub-and-spoke.

Hub subscription:

- `sub-platform-connectivity-prod`

Hub components planned:

- Azure Firewall.
- VPN Gateway.
- ExpressRoute Gateway in a later phase.
- Private DNS zones.
- Shared Bastion, subject to cost review.

Spoke pattern:

- One spoke VNet per workload environment.
- Peering to the platform hub.
- Workload teams manage subnet-level NSGs.

## Known Decisions

- Internet egress should route through the hub firewall for production.
- Private endpoints are preferred for critical PaaS services.
- DNS should be centralised through platform-managed Private DNS zones.

## Known Gaps

- UDR standards are not yet documented.
- Firewall policy ownership is unclear.
- Private endpoint approval workflow is not documented.
- No standard exists for subnet naming, NSG rules, or route table association.
- Non-production egress rules are not yet defined.
