curl -X PUT \
  -H "X-FIGMA-TOKEN: $FIGMA_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "event_type": "LIBRARY_PUBLISH",
    "team_id": "'$FIGMA_TEAM_ID'",
    "endpoint": "https://api.github.com/repos/'$GH_USERNAME'/'$GH_REPO_NAME'/dispatches",
    "passcode": "'$WEBHOOK_PASSCODE'",
    "description": "Design System Library Publish Notifications",
    "client_payload": {
      "event_type": "figma-webhook",
      "passcode": "'$WEBHOOK_PASSCODE'"
    }
  }' \
  "https://api.figma.com/v2/webhooks/758750"