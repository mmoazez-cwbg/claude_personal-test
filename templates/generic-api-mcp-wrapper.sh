#!/bin/bash
# Generic API MCP wrapper — template for any REST API MCP (uvx-based)
# Find MCP packages at: https://github.com/topics/mcp-server

PROJECT_DIR="/PATH/TO/YOUR/PROJECT"

source "$PROJECT_DIR/.env"

export API_URL=https://your-tool.example.com
export API_TOKEN=$YOUR_API_TOKEN_VAR_NAME

exec uvx --from git+https://github.com/AUTHOR/TOOL-mcp TOOL-mcp
