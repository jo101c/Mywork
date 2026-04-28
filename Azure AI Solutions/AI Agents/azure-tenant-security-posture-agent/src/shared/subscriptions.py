from shared.azure_clients import arm_get


def list_enabled_subscriptions() -> list[str]:
    response = arm_get("https://management.azure.com/subscriptions?api-version=2022-12-01")
    subscription_ids = []
    for item in response.get("value", []):
        state = item.get("state", "")
        if state.lower() == "enabled":
            subscription_ids.append(item["subscriptionId"])
    return subscription_ids

