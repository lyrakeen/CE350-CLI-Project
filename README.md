# ask

Small Bash CLI tool for sending prompts to an OpenAI-compatible LLM API.

## Requirements

- curl
- jq

## Setup

Set these environment variables:

```bash
export ASK_API_URL="https://api.groq.com/openai/v1/chat/completions"
export ASK_MODEL="llama-3.3-70b-versatile"
export ASK_API_KEY="your-api-key"
```

## Usage

Ask a question:

```bash
ask "What is the capital of France?"
```

Use piped input:

```bash
cat script.sh | ask "Explain this script simply:"
```

Use both arguments and input:

```bash
./ask "Explain this output:" "$(uname -a)"
```

## Install

```bash
chmod +x ask
cp ask /usr/local/bin/ask
```

## Limitations

- No chat history
- No streaming
- Long prompts may hit API/model limits
- Requires `curl` and `jq`
