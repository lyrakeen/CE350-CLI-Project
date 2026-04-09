#!/usr/bin/env bash
# ask - send a prompt to an LLM API

prompt="$*"

curl "$ASK_API_URL" -s \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ASK_API_KEY" \
  -d "{
    \"model\": \"$ASK_MODEL\",
    \"messages\": [
      {\"role\": \"user\", \"content\": \"$prompt\"}
    ]
  }" | jq -r '.choices[0].message.content'