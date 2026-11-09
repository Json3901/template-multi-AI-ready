---
id: AI-conventions
title: "How to work with AI on this project"
type: ai-context
status: active
created: {{DATE}}
updated: {{DATE}}
related: []
---

# How to work with AI

## The 4 context layers

| Layer | Loaded | Where | What goes there |
| :--- | :--- | :--- | :--- |
| 1. Always | When a session opens | `AGENTS.md` (via `CLAUDE.md`), memory | Universal rules. < 60 lines |
| 2. On demand | When the task needs it | `agent_docs/`, `docs/` | Technical and product detail |
| 3. Actions | Via `/command` or delegation | `.agents/skills/` (source), `.claude/agents/` | Repeatable workflows |
| 4. Tools | When leaving the repo | `.mcp.json` and each tool's MCP file | DevOps, DB, browser |

**Skills and subagents are edited in one place only** — `.agents/skills/` and `.claude/agents/` — and then
`scripts/sync-agents.ps1` copies them to Claude, Cursor, Antigravity and Copilot. Generated copies say so
in their first lines; never edit them.

**Moving up or down a layer:** whatever you repeat 2+ times in chat moves up (memory → command → `AGENTS.md`).
Whatever in `AGENTS.md` only serves one module or story moves down to `agent_docs/` or `docs/`.

## MCP servers (example: Azure DevOps)

The `*.example` MCP files ship with Azure DevOps as a worked example of wiring one server into every
tool. If you use another tracker or service (GitHub, GitLab, Jira, a database…), replace the entry in
each file following the same pattern, or delete the example files and this section.

Use Microsoft's official server. Remote (`https://mcp.dev.azure.com/{organization}`, Entra ID sign-in,
nothing to install) wherever the tool supports it; local (`npx @azure-devops/mcp`) otherwise.
Requires an Azure DevOps organization backed by Entra ID.

| Tool | Copy | To | Notes |
| :--- | :--- | :--- | :--- |
| Copilot (VS Code) | `.vscode/mcp.json.example` | `.vscode/mcp.json` | Replace `{organization}`; sign in when prompted |
| Claude Code | `.mcp.json.example` | `.mcp.json` | Needs `{client-id}` of an Entra app registration (redirect `http://localhost:3118/callback`) |
| Cursor | `.cursor/mcp.json.example` | `.cursor/mcp.json` | Same app registration, redirect `http://localhost:8787/callback` |
| Codex | `.codex/config.toml.example` | `~/.codex/config.toml` | Local server (remote not supported in Codex) |
| Antigravity | — | IDE MCP settings | Add the same remote URL in its global MCP config |

The app registration (one per company, done by the Entra admin): public client flows enabled, delegated
permission to the "Azure DevOps MCP" API, admin consent. The client id is not a secret; never put a PAT or
secret in these files. To limit what the agent can do, use the `X-MCP-Toolsets` / `X-MCP-Readonly` headers
(example in `.vscode/mcp.json.example`).

Team conventions for work items (area, iteration, states, linking PRs) go in a skill,
`.agents/skills/azure-devops/SKILL.md`, then `scripts/sync-agents.ps1`.

Source: Microsoft Learn — "Azure DevOps remote MCP server".

## Task flow

`/catchup` → `/spec <task>` → (your OK) → `/implement SPEC-…` → `/review-changes` → `/wrap-up`

- Bugs: `/diagnose <description>`
- Decisions: `/adr <topic>`

## How to ask

1. What, where, and "done means…" (verifiable criteria).
2. Name the story, spec or ADR: it's the shortcut to the context.
3. Plan before code for large changes.
4. Bugs with evidence: steps, expected/actual, error, request/response without tokens.
5. Correct the AI on the spot and say why: it stays in memory.
6. One session per topic; when you stop, `/wrap-up`.

## What never goes in any AI file

Passwords, tokens, connection strings with values, personal data.
