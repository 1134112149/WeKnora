# 评测任务持久化

## 交付点

评测任务以前只保存在进程内存中，应用重启后任务状态和指标会丢失。本版本新增 `evaluation_tasks` 表，并把评测任务的创建、运行进度、成功结果和失败信息写入数据库。

API 行为保持不变：

- `POST /api/v1/evaluation` 创建任务并立即落库。
- `GET /api/v1/evaluation?task_id=...` 先查内存，内存没有任务时回查数据库。
- 评测过程中会持续保存 `status`、`total`、`finished` 和 `metric`。

## 数据库迁移

- PostgreSQL：`migrations/versioned/000093_evaluation_tasks.up.sql`
- SQLite：`migrations/sqlite/000014_evaluation_tasks.up.sql`

参数和指标使用 JSON 保存，后续扩展字段不需要频繁改表。

## 演示步骤

1. 启动 WeKnora 并调用评测创建接口，记录返回的 `task_id`。
2. 轮询评测接口，确认状态从 `1`（运行中）变为 `2`（成功）。
3. 重启应用容器。
4. 使用同一个 `task_id` 再次调用查询接口，仍能取得任务和指标，证明结果来自数据库而不是内存缓存。

## 本地验证

- `go test -c ./internal/application/service`：服务包编译通过。
- `go test ./internal/database`：迁移测试通过。
- 官方默认评测已实际跑通，脱敏结果见 `artifacts/evaluation_result_2026-09-11.json`。

官方默认数据集与当前知识库文档主题不同，因此检索指标为 0；这属于数据集领域不匹配，不是评测接口或持久化失败。
