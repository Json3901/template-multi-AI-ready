# agent_docs — technical detail on demand

`AGENTS.md` points here with one line per file. The agent reads only the one it needs.
One file per **topic** (not per story). If a file grows past ~300 lines, split it.

| File | When to read it |
| :--- | :--- |
| `architecture.md` | When creating or moving components, layers or endpoints |
| `conventions.md` | When writing new code |
| `local-environment.md` | When running, debugging, or when something fails locally |

Add others as the project needs them (`database.md`, `frontend.md`, `auth.md`, `deploy.md`) plus their line in `AGENTS.md`.
