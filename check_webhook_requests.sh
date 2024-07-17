#!/bin/bash

# Load environment variables
if [ -f .env ]; then
    source .env
fi

# Ensure the FIGMA_TOKEN and WEBHOOK_ID are set
if [ -z "$FIGMA_TOKEN" ] || [ -z "$WEBHOOK_ID" ]; then
    echo "Error: FIGMA_TOKEN and WEBHOOK_ID must be set in .env file"
    exit 1
fi

# Make the API request
response=$(curl -s -H "X-FIGMA-TOKEN: $FIGMA_TOKEN" \
    "https://api.figma.com/v2/webhooks/$WEBHOOK_ID/requests")

# Check if the request was successful
if [[ $response == *"error"* ]]; then
    echo "Error: Failed to fetch webhook requests"
    echo "$response"
    exit 1
fi

# Pretty print the JSON response
echo "$response" | jq .

# Analyze the response
requests=$(echo "$response" | jq '.requests')
request_count=$(echo "$requests" | jq 'length')

echo "Number of webhook requests in the last week: $request_count"

if [ "$request_count" -eq 0 ]; then
    echo "No webhook requests found. The webhook might not be triggered or there might be an issue with the configuration."
else
    echo "Latest webhook request:"
    echo "$requests" | jq '.[0]'
fi