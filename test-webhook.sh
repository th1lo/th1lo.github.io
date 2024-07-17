#!/bin/bash

curl -X POST \
  -H "Authorization: token $GITHUB_PERSONAL_ACCESS_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$GITHUB_USERNAME/$GITHUB_REPO_NAME/dispatches" \
  -d '{"event_type": "design-system-update", "client_payload": {"file_name": "Test File", "description": "Test update", "triggered_by": {"handle": "Test User"}, "timestamp": "2023-07-17T12:00:00Z", "created_components": [{"name": "New Button"}]}}'