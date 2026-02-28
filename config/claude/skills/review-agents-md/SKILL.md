---
name: review-agents-md
description: >
  Review AGENTS.md / CLAUDE.md context files for coding agents.
  Use when reviewing, auditing, or improving repository context files,
  or when the user mentions AGENTS.md, CLAUDE.md, or context file quality.
---

# Review AGENTS.md

Evaluate the repository's context file (AGENTS.md, CLAUDE.md, COPILOT.md, etc.)
based on empirical findings from "Evaluating AGENTS.md" (Gloaguen et al., 2026).

## Background

Research shows that context files often **hurt** agent performance:

- LLM-generated context files reduce success rates by ~2% on average
- All context files increase inference cost by 20%+
- Agents faithfully follow instructions, so unnecessary rules cause wasted work
- Codebase overviews do NOT help agents find relevant files faster
- Redundant documentation (overlap with README/docs) is the main problem
- Only **minimal, actionable, non-obvious requirements** provide value

## Step 1 — Run the analysis script

Run the bundled analysis script to collect quantitative signals:

```bash
python3 "$(dirname "$0")/analyze.py"
```

Read the JSON output. This gives you word counts, section counts,
directory path density, and overlap ratio with README.

## Step 2 — Classify each section

For every section in the context file, assign ONE category:

| Emoji | Category               | Verdict | Description |
|-------|------------------------|---------|-------------|
| ✅    | ACTIONABLE TOOLING     | Keep    | Specific tool/command instructions (e.g. "use `uv run pytest`", "lint with `ruff check`") |
| ✅    | NON-OBVIOUS CONSTRAINT | Keep    | Rules an agent cannot infer from code alone (e.g. "never edit `src/gen/`", "requires Python 3.12+") |
| ⚠️    | REDUNDANT WITH DOCS    | Remove  | Already in README.md, CONTRIBUTING.md, or docs/ |
| ⚠️    | CODEBASE OVERVIEW      | Remove  | Architecture description, directory listing, module explanation |
| ❌    | VAGUE GUIDELINE        | Remove  | Abstract principles without concrete commands ("write clean code") |
| ❌    | EXCESSIVE REQUIREMENT  | Remove  | Rules that add unnecessary work for most tasks ("always run full test suite") |

Refer to `references/paper-criteria.md` in this skill folder for detailed
rationale behind each category.

## Step 3 — Produce the report

Output a structured report in this exact format:

```
## AGENTS.md Review Report

### Summary
- File: <filename and path>
- Word count: <N> (benchmark avg: 641)
- Sections: <N> (benchmark avg: 9.7)
- README overlap: <N%>
- Actionable ratio: <✅ sections / total sections>
- Verdict: LEAN ✅ | NEEDS TRIMMING ⚠️ | OVERLOADED ❌

### Section-by-Section Analysis

#### <Section heading>
- Category: <emoji + category name>
- Content summary: <1-line summary>
- Issue: <specific problem, or "None">
- Redundant with: <file:section if applicable, or "N/A">

(repeat for each section)

### Redundancy Details
- Overlapping with README.md: <list>
- Overlapping with CONTRIBUTING.md: <list>
- Overlapping with docs/: <list>

### Recommended Changes

#### 🗑️ Remove
- <content to remove> — <reason>

#### ✅ Keep
- <content to keep> — <why it's valuable>

#### ✏️ Rewrite (vague → actionable)
- BEFORE: <original text>
- AFTER:  <suggested rewrite>
```

## Verdict criteria

- **LEAN ✅**: Actionable ratio ≥ 70%, word count ≤ 800, README overlap ≤ 20%
- **NEEDS TRIMMING ⚠️**: Actionable ratio 40-69%, or word count 801-1200, or overlap 21-40%
- **OVERLOADED ❌**: Actionable ratio < 40%, or word count > 1200, or overlap > 40%

## Important

- Be specific. Quote exact lines when flagging issues.
- For "Rewrite" suggestions, always provide concrete replacement text.
- If no context file exists, say so and offer to generate a minimal one
  containing ONLY actionable tooling instructions discovered from the repo.
