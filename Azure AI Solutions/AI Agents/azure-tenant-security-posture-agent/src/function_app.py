import azure.functions as func

from shared.pipeline import run_daily_scan
from shared.qna import answer_question
from shared.web import parse_json_request, validate_shared_secret


app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)


@app.schedule(schedule="0 0 21 * * *", arg_name="timer", run_on_startup=False, use_monitor=True)
def daily_security_scan(timer: func.TimerRequest) -> None:
    run_daily_scan(timer.past_due if timer else False)


@app.route(route="teams/qna", methods=["POST"])
def teams_qna(req: func.HttpRequest) -> func.HttpResponse:
    if not validate_shared_secret(req):
        return func.HttpResponse("Forbidden", status_code=403)

    payload = parse_json_request(req)
    if "error" in payload:
        return func.HttpResponse(payload["error"], status_code=400)

    result = answer_question(payload)
    return func.HttpResponse(
        body=result["body"],
        mimetype="application/json",
        status_code=result["status_code"],
    )
