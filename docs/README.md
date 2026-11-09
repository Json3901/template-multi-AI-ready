---
id: DOC-README
title: "Documentation map"
type: index
status: active
created: {{DATE}}
updated: {{DATE}}
related: []
---

# Documentation — {{PROJECT}}

**Read this first.** The code is the source of truth; these docs explain the what, the why and the status.

| Folder | Question it answers | Start with |
| :--- | :--- | :--- |
| `00_context/` | What is it and why does it exist? | `request.md` (original ask), `vision.md`, `glossary.md` |
| `00_context/decisions/` | Why was it done this way? (ADR) | `ADR-NNN-*.md` |
| `01_functional/` | What must it do? Analysis, stories and functional status | `analysis.md`, `status.md` |
| `02_technical/` | How is it built? | `architecture.md`, `status.md` |
| `03_management/` | What changed and what's next? | `changelog.md` |
| `99_ai/` | Rules for working with AI, and the session log | `conventions.md`, `session-log.md` |

## Reading order for the AI

1. This file.
2. `01_functional/status.md` and `02_technical/status.md`.
3. Latest entries in `99_ai/session-log.md`.
4. The story and ADRs for the task.

## Conventions

- Every `.md` has frontmatter (`id`, `title`, `type`, `status`, `created`, `updated`, `related`).
- Copy the folder's `_TEMPLATE.md`; don't start from scratch.
- **Definition ≠ status**: stories and ADRs describe; progress goes in `status.md` and `changelog.md`.
- History is never deleted: `status: deprecated` + link to the current one.
- No secrets: variable names only.
