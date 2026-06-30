#! /bin/bash
# .claude/hooks/lint-check.sh

set -e
INPUT=${cat}
$FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path' // ""')
if [["$FILE_PATH" == *.js || "$FILE_PATH" == *.jsx || "$FILE_PATH" == *.ts || "$FILE_PATH" == *.tsx || "$FILE_PATH" == *.json || "$FILE_PATH" == *.css || "$FILE_PATH" == *.scss || "$FILE_PATH" == *.html || "$FILE_PATH" == *.vue ]]; then
    LINT_RESULT=$(npx eslint --fix "$FILE_PATH" 2>&1) || true
    if [ $? -ne 0 ]; then
        ESCAPED=$(echo "$LINT_RESULT" | head -30 | jq -Rs '.')
        echo "{\"hookSpecificOutput\":{\"additionalContext\":\"ESLint 发现问题 \n${ESCAPED}\"}}"
    else
        echo '{"hookSpecificOutput":{"additionalContext":"ESLint 检查通过"}}'
    fi
else
    echo "{}"
fi