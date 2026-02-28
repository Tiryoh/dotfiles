#!/usr/bin/env python3
"""
Static analysis for AGENTS.md / CLAUDE.md context files.
Outputs JSON with quantitative signals for the review skill.
"""

import json
import os
import re
import sys
from pathlib import Path
from difflib import SequenceMatcher


def find_context_file(root: Path) -> Path | None:
    """Find the primary context file in the repo root."""
    candidates = [
        "AGENTS.md", "agents.md",
        "CLAUDE.md", "claude.md",
        "COPILOT.md", "copilot.md",
        ".github/AGENTS.md", ".github/CLAUDE.md",
    ]
    for name in candidates:
        p = root / name
        if p.is_file():
            return p
    return None


def find_doc_files(root: Path) -> dict[str, str]:
    """Collect existing documentation content."""
    docs = {}
    for name in ["README.md", "readme.md", "CONTRIBUTING.md", "contributing.md"]:
        p = root / name
        if p.is_file():
            docs[name] = p.read_text(errors="replace")
    docs_dir = root / "docs"
    if docs_dir.is_dir():
        for f in docs_dir.rglob("*.md"):
            rel = str(f.relative_to(root))
            try:
                docs[rel] = f.read_text(errors="replace")
            except Exception:
                pass
    return docs


def parse_sections(text: str) -> list[dict]:
    """Split markdown into sections by headings."""
    lines = text.split("\n")
    sections = []
    cur_heading = "(preamble)"
    cur_level = 0
    cur_lines: list[str] = []

    for line in lines:
        m = re.match(r"^(#{1,6})\s+(.+)", line)
        if m:
            if cur_lines or cur_heading != "(preamble)":
                body = "\n".join(cur_lines).strip()
                if body or cur_heading != "(preamble)":
                    sections.append({
                        "heading": cur_heading,
                        "level": cur_level,
                        "body": body,
                        "word_count": len(body.split()),
                    })
            cur_heading = m.group(2).strip()
            cur_level = len(m.group(1))
            cur_lines = []
        else:
            cur_lines.append(line)

    body = "\n".join(cur_lines).strip()
    if body or cur_heading != "(preamble)":
        sections.append({
            "heading": cur_heading,
            "level": cur_level,
            "body": body,
            "word_count": len(body.split()),
        })
    return sections


def count_dir_paths(text: str) -> list[str]:
    """Detect directory-style path references."""
    return re.findall(r'`?(?:[\w.-]+/){1,}[\w.-]*`?', text)


def overlap_ratio(a: str, b: str) -> float:
    """Compute text similarity ratio between two strings."""
    if not a or not b:
        return 0.0
    return SequenceMatcher(None, a.lower().split(), b.lower().split()).ratio()


def detect_overview_keywords(heading: str) -> bool:
    """Check if a section heading suggests a codebase overview."""
    kw = [
        "overview", "architecture", "structure", "directory",
        "project layout", "codebase", "modules", "components",
        "folder", "organization", "high-level", "how it works",
    ]
    h = heading.lower()
    return any(k in h for k in kw)


def detect_vague_content(body: str) -> list[str]:
    """Find vague guideline phrases."""
    patterns = [
        r"write clean code",
        r"follow best practices",
        r"maintain.*quality",
        r"keep.*simple",
        r"use descriptive names",
        r"write meaningful",
        r"ensure.*readability",
        r"strive for",
        r"aim to",
        r"try to keep",
        r"should be well",
        r"make sure.*good",
    ]
    found = []
    low = body.lower()
    for p in patterns:
        if re.search(p, low):
            found.append(p)
    return found


def detect_excessive_requirements(body: str) -> list[str]:
    """Find overly broad mandatory requirements."""
    patterns = [
        r"always run (?:the )?(?:full|entire|complete) test",
        r"update all (?:related )?documentation",
        r"run (?:the )?full (?:ci|pipeline|suite)",
        r"must (?:always )?update.*changelog",
        r"ensure 100% (?:test )?coverage",
        r"always create.*(?:unit )?tests? for every",
    ]
    found = []
    low = body.lower()
    for p in patterns:
        if re.search(p, low):
            found.append(p)
    return found


def detect_actionable_tooling(body: str) -> list[str]:
    """Find concrete tool/command instructions."""
    cmds = re.findall(r'`([a-zA-Z][\w.-]+(?: [\w./<>-]+)*)`', body)
    tool_kw = re.findall(
        r'\b(?:uv|pip|poetry|pdm|npm|pnpm|yarn|make|cargo|gradle|maven'
        r'|pytest|ruff|black|mypy|flake8|eslint|prettier|tox'
        r'|docker|podman|nox|pre-commit)\b',
        body, re.IGNORECASE
    )
    return list(set(cmds + tool_kw))


def analyze(root: Path) -> dict:
    ctx_path = find_context_file(root)
    if ctx_path is None:
        return {"error": "No context file found", "found": False}

    text = ctx_path.read_text(errors="replace")
    sections = parse_sections(text)
    docs = find_doc_files(root)

    words = text.split()
    total_words = len(words)
    total_sections = len(sections)
    dir_paths = count_dir_paths(text)

    # Per-section analysis
    section_reports = []
    for sec in sections:
        body = sec["body"]
        heading = sec["heading"]
        report = {
            "heading": heading,
            "word_count": sec["word_count"],
            "signals": {},
        }
        report["signals"]["is_overview"] = detect_overview_keywords(heading)
        report["signals"]["vague_phrases"] = detect_vague_content(body)
        report["signals"]["excessive_reqs"] = detect_excessive_requirements(body)
        report["signals"]["actionable_tools"] = detect_actionable_tooling(body)
        report["signals"]["dir_paths_found"] = count_dir_paths(body)

        # Overlap with each doc file
        overlaps = {}
        for doc_name, doc_text in docs.items():
            r = overlap_ratio(body, doc_text)
            if r > 0.15:
                overlaps[doc_name] = round(r, 3)
        report["signals"]["doc_overlaps"] = overlaps

        section_reports.append(report)

    # Global overlap
    max_overlap = 0.0
    max_overlap_file = ""
    for doc_name, doc_text in docs.items():
        r = overlap_ratio(text, doc_text)
        if r > max_overlap:
            max_overlap = r
            max_overlap_file = doc_name

    result = {
        "found": True,
        "file": str(ctx_path.relative_to(root)),
        "total_words": total_words,
        "total_sections": total_sections,
        "benchmark": {"avg_words": 641, "avg_sections": 9.7},
        "dir_path_count": len(dir_paths),
        "dir_paths_sample": dir_paths[:10],
        "max_readme_overlap": round(max_overlap, 3),
        "max_overlap_file": max_overlap_file,
        "sections": section_reports,
    }
    return result


def main():
    root = Path(os.environ.get("REPO_ROOT", ".")).resolve()
    # Walk up to find .git if needed
    if not (root / ".git").exists():
        for parent in root.parents:
            if (parent / ".git").exists():
                root = parent
                break

    result = analyze(root)
    print(json.dumps(result, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
