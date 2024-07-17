#!/bin/bash

curl -X POST \
  -H "Authorization: token $GH_PAT" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$GH_USERNAME/$GH_REPO_NAME/dispatches" \
  -d '{"event_type": "design-system-update", "client_payload": {"file_name": "Test File", "description": "Test update", "triggered_by": {"handle": "Test User"}, "timestamp": "2023-07-17T12:00:00Z", "created_components": [{"name": "New Button"}]}}'