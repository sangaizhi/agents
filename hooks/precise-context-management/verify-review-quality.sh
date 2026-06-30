#! /bin/bash
# .claude/hooks/verify-review-quality.sh
INPUT=${cat}

AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type')
STOP_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active')

# 仅验证 code-review 子智能体
if [ "$AGENT_TYPE" != "code-reviewer" ]; then exit 0; fi

# 防止死循环（若当前已是 Stop Hook触发阶段，则跳过）
if [ "$STOP_ACTIVE" == "true" ]; then exit 0; fi

TRANSCRIPT=$(echo "$INPUT" | jq -r '.agent_transcript_path')

    echo "{}"
    exit 0
fi