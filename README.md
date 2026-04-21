# ask

A minimal Bash CLI tool for sending prompts to an OpenAI-compatible LLM API.

## Dependencies

- `curl`
- `jq`

## Setup

Set these environment variables:

```bash
export ASK_API_URL="https://api.groq.com/openai/v1/chat/completions"
export ASK_MODEL="llama-3.3-70b-versatile"
export ASK_API_KEY="your-api-key-here"
```

The script expects these exact variable names:

- `ASK_API_URL`
- `ASK_MODEL`
- `ASK_API_KEY`

## Usage

```bash
ask "What is the capital of France?"
```

Arguments are combined into one prompt:

```bash
ask "Establishment dates of" "Turkey" "Azerbaijan" "Japan"
```

Piped input is also supported:

```bash
cat script.sh | ask "Explain this Bash script:"
```

Arguments and piped input can be used together:

```bash
echo "uname -a output here" | ask "Explain this output briefly:"
```

## Installation

```bash
git clone https://github.com/yourusername/ask.git
cd ask
chmod +x ask
cp ask /usr/local/bin/ask
```

## Known Limitations

- Stateless; no conversation history
- Long prompts may exceed model limits
- No streaming output
- Requires `jq`
- Requires valid environment variables
- Requires network access to the API provider

## License

MIT — see `LICENSE`
