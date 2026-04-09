#!/bin/bash
# Slack MCP wrapper — loads tokens from .env, mounts CA bundle for TLS fix
# See: https://github.com/korotovsky/slack-mcp-server

PROJECT_DIR="/PATH/TO/YOUR/PROJECT"

source "$PROJECT_DIR/.env"

exec docker run -i --rm \
  -v "${HOME}/.cache/slack-mcp-server:/root/.cache/slack-mcp-server" \
  -v "$PROJECT_DIR/ca-bundle.pem:/etc/ssl/certs/ca-certificates.crt:ro" \
  -e "SLACK_MCP_CACHE_TTL=24h" \
  -e "SLACK_MCP_USER_AGENT=${SLACK_MCP_USER_AGENT}" \
  -e "SLACK_MCP_XOXC_TOKEN=${SLACK_MCP_XOXC_TOKEN}" \
  -e "SLACK_MCP_XOXD_TOKEN=${SLACK_MCP_XOXD_TOKEN}" \
  -e "SLACK_MCP_ADD_MESSAGE_TOOL=true" \
  "ghcr.io/korotovsky/slack-mcp-server:v1.1.28@sha256:6ccb90df28979737fe27ffbef5e4fb7d78da77cae719dacb94b9e941bfae6000" \
  mcp-server --transport stdio

# NOTE: Remove the -v ca-bundle.pem line if you're on a personal (non-enterprise) Slack workspace.
# To generate ca-bundle.pem (macOS only):
#   security find-certificate -a -p /Library/Keychains/System.keychain > ca-bundle.pem
#   security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain >> ca-bundle.pem
