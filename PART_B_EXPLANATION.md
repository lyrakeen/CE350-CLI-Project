# Part B Explanation

## How the Pipeline Works

This project uses GNU Make as a DAG orchestration tool and the `ask` script as a command-line LLM interface.

The input file is `codebase.txt`. The pipeline first runs three independent analyses:

1. Code quality analysis
2. Performance analysis
3. Security analysis

These targets are independent from each other, so they can run in parallel when `make -j` is used.

After that, each analysis is summarized into exactly five actionable bullets. The three summaries are then combined into `concatenated.md` using only shell tools such as `echo` and `cat`. This step does not use the LLM.

The concatenated report is refined into `refined.md`, and the final prioritized engineering action plan is generated as `action.plan.md`.

## Case 1: When `codebase.txt` is updated

`codebase.txt` is the source dependency for the three first-level analysis files:

- `quality.md`
- `perf.md`
- `security.md`

When `codebase.txt` changes, Make marks these three targets as outdated. After they are regenerated, their summaries are also regenerated:

- `quality.sum.md`
- `perf.sum.md`
- `security.sum.md`

Then Make regenerates:

- `concatenated.md`
- `refined.md`
- `action.plan.md`

So, changing `codebase.txt` causes the full pipeline to run again.

## Case 2: When `security.sum.md` is updated

`security.sum.md` is one of the inputs of `concatenated.md`.

When `security.sum.md` changes, Make regenerates:

1. `concatenated.md`
2. `refined.md`
3. `action.plan.md`

The earlier files such as `quality.md`, `perf.md`, and `security.md` do not need to be regenerated because they are not downstream from `security.sum.md`.

## Case 3: When `refined.md` is updated

`refined.md` is the direct input of the final target `action.plan.md`.

When `refined.md` changes, Make only regenerates:

- `action.plan.md`

The earlier analysis, summary, and concatenation steps are not repeated.

## Why `make -j` is useful

The first three branches are independent from each other:

- Code Quality
- Performance
- Security

Because of this, GNU Make can run them in parallel. This makes the pipeline faster and keeps the execution order structured.
