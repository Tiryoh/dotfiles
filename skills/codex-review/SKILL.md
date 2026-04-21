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

### Review with custom instructions (standalone only)

`[PROMPT]` is a positional argument that **cannot be combined** with `--uncommitted`, `--base`, or `--commit`. When no scope flag is needed:

```bash
codex exec review "Focus on error handling and edge cases"
```

## Default Review Criteria (No Nits)

**Important**: `[PROMPT]` and scope flags (`--uncommitted`, `--base`, `--commit`) are mutually exclusive. When using scope flags, run them without a prompt argument:

```bash
codex exec review --uncommitted
codex exec review --base <branch>
codex exec review --commit <SHA>
```

After receiving Codex output, Claude must filter and present findings using these criteria:

- **Report only** Critical and High severity issues: incorrect behavior, regressions, security problems, data loss/corruption, significant performance issues, or broken tests
- **Ignore nits**: style preferences, naming bikeshedding, formatting, minor refactors, and speculative improvements unless directly tied to a real defect
- If the user provides custom review criteria, use those instead

## Session Continuity (`resume`)

Use `resume` only when continuing the same review objective (same PR/branch and same acceptance criteria). Unlike `review`, `resume` **accepts a `[PROMPT]` argument** — use this to pass review criteria that cannot be provided during the initial `review` invocation with scope flags.

Preferred pattern:

```bash
codex exec resume --last "Review only meaningful defects. Prioritize Critical and High severity issues that can cause incorrect behavior, regressions, security problems, data loss/corruption, significant performance issues, or broken tests. Ignore nits: style preferences, naming bikeshedding, formatting, minor refactors, and speculative improvements unless they are directly tied to a real defect."
```

Rules:

- Use `codex resume` or `codex exec resume` (not `codex --resume`)
- Pass the default No Nits prompt (or user's custom criteria) as the `[PROMPT]` argument on resume
- Start a new session when scope changes significantly (different branch, changed requirements, major new diff)

## Workflow

1. **Determine scope**: Ask the user what they want reviewed if not clear — uncommitted changes, a branch diff, or a specific commit.
2. **Enforce Codex review**: When called from Claude Code, always use `codex exec review` for the review pass. Do not rely on Claude-only self-review.
3. **Resolve base branch robustly**: For branch-diff reviews, prefer a base branch provided by Claude Code, then validate it with `git`. If missing/invalid, fall back to default-branch detection. If still unresolved, ask the user.
4. **Select session mode**: Use a fresh session by default; use `resume` only if the objective is unchanged and continuity adds value.
5. **Run the review**: Execute `codex exec review` with the appropriate scope flag (no prompt argument). Apply the default review criteria when presenting findings.
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

Run `codex exec review --help` for full usage details.
