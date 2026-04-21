# Contributing

Thanks for your interest in contributing to `ask`.

## How to contribute

1. Fork the repository
2. Create a new branch for your change
3. Make your changes
4. Test the script
5. Commit with a clear message
6. Open a pull request

## Contribution guidelines

- Keep the project simple and readable
- Do not add extra dependencies other than `curl` and `jq`
- Preserve support for:
  - command-line arguments
  - piped input
  - both together
- Keep the environment variable names exactly as:
  - `ASK_API_URL`
  - `ASK_MODEL`
  - `ASK_API_KEY`
- Write clear and meaningful commit messages
- Update the README if usage or behavior changes

## Code style

- Use simple, readable Bash
- Prefer clear variable names
- Keep the script small and easy to inspect
- Avoid unnecessary complexity

## Reporting issues

If you find a bug or want to suggest an improvement, please open an issue with:

- a short description
- steps to reproduce
- expected behavior
- actual behavior

## Pull requests

Before opening a pull request, please make sure that your change:

- focuses on one clear improvement
- does not break existing usage
- is explained briefly in the pull request description
