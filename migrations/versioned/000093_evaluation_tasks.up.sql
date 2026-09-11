-- Persist evaluation progress and results so the API remains queryable after
-- an application restart. Large request/metric payloads stay schemaless JSON.
CREATE TABLE IF NOT EXISTS evaluation_tasks (
    id           VARCHAR(128) PRIMARY KEY,
    tenant_id    BIGINT       NOT NULL,
    dataset_id   VARCHAR(128) NOT NULL,
    start_time   TIMESTAMPTZ  NOT NULL,
    status       INTEGER      NOT NULL,
    err_msg      TEXT         NOT NULL DEFAULT '',
    total        INTEGER      NOT NULL DEFAULT 0,
    finished     INTEGER      NOT NULL DEFAULT 0,
    params_json  JSONB        NOT NULL,
    metric_json  JSONB,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_evaluation_tasks_tenant_start
    ON evaluation_tasks (tenant_id, start_time DESC);
