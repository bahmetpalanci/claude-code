#!/bin/bash
cd ~/.claude
exec npx -y claude-flow@latest mcp start --stdio
