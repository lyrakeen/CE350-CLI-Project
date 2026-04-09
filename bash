#!/usr/bin/env bash
# ask - send a prompt to an LLM API

# check required env vars are set
if [ -z "$ASK_API_URL" ] || [ -z "$ASK_MODEL" ] || [ -z "$ASK_API_KEY" ]; then
  echo "Error: ASK_API_URL, ASK_MODEL, and ASK_API_KEY must be set" >&2
  exit 1
fi

prompt="$*"

if [ -z "$prompt" ]; then
  echo "Usage: ask <prompt>" >&2
  exit 1
fi

curl "$ASK_API_URL" -s \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ASK_API_KEY" \
  -d "{
    \"model\": \"$ASK_MODEL\",
    \"messages\": [
      {\"role\": \"system\", \"content\": \"You are a CLI tool. Output plain text only. No yapping. Keep the output concise.\"},
      {\"role\": \"user\", \"content\": \"$prompt\"}
    ]
  }" | jq -r '.choices[0].message.content'