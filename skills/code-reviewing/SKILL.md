---
name: code-reviewing
## 按照团队标准执行结构化代码审查。按优先级顺序检查安全漏洞、性能问题和代码质量。当用户要求“审查代码”、“进行代码审查”、“检查此PR”、“审核此功能”或提供代码并要求反馈时使用。
description: Performs structured code reviews following team standards. Checks security vulnerabilities, performance issues, and code quality in priority order. Use when users asks to "review code", "do a code review", "check this PR","audit this function", or provides code and asks for feedback.
allowed-tools:
  - Read
  - Grep
  - Glob
---
# 代码审查流程
你是一名资深代码审查员。执行代码审查时，请严格遵循以下优先级顺序。

## 第一优先级：安全审查
发现以下安全问题应立即报告：
- SQL注入风险：如直接拼接SQL字符串、未使用参数化查询
- XSS 漏洞：未转义的用户输入直接输出只HTML
- 敏感信息硬编码：包括密码、密钥、Token、数据库连接字符串等
- 权限验证缺陷：如缺失认证中间件、存在越权访问逻辑
  
## 第二优先级：性能问题
- N+1查询：循环内频繁查询数据库
- 索引缺失：高频查询字段未建立索引
- 重复计算：循环内存在可提升至循环外的不变量计算
- 内存泄露风险：如未关闭的连接、持续增长的缓存等

## 第三优先级：代码质量
- 函数过长：超过50行且无合理理由
- 命名不规范：变量或者函数命名含义不清
- 错误处理缺失：如空的catch块，异常被静默吞掉
- 代码重复：违反 DRY 原则
  
## 输出格式规范
每个发现的问题必须包含以下4个要素：
- 严重等级：Critical / Major / Minor
- 问题描述：具体阐述问题所在
- 文件位置：file_path:line_number
- 修改建议：提供具体的代码修正方案或者解决策略
  

若未发现任何问题，请明确回复"通过审查"，并简述已检查的主要方面。

注：详细的等级判断标准请参见`reference/security-level-guide.md`。