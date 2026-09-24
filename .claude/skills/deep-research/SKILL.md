---
name: deep-research
description: Research a topic in depth on the web and write a fully cited report. Use when the user asks to research, investigate, or deep-dive a question and wants a written report as the result.
argument-hint: "<question or topic> [--depth quick|standard|deep]"
---

# Deep Research

You are the lead researcher. Your job is to turn the user's question into a well-sourced, well-structured report saved on disk. You coordinate; the `web-researcher`, `report-writer`, and `fact-checker` subagents do the heavy reading and writing so your own context stays clean.

Request: $ARGUMENTS

## Settings

Read the depth from the request (`--depth quick|standard|deep`). If none is given, use `standard`.

| Depth    | Sub-questions | Research rounds | Fact-check |
|----------|---------------|-----------------|------------|
| quick    | 3             | 1               | no         |
| standard | 5             | up to 2         | yes        |
| deep     | 7–8           | up to 3         | yes        |

## Workspace

Create one folder per run: `research/<YYYY-MM-DD>-<short-slug>/` (use today's date and a 3–6 word kebab-case slug of the topic). Everything for the run goes there:

```
research/<run>/
  brief.md          # the question, scope, and research plan
  notes/NN-<slug>.md  # one file per sub-question, written by web-researcher
  report.md         # the final report, written by report-writer
  fact-check.md     # verification results, written by fact-checker
```

## Step 1: Scope the question

Work out what a great answer would need to cover: the core question, the likely audience, the time frame that matters, and any terms that need defining. If the request is truly ambiguous in a way that would change the whole report (for example, "Apple" the company or the fruit), ask one short clarifying question. Otherwise make sensible assumptions and write them down.

## Step 2: Plan

Break the question into distinct sub-questions (count from the table above). Good sub-questions:

- don't overlap, and together cover the whole question
- mix angles: background and definitions, current state and data, key players, competing views or evidence against, recent developments, implications or outlook
- are specific enough that a web search can answer them

Write `brief.md` with: the original request, your stated assumptions, the intended audience, and the numbered list of sub-questions, each with a line on why it matters.

## Step 3: Research, in parallel

Launch one `web-researcher` subagent per sub-question, **all in a single message** so they run at the same time. Give each one:

- the overall question (for context) and its one sub-question
- the exact notes path to write: `research/<run>/notes/NN-<slug>.md`
- anything the other researchers are covering, so it doesn't duplicate them

Each researcher returns a short summary. Don't re-read their notes files in full yourself; the summaries are enough to steer.

## Step 4: Find the gaps (standard and deep only)

Read the summaries and ask:

- Which parts of the original question are still weakly answered?
- Where do sources disagree, and would another source settle it?
- Did anything important and unexpected come up that deserves its own look?
- Is any key claim resting on a single weak source?

If there are real gaps and rounds remain, add new sub-questions to `brief.md` (continue the numbering) and launch another parallel batch of `web-researcher` subagents. Stop when the gaps are minor or the round limit is reached. Don't research for the sake of it.

## Step 5: Write the report

Launch one `report-writer` subagent. Tell it the run folder path and the depth. It reads `brief.md` and every file in `notes/`, then writes `report.md`.

## Step 6: Fact-check (standard and deep only)

Launch one `fact-checker` subagent with the run folder path. It checks the report's claims against the notes and the original sources and writes `fact-check.md`.

If it finds problems, fix `report.md` yourself using its suggested corrections: soften, correct, or remove each flagged claim, and keep the citation numbering consistent. Add a one-line note at the end of the report's Methodology section saying how many claims were checked and corrected.

## Step 7: Hand off

Reply to the user with:

- the path to `report.md`
- the report's key findings, in three to five bullets
- anything important you could not establish, and why

Keep this reply short. The report is the deliverable.
