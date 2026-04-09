#!/usr/bin/env bash
# Launch Claude Code from the project root with .env loaded.
# Usage: ./start.sh [claude args...]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [[ ! -f .env ]]; then
  echo "ERROR: .env not found in $SCRIPT_DIR" >&2
  exit 1
fi

# Export all vars from .env (skip blanks and comments)
set -a
# shellcheck disable=SC1091
source .env
set +a

# Verify tokens are populated
if [[ -z "${SLACK_MCP_XOXC_TOKEN:-}" || -z "${SLACK_MCP_XOXD_TOKEN:-}" ]]; then
  echo "WARNING: Slack tokens not set in .env" >&2
  echo "Run: SLACK_SAFE_STORAGE_PASSWORD='...' uv run tars-support/scripts/extract-slack-tokens.py" >&2
fi

exec claude "$@"
