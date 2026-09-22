---
name: commit-msg
description: Walk through the commitizen (cz-conventional-changelog) prompt flow and directly output one ready-to-use git commit message that conforms to the Conventional Commits format. Use when the user wants a finished commit message assembled from the step-by-step answers.
---

# Commit Message

## Goal

Given the change to commit, work through the commitizen prompt flow below and
**output a single, ready-to-use git commit message** that conforms to the
Conventional Commits format defined in "Assembled message format". The final
deliverable is the message itself — formatted and ready to paste into
`git commit` — not a description of the steps.

## Process

Construct the message by answering the commitizen prompts in order. Each step
below maps to one prompt; collect the answers, then assemble them into the
final message using the format at the end.

## Step 1 — Select the type of change

Choose exactly one type that describes the change you are committing:

| Type       | Meaning                                                                                                 |
| ---------- | ------------------------------------------------------------------------------------------------------- |
| `feat`     | A new feature                                                                                           |
| `fix`      | A bug fix                                                                                               |
| `docs`     | Documentation only changes                                                                              |
| `style`    | Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)  |
| `refactor` | A code change that neither fixes a bug nor adds a feature                                               |
| `perf`     | A code change that improves performance                                                                 |
| `test`     | Adding missing tests or correcting existing tests                                                       |
| `build`    | Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)     |
| `ci`       | Changes to CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs) |
| `chore`    | Other changes that don't modify src or test files                                                       |
| `revert`   | Reverts a previous commit                                                                               |

## Step 2 — Define the scope

Specify the scope of this change, e.g. a component or file name. Optional;
leave empty if the change has no single obvious scope.

## Step 3 — Write a short description

Write a short, imperative-tense description of the change (max 88 chars).
Use imperative mood (e.g. "add", "fix", "update"), no trailing period.

## Step 4 — Provide a longer description

Provide a longer description of the change. Optional. Wrap each line at a
maximum of 100 chars.

## Step 5 — Declare breaking changes

Answer whether there are any breaking changes: yes or no.

## Step 6 — Describe the breaking changes

Only if Step 5 is "yes": describe the breaking changes.

## Assembled message format

```
<type>(<scope>): <subject>

<body>

BREAKING CHANGE: <description of the breaking changes>
```

- `(<scope>)` is omitted when Step 2 is empty: `<type>: <subject>`.
- `<body>` is omitted when Step 4 is empty.
- The `BREAKING CHANGE:` footer is included only when Step 5 is "yes".
