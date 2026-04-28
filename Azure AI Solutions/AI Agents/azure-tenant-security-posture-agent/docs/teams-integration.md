# Teams Integration Notes

This project implements an Azure Function HTTP endpoint for follow-up Q&A and an outbound delivery path for daily summary messages.

## Recommended v1 Pattern

- Daily summary:
  - post to Teams using a tenant-approved Teams Workflow or webhook-compatible integration endpoint
- Engineer Q&A:
  - route Teams-originated requests to the `teams_qna` HTTP endpoint

## Expected Request Shape For Q&A

```json
{
  "question": "Which subscriptions had public access findings today?",
  "run_id": "optional-run-id",
  "channel_id": "optional",
  "user_id": "optional"
}
```

## Expected Response Shape

```json
{
  "answer": "Plain-English response",
  "run_id": "resolved-run-id"
}
```

## Security

- Require the shared secret header configured in `TEAMS_QNA_SHARED_SECRET`
- Restrict the HTTP method to `POST`
- Log and reject malformed requests

