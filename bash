#!/usr/bin/env bash


if [ -z "$ASK_API_URL" ] || [ -z "$ASK_MODEL" ] || [ -z "$ASK_API_KEY" ]; then
  echo "Error: ASK_API_URL, ASK_MODEL, and ASK_API_KEY must be set" >&2
  exit 1
fi

args_prompt="$*"
stdin_input=""

if [ ! -t 0 ]; then
  stdin_input="$(cat)"
fi

if [ -n "$args_prompt" ] && [ -n "$stdin_input" ]; then
  prompt="$args_prompt"$'\n'"$stdin_input"
elif [ -n "$args_prompt" ]; then
  prompt="$args_prompt"
elif [ -n "$stdin_input" ]; then
  prompt="$stdin_input"
else
  echo "Usage: ask <prompt>" >&2
  echo "       echo 'text' | ask <prompt>" >&2
  exit 1
fi

curl "$ASK_API_URL" -s \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ASK_API_KEY" \
  -d "{
    \"model\": \"$ASK_MODEL\",
    \"messages\": [
      {\"role\": \"system\", \"content\": \"You are a CLI tool. Output plain text only. No yapping. Keep the output concise.\"},
      {\"role\": \"user\", \"content\": $(echo "$prompt" | jq -Rs '.')}
    ]
  }" | jq -r '.choices[0].message.content'