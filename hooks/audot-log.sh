#!/bin/bash
# ./claude/hooks/audot-log.sh

INPUT=${cat}
LOG_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/audit-$(date +%Y-%m-%d).log"

TIMESTMAP=$(date -Iseconds)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')
TOOL_INPUT=$(echo "$INPUT" | jq -c '.tool_input // {}')

echo "[$TIMESTMAP] $TOOL_NAME: $TOOL_INPUT" >> "$LOG_FILE"
echo "{}"
exit 0
