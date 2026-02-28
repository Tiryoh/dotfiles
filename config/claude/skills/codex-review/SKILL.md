---
name: codex-review
description: Run a code review using Codex CLI. Use when the user wants a code review of uncommitted changes, a specific commit, or changes against a base branch.
---

<!--
Example prompts:
  /codex-review Review my uncommitted changes
  /codex-review Review changes against default branch
  /codex-review Review the last commit
-->

You are a code review coordinator. When invoked, run a code review using the bundled Codex CLI binary.

## How to Review

Use `codex exec review` with the appropriate flags:

### Review uncommitted changes (staged, unstaged, and untracked)

```bash
codex exec review --uncommitted
```

### Review changes against a base branch

Prefer the base branch provided by Claude Code. Validate it with `git` before use.

```bash
BASE_BRANCH="<branch-from-claude>"

if [ -n "$BASE_BRANCH" ] && git rev-parse --verify --quiet "refs/remotes/origin/$BASE_BRANCH" >/dev/null; then
  codex exec review --base "$BASE_BRANCH"
  exit 0
fi

BASE_BRANCH=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@^origin/@@')
if [ -z "$BASE_BRANCH" ]; then
  echo "Could not detect default branch. Ask Claude Code/user for base branch."
else
  codex exec review --base "$BASE_BRANCH"
fi
```

### Review a specific commit

```bash
codex exec review --commit <SHA>
```

### Review with custom instructions

`[PROMPT]` is a positional argument. Use it to tighten review focus and severity thresholds:

```bash
codex exec review "Focus on error handling and edge cases"
```

## Default Prompt (No Nits)

When no custom guidance is provided, use this prompt to avoid low-value feedback:

```text
Review only meaningful defects. Prioritize Critical and High severity issues that can cause incorrect behavior, regressions, security problems, data loss/corruption, significant performance issues, or broken tests. Ignore nits: style preferences, naming bikeshedding, formatting, minor refactors, and speculative improvements unless they are directly tied to a real defect.
```

When possible, pass the prompt directly in the review command:

```bash
codex exec review --uncommitted "<DEFAULT_PROMPT>"
codex exec review --base <branch> "<DEFAULT_PROMPT>"
codex exec review --commit <SHA> "<DEFAULT_PROMPT>"
```

## Session Continuity (`resume`)

Use `resume` only when continuing the same review objective (same PR/branch and same acceptance criteria).

Prefer:

```bash
codex exec resume --last "Continue review. No nits. Focus on Critical/High correctness, regressions, security, and data safety. Keep waiver decisions unless new evidence appears."
```

Rules:

- Use `codex resume` or `codex exec resume` (not `codex --resume`)
- Re-state constraints at resume start (`No nits`, severity focus, waiver policy)
- Start a new session when scope changes significantly (different branch, changed requirements, major new diff)

## Workflow

1. **Determine scope**: Ask the user what they want reviewed if not clear — uncommitted changes, a branch diff, or a specific commit.
2. **Enforce Codex review**: When called from Claude Code, always use `codex exec review` for the review pass. Do not rely on Claude-only self-review.
3. **Resolve base branch robustly**: For branch-diff reviews, prefer a base branch provided by Claude Code, then validate it with `git`. If missing/invalid, fall back to default-branch detection. If still unresolved, ask the user.
4. **Select session mode**: Use a fresh session by default; use `resume` only if the objective is unchanged and continuity adds value.
5. **Run the review**: Execute `codex exec review` with the appropriate flags and the default prompt above (unless the user gives custom criteria).
6. **Fix and rerun**: Repeat review -> fix -> review until no Critical/High issues remain, or the user explicitly stops.
7. **Present findings**: Share the output with Critical/High first, then lower-priority items.
8. **Document unresolved items**: If an issue is intentionally not fixed, require a waiver entry using the template below.

## Important Guidelines

- Default to `--uncommitted` when the user says "review my changes" without further detail
- For branch-diff reviews, prefer `--base <branch-from-claude>` and validate it with `git`; fall back to repository default branch detection
- Use `resume` only for same-scope follow-up rounds; open a new session when scope changes
- The review runs non-interactively and returns structured feedback
- Treat the review as advisory — not all suggestions need to be applied
- Do not report nitpicks unless the user explicitly asks for fine-grained style feedback
- Keep focus on correctness, safety, and regressions over code-style preferences

## Waiver Template (Claude -> Codex)

If Claude chooses not to apply a review suggestion, provide a waiver so the decision is explicit:

```text
WAIVER
- Finding: <short finding title>
- Why not fixed now: <constraint or rationale>
- Risk assessment: <why acceptable for now>
- Evidence/mitigation: <tests, guardrails, monitoring, or code references>
- Follow-up: <issue link or concrete next action, or "none">
```

Use waivers for intentional tradeoffs, false positives, out-of-scope requests, or changes that would create disproportionate risk/churn.

## Help

!`codex exec review --help`
