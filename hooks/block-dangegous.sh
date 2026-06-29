#!/bin/bash
# ./claude/hooks/block-dangegous.sh

set -e
INPUT=${cat}

# 提取命令（调试信息输出值 stderr）
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command' // ""')
echo "DEBUG: Checking command: $COMMAND" >&2

# 危险命令模式列表
DANGEROUS_PATTERNS=(
  "rm -rf /"
  "rm -rf ~"
  "rm -rf \$HOME"
  "> dev/sd"
  "dd if="
  "mkfs."
  ":(){:|:&};:"  # fork bomb（Fork 炸弹）
  "chmod -R 777 /"
  "git push --force origin main"
  "git push --force origin master"
  "git reset --hard origin"
  "DROP DATABASE"
  "DROP TABLE"
  "TRUNCATE"
  "curl.* | bash"
  "curl.* | sh"  # 危险的管道执行
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if [[ "$COMMAND" == *"$pattern"* ]]; then
    echo "BLOCKED: Dangerous command detected: '$COMMAND'" >&2
    cat <<EOF
{
    "hookSpecificOutput":{
        "hookEventName": "PreToolUse",
        "permissionDecision": "deny",
        "permissionDecisionReason": "Dangerous command detected: '$COMMAND'"
        }
}
EOF
    exit 2
  fi
done

echo '{"hookSpecificOutput":{"hookEventName": "PreToolUse","permissionDecision": "allow"}}'
exit 0