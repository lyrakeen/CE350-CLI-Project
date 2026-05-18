ASK := ./ask
CODE := codebase.txt

.PHONY: all clean check-env

all: check-env action.plan.md

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
