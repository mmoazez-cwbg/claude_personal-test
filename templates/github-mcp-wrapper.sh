#!/bin/bash
# GitHub MCP wrapper — loads PAT from .env
# See: https://github.com/github/github-mcp-server

PROJECT_DIR="/PATH/TO/YOUR/PROJECT"

source "$PROJECT_DIR/.env"

exec docker run -i --rm \
  -e GITHUB_PERSONAL_ACCESS_TOKEN \
  "ghcr.io/github/github-mcp-server"
