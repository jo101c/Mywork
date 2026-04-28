import json

from openai import AzureOpenAI

from shared.config import load_settings
from shared.models import ScanRun


def build_openai_client() -> AzureOpenAI:
    settings = load_settings()
    return AzureOpenAI(
        api_version="2024-10-21",
        azure_endpoint=settings.azure_openai_endpoint,
        azure_ad_token_provider=None,
    )


def summarise_run(scan_run: ScanRun, bearer_token: str) -> str:
    settings = load_settings()
    client = AzureOpenAI(
        api_version="2024-10-21",
        azure_endpoint=settings.azure_openai_endpoint,
        azure_ad_token=bearer_token,
    )
    prompt = (
        "You are an Azure Security Specialist. Summarise the following structured findings "
        "into an executive security posture report with severity breakdown, total impact explanation, "
        "top risks, public exposure summary, governance gaps, and remediation priorities.\n\n"
        f"{json.dumps(scan_run.to_dict(), indent=2)}"
    )
    response = client.chat.completions.create(
        model=settings.azure_openai_deployment,
        temperature=0.2,
        messages=[
            {"role": "system", "content": "You are an Azure Security Specialist focused on Azure cyber security findings."},
            {"role": "user", "content": prompt},
        ],
    )
    return response.choices[0].message.content or ""


def answer_findings_question(question: str, run_payload: dict, bearer_token: str) -> str:
    settings = load_settings()
    client = AzureOpenAI(
        api_version="2024-10-21",
        azure_endpoint=settings.azure_openai_endpoint,
        azure_ad_token=bearer_token,
    )
    response = client.chat.completions.create(
        model=settings.azure_openai_deployment,
        temperature=0.2,
        messages=[
            {"role": "system", "content": "You are an Azure Security Specialist. Answer only from the provided findings payload and state when evidence is missing."},
            {"role": "user", "content": f"Question:\n{question}\n\nFindings payload:\n{json.dumps(run_payload, indent=2)}"},
        ],
    )
    return response.choices[0].message.content or ""

