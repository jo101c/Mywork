import json

from shared.azure_clients import get_credential
from shared.config import load_settings
from shared.openai_client import answer_findings_question
from shared.storage import load_json


def answer_question(payload: dict) -> dict:
    settings = load_settings()
    question = payload.get("question", "").strip()
    if not question:
        return {"status_code": 400, "body": json.dumps({"error": "Question is required."})}

    run_id = payload.get("run_id")
    blob_name = f"runs/{run_id}/findings.json" if run_id else "latest.json"
    run_payload = load_json(settings.findings_container, blob_name)

    bearer_token = get_credential().get_token("https://cognitiveservices.azure.com/.default").token
    answer = answer_findings_question(question, run_payload, bearer_token)

    return {
        "status_code": 200,
        "body": json.dumps(
            {
                "answer": answer,
                "run_id": run_payload.get("run_id"),
            }
        ),
    }

