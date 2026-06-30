# Efficiency Protocol for Claude Code

🌍 **English** · [Español](README.md)

A token-saving system for Claude Code on large projects — that also turns it into a full developer toolkit. It cuts your bill by delegating code exploration to cheap subagents with isolated context, trims needless narration, and keeps the fixed context loaded each session lean. On top of that, it adds superpowers: persistent project memory, phone control, security auditing, tests, commits, and voice.

## Pieces

| File | Destination | What it does |
|---|---|---|
| `agents/explorador.md` | `~/.claude/agents/` | Exploration subagent on Haiku (~5× cheaper). Returns only conclusions and paths (`path:line`), never file dumps. |
| `agents/revisor.md` | `~/.claude/agents/` | Review subagent on Sonnet. Findings sorted by severity; the intermediate work (diffs, reads, tests) is discarded outside the main context. |
| `skills/ahorro/SKILL.md` | `~/.claude/skills/ahorro/` | `/ahorro` command: audits the weight of fixed context and active MCPs, and recommends the highest-impact action. |
| `skills/arranque/SKILL.md` | `~/.claude/skills/arranque/` | `/arranque` command: prepares a new project (detects the stack, creates a local `.claude/settings.json`, generates a short CLAUDE.md, and offers a knowledge graph). |
| `skills/movil/SKILL.md` + `bin/movil.sh` | `~/.claude/…` | `/movil` command: Claude **sees and controls** your Android phone over USB (screenshot + tap/type/swipe). Works on any Android; also builds and tests apps on the real device. |
| `skills/memoria/SKILL.md` | `~/.claude/skills/memoria/` | `/memoria` command: **persistent project memory** (`.claude/memoria/`) — a code map index plus decisions, conventions, and to-dos. Scales to any size (stores summaries) and auto-loads every session. |
| `skills/seguridad/SKILL.md` + `bin/seguridad.sh` | `~/.claude/…` | `/seguridad` command: **defensive** audit before pushing to git — leaked secrets/credentials, sensitive files under version control, and vulnerable dependencies. |
| `skills/commit/SKILL.md` | `~/.claude/skills/commit/` | `/commit` command: analyzes the diff and writes a clear **Conventional Commits** message, then creates the commit (no push). |
| `skills/pruebas/SKILL.md` + `bin/pruebas.sh` | `~/.claude/…` | `/pruebas` command: detects the framework (npm/pytest/cargo/go/flutter), runs the tests, and **generates the missing ones**. |
| `skills/voz/SKILL.md` + `bin/voz.sh` | `~/.claude/…` | `/voz` command: gives EMMA a voice — reads responses aloud using the system's TTS engine (hands-free). |
| `skills/super/SKILL.md` | `~/.claude/skills/super/` | `/super` command: max-capability mode on a trusted project — a broad allowlist to work without permission interruptions, while keeping destructive commands blocked. |
| `skills/ultra/SKILL.md` | `~/.claude/skills/ultra/` | `/ultra` command: advanced engineering mode — multi-perspective analysis, decomposition, clean modular code, and verified, ready-to-apply delivery. |
| `CLAUDE-snippet.md` | paste into `~/.claude/CLAUDE.md` | Permanent rules: delegate explorations of >3 files, stay quiet between tools, surgical reads, brief summaries. |

## Installation (a single command)

```bash
git clone https://github.com/juanmanuel767/protocolo-eficiencia.git
cd protocolo-eficiencia
./install.sh
```

That's it. The installer is **idempotent** (safe to run multiple times, never duplicates anything) and installs:

- The `explorador` and `revisor` subagents.
- The skills `/arranque`, `/ahorro`, `/memoria`, `/movil`, `/seguridad`, `/commit`, `/pruebas`, `/voz`, `/super`, and `/ultra`.
- The efficiency rules in `~/.claude/CLAUDE.md` (only if not already there).
- An **auto-activation hook** (`SessionStart`): when you open any **new, unconfigured project**, Claude runs `/arranque` automatically and applies the protocol — no need to ask.
- **`adb` installed and authorized** (`Bash(adb *)` in `settings.json`): the `/movil` skill is ready so Claude can **see and control your Android** over USB without prompting for permission at every step.
- A **voice engine** (`espeak-ng`) installed if missing, so `/voz` works out of the box.
- A **welcome manual** shown once on the next start, explaining what each piece does.

To revert everything: `./uninstall.sh`.

> Restart Claude Code after installing so it loads the agents, skills, and hook.

Optional: merge `settings-snippet.json` into your `~/.claude/settings.json` for a read-only command allowlist and remove permission interruptions.

## Usage

| Command | When |
|---|---|
| `/arranque` | First thing when opening a new project. Leaves it configured for maximum efficiency. |
| `/ahorro` | Anytime, to audit the session's spend and get the highest-impact recommendation. |
| `/memoria` | On large or long-running projects, so Claude never loses the thread. |
| `/movil` | To have Claude see and control your Android, automate tasks, or test apps on a real device. |
| `/seguridad` | Before any push or release, to catch leaks and vulnerabilities. |
| `/commit` | To turn your diff into a clean conventional commit. |
| `/pruebas` | To run the tests and generate the missing ones. |
| `/voz` | For spoken responses, hands-free. |
| `/super` · `/ultra` | Max-capability mode and advanced engineering mode. |
| (automatic) | The `explorador` and `revisor` subagents are invoked on their own per the `CLAUDE-snippet.md` rules; you can also call them explicitly. |

## Habits that complete the system

- `/compact` at natural pauses in long tasks; `/clear` when switching topics.
- Specific prompts: a vague request costs a whole expedition of reads.
- Disable MCP servers that don't apply to the session's work.
- On large projects, generate a knowledge graph (e.g. graphify) and query it instead of re-reading files.

## Why it works

- **Isolated context:** a subagent reads 20 files and returns 200 words; those 20 reads never weigh on your main conversation.
- **Right model per task:** exploring with Haiku and reviewing with Sonnet costs a fraction of doing it all with the main model.
- **Lean fixed context:** every token in CLAUDE.md is paid in *every* message of *every* session. Keeping it short is the saving that compounds the most.

## License

MIT — see [LICENSE](LICENSE). Use it in your commercial projects.
