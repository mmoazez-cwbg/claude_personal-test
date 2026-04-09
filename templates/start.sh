#!/usr/bin/env bash
# Launch Claude Code from the project root with .env loaded.
# Usage: ./start.sh [claude args...]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [[ ! -f .env ]]; then
  echo "ERROR: .env not found in $SCRIPT_DIR" >&2
  echo "Copy .env.example to .env and fill in your credentials." >&2
  exit 1
fi

# Export all vars from .env (skip blanks and comments)
set -a
source .env
set +a

exec claude "$@"
