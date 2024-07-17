#!/bin/bash

# Load environment variables
source .env

curl -X PUT \
  -H "X-FIGMA-TOKEN: $FIGMA_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "event_type": "LIBRARY_PUBLISH",
    "team_id": "'$FIGMA_TEAM_ID'",
    "endpoint": "https://api.github.com/repos/'$GH_USERNAME'/'$GH_REPO_NAME'/dispatches",
    "passcode": "'$WEBHOOK_PASSCODE'",
    "description": "Design System Library Publish Notifications"
  }' \
  "https://api.figma.com/v2/webhooks/$WEBHOOK_ID"