CREATE TABLE IF NOT EXISTS evaluation_tasks (
    id          TEXT PRIMARY KEY,
    tenant_id   INTEGER NOT NULL,
    dataset_id  TEXT NOT NULL,
    start_time  DATETIME NOT NULL,
    status      INTEGER NOT NULL,
    err_msg     TEXT NOT NULL DEFAULT '',
    total       INTEGER NOT NULL DEFAULT 0,
    finished    INTEGER NOT NULL DEFAULT 0,
    params_json TEXT NOT NULL,
    metric_json TEXT,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_evaluation_tasks_tenant_start
    ON evaluation_tasks (tenant_id, start_time DESC);
