# Researcher

An AI research assistant that investigates a question in depth on the web and writes a fully cited report.

It runs inside [Claude Code](https://code.claude.com) and uses your normal Claude login. There's no API key, no Python, and nothing to install beyond Claude Code itself.

## How it works

```
your question
   │
   ▼
 1. Scope & plan ─────── breaks the question into 3–8 sub-questions  → brief.md
   │
   ▼
 2. Research ─────────── one web-researcher per sub-question, in parallel,
   │                     each searching, reading sources, and writing notes → notes/*.md
   ▼
 3. Find gaps ────────── looks for weak spots and conflicts, runs more rounds if needed
   │
   ▼
 4. Write ────────────── report-writer synthesizes all notes into one report → report.md
   │
   ▼
 5. Fact-check ───────── fact-checker verifies claims against the sources   → fact-check.md
                         and the lead researcher fixes anything flagged
```

| Piece | File | Role |
|---|---|---|
| `/deep-research` skill | `.claude/skills/deep-research/SKILL.md` | The lead researcher: plans, coordinates, fixes, hands off |
| `web-researcher` agent | `.claude/agents/web-researcher.md` | Researches one sub-question and writes sourced notes |
| `report-writer` agent | `.claude/agents/report-writer.md` | Turns the notes into a structured, cited report |
| `fact-checker` agent | `.claude/agents/fact-checker.md` | Checks the report's claims against its sources |

## Usage

Open Claude Code in this folder (`claude`) and run:

```
/deep-research What are the leading approaches to grid-scale energy storage, and how do their costs compare?
```

Choose a depth with `--depth`:

| Depth | Sub-questions | Research rounds | Fact-check | Report length |
|---|---|---|---|---|
| `quick` | 3 | 1 | no | ~1,000–1,500 words |
| `standard` (default) | 5 | up to 2 | yes | ~2,000–3,500 words |
| `deep` | 7–8 | up to 3 | yes | ~3,500–6,000 words |

```
/deep-research --depth deep How is AI changing K-12 procurement?
```

To run it without the interactive session:

```bash
./research.sh "How is AI changing K-12 procurement?" --depth quick
```

## Output

Each run gets its own folder:

```
research/2026-09-24-grid-scale-energy-storage/
  brief.md        # question, assumptions, research plan
  notes/          # one file of sourced notes per sub-question
  report.md       # the final report
  fact-check.md   # what was verified and what was corrected
```

The report has an executive summary, thematic sections, a section on where the evidence disagrees, implications, limitations, methodology, and a numbered reference list with URLs.

## Permissions

`.claude/settings.json` pre-approves web search, web fetch, and reading and writing inside `research/`, so a run doesn't stop to ask for permission at every step. Nothing else is pre-approved.

## Usage limits

A run uses your Claude plan's usage, not API credits. A `deep` run launches many parallel researchers and reads dozens of pages, so it uses much more than `quick`. Start with `quick` to get a feel for it.

## Customizing

Everything is plain Markdown, so you can edit it directly:

- Change the report structure or length in `report-writer.md`.
- Change which sources researchers prefer in `web-researcher.md`.
- Change the depth levels in the skill's Settings table.
- To use a cheaper model for researchers, add `model: sonnet` to the front matter of `web-researcher.md`.
