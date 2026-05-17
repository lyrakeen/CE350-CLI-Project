
## Project Structure

.
├── ask
├── codebase.txt
├── Makefile
├── .env.example
├── .gitignore
├── README.md
├── COMMIT_PLAN.md
├── PART_B_EXPLANATION.md
└── SAMPLE_ACTION_PLAN.md

## Requirements

The ask script requires:

- bash
- curl
- jq
- an OpenAI-compatible chat completions API endpoint

The following environment variables must be set:

ASK_API_URL
ASK_MODEL
ASK_API_KEY

## Setup

First, make the ask script executable:

chmod +x ask

Then copy the example environment file:

cp .env.example .env

Edit .env and add your real API values.

After editing the file, load the environment variables:

source .env

## Run the Pipeline

Run the pipeline with GNU Make:

make -j

The -j option allows Make to run independent targets in parallel.

The final output will be:

action.plan.md

## Clean Generated Files

To remove all generated markdown files, run:

make clean

## Pipeline Flow

codebase.txt
├── quality.md   ── quality.sum.md
├── perf.md      ── perf.sum.md
└── security.md  ── security.sum.md
        ↓
concatenated.md
        ↓
refined.md
        ↓
action.plan.md

## How the Pipeline Works

The pipeline starts with codebase.txt.

In the first phase, Make runs three independent analysis targets:

- quality.md
- perf.md
- security.md

These targets analyze the codebase from three different perspectives:

1. Code Quality
2. Performance
3. Security

Because these files all depend only on codebase.txt and ask, they can run in parallel when the command make -j is used.

In the second phase, each analysis result is summarized:

- quality.md becomes quality.sum.md
- perf.md becomes perf.sum.md
- security.md becomes security.sum.md

Each summary contains exactly five actionable bullet points.

In the third phase, the summaries are combined into concatenated.md.

This step is done only with shell tools such as echo and cat. It does not use ask, as required by the assignment.

Then, concatenated.md is refined into refined.md.

Finally, refined.md is used to generate the final engineering action plan:

action.plan.md

## Makefile

ASK := ./ask
CODE := codebase.txt

.PHONY: all clean check-env

all: action.plan.md

check-env:
	@test -n "$(ASK_API_URL)" || (echo "Error: ASK_API_URL is not set" >&2; exit 1)
	@test -n "$(ASK_MODEL)" || (echo "Error: ASK_MODEL is not set" >&2; exit 1)
	@test -n "$(ASK_API_KEY)" || (echo "Error: ASK_API_KEY is not set" >&2; exit 1)

quality.md: $(CODE) $(ASK)
	$(ASK) 'Analyze the following code for Code Quality. Focus on readability, structure, duplication, naming, maintainability, error handling, and testability. Output 5-7 bullets in this format: problem -> fix.' < $(CODE) > $@

perf.md: $(CODE) $(ASK)
	$(ASK) 'Analyze the following code for Performance. Focus on bottlenecks, inefficient database usage, connection handling, serialization, scalability, and unnecessary work. Output 5-7 bullets in this format: issue -> optimization.' < $(CODE) > $@

security.md: $(CODE) $(ASK)
	$(ASK) 'Analyze the following code for Security. Focus on vulnerabilities, unsafe patterns, input validation, SQL injection, debug mode, authentication, authorization, and configuration risks. Output 5-7 bullets in this format: risk -> mitigation.' < $(CODE) > $@

quality.sum.md: quality.md $(ASK)
	$(ASK) 'Summarize the code quality analysis into exactly 5 bullets. Keep only actionable items. Preserve the format: problem -> fix.' < quality.md > $@

perf.sum.md: perf.md $(ASK)
	$(ASK) 'Summarize the performance analysis into exactly 5 bullets. Keep only actionable items. Preserve the format: issue -> optimization.' < perf.md > $@

security.sum.md: security.md $(ASK)
	$(ASK) 'Summarize the security analysis into exactly 5 bullets. Keep only actionable items. Preserve the format: risk -> mitigation.' < security.md > $@

concatenated.md: quality.sum.md perf.sum.md security.sum.md
	{ \
		echo '## Code Quality'; \
		echo; \
		cat quality.sum.md; \
		echo; \
		echo '## Performance'; \
		echo; \
		cat perf.sum.md; \
		echo; \
		echo '## Security'; \
		echo; \
		cat security.sum.md; \
	} > $@

refined.md: concatenated.md $(ASK)
	$(ASK) 'Refine the following report. Keep the sections Code Quality, Performance, and Security. Remove duplicates. Keep only high-signal engineering issues. Keep the content concise and actionable.' < concatenated.md > $@

action.plan.md: refined.md $(ASK)
	$(ASK) 'Generate a final markdown report titled Engineering Action Plan. Include prioritized actions with High, Medium, or Low priority. Include effort estimate as Small, Medium, or Large. Include a clear execution order. Group actions under Code Quality, Performance, and Security.' < refined.md > $@

clean:
	rm -f quality.md quality.sum.md perf.md perf.sum.md security.md security.sum.md concatenated.md refined.md action.plan.md

## Notes

- make -j enables parallel execution.
- quality.md, perf.md, and security.md are created in parallel.
- concatenated.md is created without using the LLM.
- refined.md removes duplicate and low-value issues.
- action.plan.md is the final prioritized engineering action plan.
