#!/usr/bin/env bash
# Run a deep-research job headlessly with your Claude login (no API key needed).
# Usage: ./research.sh "your question" [--depth quick|standard|deep]
set -euo pipefail

if [ $# -eq 0 ]; then
  echo "Usage: $0 \"your question\" [--depth quick|standard|deep]" >&2
  exit 1
fi

cd "$(dirname "$0")"
# --allowedTools is passed explicitly because headless runs ignore project
# settings until the folder has been trusted in an interactive session.
exec claude -p "/deep-research $*" \
  --permission-mode acceptEdits \
  --allowedTools "WebSearch,WebFetch,Read,Glob,Write,Edit"
