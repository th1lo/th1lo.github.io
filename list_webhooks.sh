#!/bin/bash

# Load environment variables
if [ -f .env ]; then
    source .env
fi

# Ensure the FIGMA_TOKEN and FIGMA_TEAM_ID are set
if [ -z "$FIGMA_TOKEN" ] || [ -z "$FIGMA_TEAM_ID" ]; then
    echo "Error: FIGMA_TOKEN and FIGMA_TEAM_ID must be set in .env file"
    exit 1
fi

# Make the API request
response=$(curl -s -H "X-FIGMA-TOKEN: $FIGMA_TOKEN" \
    "https://api.figma.com/v2/teams/$FIGMA_TEAM_ID/webhooks")

# Check if the request was successful
if [[ $response == *"error"* ]]; then
    echo "Error: Failed to fetch webhooks"
    echo "$response"
    exit 1
fi

# Pretty print the JSON response
echo "$response" | jq .

# List webhook IDs and their details
echo "Webhook IDs and details:"
echo "$response" | jq '.webhooks[] | {id: .id, event_type: .event_type, endpoint: .endpoint}'