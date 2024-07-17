curl -X POST \
  -H 'X-FIGMA-TOKEN: figd_tlrQW6Bhq2x_ASkbQFiJqxEgJk5NjKdpHo8Xdbcg' \
  -H 'Content-Type: application/json' \
  -d '{
    "event_type": "LIBRARY_PUBLISH",
    "team_id": "YOUR_TEAM_ID",
    "endpoint": "https://your-server-url.com/webhook",
    "passcode": "YOUR_SECRET_PASSCODE",
    "description": "Design System Library Publish Notifications"
  }' \
  'https://api.figma.com/v2/webhooks'
