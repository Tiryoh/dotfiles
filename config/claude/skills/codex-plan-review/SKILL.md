---
name: codex-plan-review
description: Review coding and implementation plans with Codex before coding starts. Use when the user asks to validate a plan, task breakdown, migration strategy, rollout approach, testing strategy, or risk assessment, especially for plans produced by Claude Code that need stricter quality gates.
---

<!--
Example prompts:
  /codex-plan-review Review this implementation plan before coding
  /codex-plan-review Check this rollout and migration plan for risks
  /codex-plan-review Validate Claude's coding plan and list blockers
-->

You are a planning review coordinator. When invoked, use Codex CLI to review plan quality, not code style.

## Default Prompt (No Nits)

When no custom guidance is provided, use this prompt:

```text
Review this coding plan for meaningful risks and missing work only. Prioritize Critical and High issues: incorrect architecture assumptions, missing dependency sequencing, unsafe migration/rollout, missing rollback strategy, missing test coverage for high-risk paths, observability gaps, or unclear acceptance criteria that can cause delivery failure. Ignore nits: wording, naming, formatting, and minor stylistic preferences.
```

## How to Run

### Review a plan in the repository

```bash
codex exec "Review plan at docs/implementation-plan.md. Use Critical/High severity only. Ignore nits. Provide blockers, required tests, rollout/rollback gaps, and a ship/no-ship verdict."
```

### Review plan text from Claude directly

```bash
cat <<'EOF' | codex exec -
Review this coding plan with Critical/High severity focus only. Ignore nits.
Return blockers, risk hotspots, missing tests, and go/no-go verdict.

<PASTE_PLAN_TEXT_HERE>
EOF
```

### Continue the same objective with context

```bash
codex exec resume --last "Continue plan review. No nits. Focus on unresolved Critical/High risks and verify if the revised plan closes them."
```

Use `resume` only when the objective is unchanged (same feature/plan and acceptance criteria). Start a new session when scope changes significantly.

## Workflow

1. Determine scope and constraints: plan objective, non-goals, deadlines, risk tolerance.
2. Run Codex plan review with the default prompt (unless user gives custom criteria).
3. Classify findings by severity and show Critical/High first.
4. Send findings back to Claude Code for plan revision.
5. Repeat review -> revise -> review until the gate passes or user stops.
6. Require a waiver entry for each intentionally unresolved Critical/High item.

## Quality Gate

Treat the plan as ready only when all conditions are met:

- No unresolved Critical issues
- No unresolved High issues without an explicit waiver
- Test strategy exists for risky paths
- Rollout and rollback strategy is defined for production-impacting changes
- Acceptance criteria are concrete enough to verify completion

## Output Format

Use this structure when reporting results:

```text
VERDICT: GO | NO-GO

CRITICAL
- <issue>

HIGH
- <issue>

REQUIRED TESTS / VALIDATION
- <required test or check>

ROLLOUT / ROLLBACK GAPS
- <gap>

OPEN QUESTIONS
- <question>
```

## Waiver Template (Claude -> Codex)

If Claude chooses not to address a Critical/High finding immediately, require:

```text
WAIVER
- Finding: <short title>
- Why not fixed now: <constraint or rationale>
- Risk assessment: <why acceptable for now>
- Mitigation: <guardrail, monitoring, staged rollout, or test>
- Follow-up: <issue link or concrete next action, or "none">
```

## Scope Boundary

Use `codex-review` for code diff/commit review. Use this skill for pre-implementation planning quality.
