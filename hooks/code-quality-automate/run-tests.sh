#! /bin/bash
# .claude/hooks/run-tests.sh
set -e
INPUT=${cat}

# 【关键机制】阻止无限循环：检查 stop_hook_active 标志
# 如果该标志为true，说明已经重试过一次，本次必须放行以避免死锁
STOP_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')

if [ "$STOP_ACTIVE" == "true" ]; then
    exit 0 # 终止拦截，允许claude停止
fi

# 切换到项目目录
if [ -n "$CLAUDE_PROJECT_DIR" ]; then
    cd "$CLAUDE_PROJECT_DIR"
fi

#检查项目类型并运行测试
TEST_PASSED=true
TEST_RESULT=""
if [ -f "package.json" ] && grep -q '"test"' package.json; then
    TEST_RESULT=$(npm test 2>&1) || TEST_PASSED=false
elif [ -f "pyptoject.toml" ] || [ -f "pytest.ini" ]; then
    TEST_RESULT=$(pytest 2>&1) || TEST_PASSED=false
elif [ -f "go.mod" ]; then
    TEST_RESULT=$(go test ./... 2>&1) || TEST_PASSED=false  
else 
    echo '{"hookSpecificOutput":{"additionalContext":"未检测到已配置的测试框架，跳过测试"}}'
    exit 0
fi

if [ "$TEST_PASSED" = true ]; then
    echo '{"hookSpecificOutput":{"additionalContext":"所有测试通过"}}'
else
    # 截取前50行错误日志并转义
    TEST_ESCAPED=$(echo "$TEST_RESULT" | head -50 | jq -Rs '.')
    # 返回 block决策，强制claude继续工作
    cat <<EOF
{   
"decision": "block",
"reason": "测试失败，请修复后再停止",
"hookSpecificOutput": {
        "additionalContext":${TEST_ESCAPED}
    }
}
EOF
fi
exit 0