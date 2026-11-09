# AI-ready project template (Claude Code, Cursor, Codex, Antigravity, Copilot)

A skeleton for starting a new project already set up to work with AI: a short `AGENTS.md` shared by
every tool, *progressive disclosure* of technical rules, a 00–99 docs model, "the code wins",
a session log and reusable slash commands.

It is not tied to any company, stack or cloud: everything project-specific is a `{{...}}` placeholder
that `/configure` fills in by reading your code or asking you.

## Create a new project

Clone this repository anywhere, then from its folder:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\new-project.ps1
```

The script asks for the project name and the parent folder (default: the folder that contains the
template). To skip the questions, pass them: `-Name "MyProject" -Destination "D:\code"`.
`-NoGit` skips `git init`.

Then open your AI tool in the new folder and run `/configure`: it reads the code (if any) or asks
you, fills in the `{{...}}` in `AGENTS.md` and `agent_docs/`, and removes the folders of tools you won't use.

## Structure

```text
MyProject/
├── AGENTS.md              ← LAYER 1: universal rules (< 60 lines). Single source for every tool
├── CLAUDE.md              ← one line: @AGENTS.md
├── .agents/
│   ├── skills/            ← LAYER 3 SOURCE: /configure /catchup /spec /implement /review-changes /diagnose /adr /wrap-up
│   ├── rules/             ← Antigravity: points to AGENTS.md
│   └── workflows/         ← Antigravity: GENERATED from skills/
├── .claude/
│   ├── settings.json      ← shared permissions: git reads free, commit/push ask, .env blocked
│   ├── agents/            ← SOURCE of the read-only subagents: reviewer, auditor, researcher
│   └── skills/            ← GENERATED from .agents/skills (+ Claude-only skills you add)
├── .cursor/
│   ├── rules/             ← one rule that points to AGENTS.md
│   ├── commands/          ← GENERATED from .agents/skills
│   └── mcp.json.example
├── .github/
│   ├── copilot-instructions.md ← points to AGENTS.md
│   └── agents/            ← GENERATED from .claude/agents (Copilot custom agents)
├── .vscode/mcp.json.example   ← Copilot MCP
├── .codex/config.toml.example ← Codex MCP
├── .mcp.json.example      ← Claude Code MCP (credentials via environment variables)
├── scripts/sync-agents.ps1 ← copies the sources to each tool's folder
├── agent_docs/            ← LAYER 2 technical: one file per topic (architecture, conventions, environment)
├── docs/                  ← LAYER 2 product: 00–99 model
│   ├── 00_context/        ← original request, vision, glossary, decisions (ADR)
│   ├── 01_functional/     ← analysis, stories + status
│   ├── 02_technical/      ← architecture + status (debt, risks)
│   ├── 03_management/     ← changelog + tickets
│   └── 99_ai/             ← conventions for working with AI + session-log
├── specs/                 ← one spec per large task (created by /spec)
└── src/
```

## Why it's built this way

| Decision | Reason |
| :--- | :--- |
| Short `AGENTS.md` + a `CLAUDE.md` that imports it | One source for every tool. A file that is always loaded and keeps growing degrades answers: past a few hundred lines, rules get followed less reliably |
| `agent_docs/` by **topic**, not by story | Each story's history shouldn't load in every session; it goes in `docs/01_functional/stories/` |
| `docs/` separate from `agent_docs/` | `docs/` is for people and the AI (what and why); `agent_docs/` are rules for writing code |
| Skills instead of copy-pasted prompts | The same flow every time and in every tool, no pasting |
| Read-only subagents | They review and research without filling the main context or editing |
| Disposable `specs/` | A task's context doesn't pollute the permanent rules |
| `session-log.md` | Pick up the next day with `/catchup` without rereading transcripts |
| `settings.json` committed, `settings.local.json` not | Team permissions are shared; yours don't clutter the repo |

Command names avoid Claude Code's built-ins (`/review`, `/plan`, `/resume`, `/bug`).

## One source, five tools

Every tool reads `AGENTS.md`, directly or through a one-line pointer. Skills and subagents are
**edited in one place** and copied with:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-agents.ps1
```

| | Rules | Slash commands | Subagents | MCP |
| :--- | :--- | :--- | :--- | :--- |
| Claude Code | `CLAUDE.md` → `AGENTS.md` | `.claude/skills/` (generated) | `.claude/agents/` (source) | `.mcp.json` |
| Cursor | `AGENTS.md` + `.cursor/rules/` | `.cursor/commands/` (generated) | — | `.cursor/mcp.json` |
| Codex | `AGENTS.md` | `.agents/skills/` (source, native) | — | `~/.codex/config.toml` |
| Antigravity | `.agents/rules/` → `AGENTS.md` | `.agents/workflows/` (generated) | — | global settings |
| Copilot | `AGENTS.md` + `.github/copilot-instructions.md` | `.agents/skills/` (source, native) | `.github/agents/` (generated) | `.vscode/mcp.json` |

Generated files start with a `GENERATED` comment: never edit them, edit the source and re-run the script.
Where a tool has no subagents, the skills tell it to follow `.claude/agents/reviewer.md` itself.
These folder conventions change often (especially Antigravity and Copilot CLI): check each tool's docs
when something isn't picked up.

## Multi-repo project

Use this template as the **workspace root folder** (the one containing the sibling repos). Each repo
gets only its own short `AGENTS.md` + `CLAUDE.md` (`@AGENTS.md`) and its `agent_docs/`. `docs/`,
`specs/`, `.agents/` and the generated tool folders stay at the root, and sessions are opened from there.

## Lifecycle

- **Day 1:** `/configure`, paste the business ask into `docs/00_context/request.md`, fill in `vision.md`
  and `glossary.md`, then `docs/01_functional/analysis.md` and the first stories.- **Every task:** `/catchup` → `/spec` → `/implement` → `/review-changes` → `/wrap-up`.
- **Every week:** check that `AGENTS.md` is still under 60 lines. If a pattern repeated 3 times,
  turn it into a skill in `.agents/skills/` and run `scripts/sync-agents.ps1`.
