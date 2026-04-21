# Evaluation Criteria — Based on Gloaguen et al. (2026)

Paper: "Evaluating AGENTS.md: Are Repository-Level Context Files Helpful for Coding Agents?"
arXiv:2602.11988 — Accepted at ICML 2026

## Key Empirical Findings

### 1. LLM-generated context files reduce performance
- Average resolution rate drops by 0.5% (SWE-bench Lite) and 2% (AGENTbench)
- Inference cost increases by 20-23% on average
- Average step count increases by 2.45-3.92 steps per task

### 2. Developer-written context files provide marginal improvement
- Average +4% improvement over no context file
- But still increase cost by up to 19%
- Outperform LLM-generated files in all settings

### 3. Codebase overviews are ineffective
- 8/12 repos in AGENTbench included overviews; no improvement in file discovery speed
- 100% of Sonnet-generated, 99% of GPT-generated files contained overviews
- Agents do NOT reach relevant files faster with overviews present

### 4. Context files are redundant with existing docs
- When all docs (README, docs/) were removed, context files improved performance by 2.7%
- In normal conditions (docs present), context files duplicate existing information
- This redundancy is the primary source of harm

### 5. Agents faithfully follow instructions
- Tool usage correlates directly with mentions in context files
  - `uv`: 1.6 uses/instance when mentioned vs <0.01 when not
  - repo-specific tools: 2.5 uses vs <0.05
- Unnecessary instructions lead to unnecessary work, not ignored instructions

### 6. More instructions = harder tasks
- Reasoning tokens increase 14-22% with context files (GPT-5.2)
- More testing, more file traversal, more exploration — but not better outcomes

## Derived Classification Rules

### ✅ ACTIONABLE TOOLING — Keep
Content that specifies **concrete commands or tools** the agent should use.
These are the only type of instruction shown to reliably help.

Examples of good content:
- "Use `uv run pytest` to run tests"
- "Lint with `ruff check --fix`"
- "Build docs with `make -C docs html`"
- "Use `pdm` instead of `pip` for dependency management"

Why it works: Agents follow tool instructions faithfully, and repo-specific
tooling is genuinely non-obvious (unlike codebase structure).

### ✅ NON-OBVIOUS CONSTRAINT — Keep
Rules that an agent **cannot reasonably infer** from reading the code.

Examples of good content:
- "Files in `src/generated/` are auto-generated — never edit directly"
- "This project requires Python 3.12+ due to use of type parameter syntax"
- "The `legacy/` module is frozen; changes require approval"
- "Environment variable `DATABASE_URL` must be set for integration tests"

Why it works: This is information not present elsewhere in the repo,
so it genuinely adds to the agent's knowledge.

### ⚠️ REDUNDANT WITH DOCS — Remove
Content that **duplicates** information already in README, CONTRIBUTING, or docs/.

How to detect:
- Direct textual overlap with README.md or CONTRIBUTING.md
- Installation instructions already documented elsewhere
- API usage patterns explained in docs/
- License or contribution guidelines restated

Why it hurts: Adds tokens and processing time without new information.
The paper found LLM-generated files are especially prone to this.

### ⚠️ CODEBASE OVERVIEW — Remove
High-level descriptions of architecture, directory trees, module explanations.

How to detect:
- Section headings: "Overview", "Architecture", "Structure", "Project Layout"
- Lists of directories with descriptions (`src/` — source code, `tests/` — ...)
- Component relationship descriptions
- Technology stack summaries

Why it hurts: Research shows these do NOT help agents navigate to relevant
files faster. Agents discover structure through file exploration equally well.

### ❌ VAGUE GUIDELINE — Remove
Abstract principles that don't map to specific commands or checks.

How to detect:
- "Write clean code", "Follow best practices"
- "Maintain good test coverage", "Keep it simple"
- "Use descriptive variable names"
- Any guideline that can't be verified by a tool

Why it hurts: Agents try to comply but have no concrete action to take,
leading to more "thinking" (14-22% more reasoning tokens) without benefit.

### ❌ EXCESSIVE REQUIREMENT — Remove
Rules that impose unnecessary work for most routine tasks.

How to detect:
- "Always run the full test suite before submitting"
- "Update all related documentation for every change"
- "Ensure 100% test coverage"
- "Always create unit tests for every function modified"

Why it hurts: Agents faithfully follow these, causing dramatically more
steps and cost per task. The paper showed testing calls increase
significantly with context files, often without improving outcomes.
