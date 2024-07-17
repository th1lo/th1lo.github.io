#!/bin/bash

# Load environment variables
source .env

curl -X POST \
  -H "Authorization: token $GH_PAT" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/$GH_USERNAME/$GH_REPO_NAME/dispatches \
  -d '{
    "event_type": "figma-webhook",
    "client_payload": {
      "passcode": "'$WEBHOOK_PASSCODE'",
      "event_type": "LIBRARY_PUBLISH",
      "file_name": "Test Dispatch",
      "description": "Testing GitHub dispatch",
      "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"
    }
  }'