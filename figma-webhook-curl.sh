#!/bin/bash

curl -X POST \
  -H "X-FIGMA-TOKEN: $FIGMA_PERSONAL_ACCESS_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
    "event_type": "LIBRARY_PUBLISH",
<<<<<<< HEAD
    "team_id": "YOUR_TEAM_ID",
    "endpoint": "https://your-server-url.com/webhook",
    "passcode": "YOUR_SECRET_PASSCODE",
=======
    "team_id": "'$FIGMA_TEAM_ID'",
    "endpoint": "https://api.github.com/repos/'$GITHUB_USERNAME'/'$GITHUB_REPO_NAME'/dispatches",
    "passcode": "'$GITHUB_PERSONAL_ACCESS_TOKEN'",
>>>>>>> be9eff5 (Remove sensitive information)
    "description": "Design System Library Publish Notifications"
  }' \
  'https://api.figma.com/v2/webhooks'
