#!/bin/bash
# Claude Flow MCP Wrapper - Singleton kontrolü ile

# Mevcut instance varsa önce durdur
npx -y claude-flow@latest mcp stop 2>/dev/null

# MCP başlat
cd ~/.claude
exec npx -y claude-flow@latest mcp start --stdio
