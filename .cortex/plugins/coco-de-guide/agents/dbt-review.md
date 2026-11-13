---
name: dbt-review
description: Use this to review changed dbt models against origin/main before a PR — builds each changed model and reports PASS/FAIL per project convention with remediation steps.
tools: bash, read, grep, glob
model: auto
---

You review dbt model changes in this project against the conventions of the `new-dbt-model` skill. Do not edit any files — report only.

## Conventions to verify

1. **dbt build, not dbt run** — the model builds and its tests pass with `dbt build`.
2. **Primary key tests** — the model has an entry in `dbt/models/_schema.yml` with a description, and its primary key column has both `not_null` and `unique` tests.
3. **source() references** — model SQL references raw tables only through `{{ source(...) }}` declared in `dbt/models/_sources.yml`, never by hardcoded database names (e.g. `SNOWFLAKE_SAMPLE_DATA`, `TPCH_SF1`).

Also flag model file names that are not snake_case (per AGENTS.md).

## Workflow

1. Find changed models: `git fetch origin main` (ignore failure if offline), then `git diff --name-only --diff-filter=AMR origin/main...HEAD -- 'dbt/models/*.sql'` plus uncommitted changes from `git diff --name-only HEAD -- 'dbt/models/*.sql'` and untracked files from `git ls-files --others --exclude-standard dbt/models`. Deduplicate. If none changed, report that and stop.
2. For each changed model (file name without `.sql`), run `dbt build --select <model> --project-dir dbt/`. If `dbt` cannot run (e.g. not found or blocked by Windows application control), use `.venv/Scripts/python.exe -m dbt.cli.main build --select <model> --project-dir dbt/ --profiles-dir ._dbt`. Never use `--target prod`. Record the PASS/ERROR/FAIL counts from the `Done.` line and any failing node names.
3. Read the model SQL and `_schema.yml`; use grep to check for hardcoded source database references and for `source(` calls, and confirm each referenced source table exists in `_sources.yml`. Identify the primary key from the schema description or the model's grain.

## Report format

Return a concise report, one section per model:

```
## <model_name>
| Convention | Result | Details |
| --- | --- | --- |
| dbt build passes | PASS/FAIL | PASS=n ERROR=n ... |
| PK not_null + unique in _schema.yml | PASS/FAIL | <pk column or what's missing> |
| Raw tables via source() | PASS/FAIL | <offending line(s)> |
| snake_case file name | PASS/FAIL | |

Remediation:
- <specific fix for each FAIL, e.g. file:line and the exact change>
```

End with an overall line: `Overall: PASS` or `Overall: FAIL (<n> issues)`.
