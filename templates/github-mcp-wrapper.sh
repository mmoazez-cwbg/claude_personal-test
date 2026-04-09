#!/bin/bash
# Wrapper to run GitHub MCP with token from .env
source /PATH/TO/YOUR/PROJECT/.env
exec docker run -i --rm \
  -e GITHUB_PERSONAL_ACCESS_TOKEN \
  "ghcr.io/github/github-mcp-server"
