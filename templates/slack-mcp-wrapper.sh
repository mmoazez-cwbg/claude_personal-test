#!/bin/bash
# Auto-refresh Slack tokens from keychain before starting the MCP server
SLACK_SAFE_STORAGE_PASSWORD=$(security find-generic-password -s "Slack Safe Storage" -w 2>/dev/null) \
  uv --directory /PATH/TO/YOUR/PROJECT run tars-support/scripts/extract-slack-tokens.py 2>/dev/null

source /PATH/TO/YOUR/PROJECT/.env

exec docker run -i --rm \
  -v "${HOME}/.cache/slack-mcp-server:/root/.cache/slack-mcp-server" \
  -v "/PATH/TO/YOUR/PROJECT/ca-bundle.pem:/etc/ssl/certs/ca-certificates.crt:ro" \
  -e "SLACK_MCP_CACHE_TTL=24h" \
  -e "SLACK_MCP_USER_AGENT=${SLACK_MCP_USER_AGENT}" \
  -e "SLACK_MCP_XOXC_TOKEN=${SLACK_MCP_XOXC_TOKEN}" \
  -e "SLACK_MCP_XOXD_TOKEN=${SLACK_MCP_XOXD_TOKEN}" \
  -e "SLACK_MCP_ADD_MESSAGE_TOOL=true" \
  "ghcr.io/korotovsky/slack-mcp-server:v1.1.28@sha256:6ccb90df28979737fe27ffbef5e4fb7d78da77cae719dacb94b9e941bfae6000" \
  mcp-server --transport stdio
