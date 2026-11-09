# {{PROJECT}} — context for AI agents

{{ONE_LINE_DESCRIPTION}}

## Stack
- Frontend: {{FRONTEND}}
- Backend: {{BACKEND}}
- Database: {{DATABASE}}
- Auth: {{AUTH}}

## Commands
- Run: `{{CMD_RUN}}` — the user runs it in their own terminal; the AI only provides the command.
- Build: `{{CMD_BUILD}}`
- Tests: `{{CMD_TEST}}`

## Structure
- `src/` — code
- `docs/` — product: what, why, status (start at `docs/README.md`)
- `agent_docs/` — detailed technical rules by topic (read the relevant one before touching that topic)
- `specs/` — one spec per large task

## Rules
- The code wins: if a document contradicts it, verify in the code and fix the document.
- Cite `file:line` in diagnoses, plans and reviews.
- Large changes: plan first, then code.
- Git: never commit, push or open a PR unless explicitly asked in that turn. Main branch: `{{MAIN_BRANCH}}`.
- Never put secrets in code, docs or chat: variable names only (`.env.example`).
- When closing a task: `/wrap-up` (status, changelog, session-log).

## Detail on demand
- Architecture and layers → `agent_docs/architecture.md`
- Code conventions → `agent_docs/conventions.md`
- Local environment and troubleshooting → `agent_docs/local-environment.md`
- Decisions → `docs/00_context/decisions/`
