import json

import azure.functions as func

from shared.config import load_settings


def validate_shared_secret(req: func.HttpRequest) -> bool:
    expected = load_settings().teams_qna_shared_secret
    return req.headers.get("x-qna-shared-secret", "") == expected


def parse_json_request(req: func.HttpRequest) -> dict:
    try:
        return req.get_json()
    except ValueError:
        try:
            return json.loads(req.get_body().decode("utf-8"))
        except Exception:
            return {"error": "Invalid JSON request body."}

