# AGENTS.md

## Snowflake environment

- Database: `DEMO_DB`
- Schema: `TPCH_TRANSFORMED`
- Warehouse: `DEMO_WH`

## dbt commands

- Build the whole project: `dbt build --project-dir dbt/`
- Build a single model: `dbt build --select <model_name> --project-dir dbt/`

## Conventions

- Model files use snake_case names (e.g. `stg_orders.sql`, `fct_order_items.sql`).
- Source data is `SNOWFLAKE_SAMPLE_DATA.TPCH_SF1`. All raw tables must be referenced through `_sources.yml` using `{{ source(...) }}` — never hardcode raw table names in models.

## Git workflow

- Feature branches follow the pattern `feature/<description>`.
- Pull requests are required before merging to `main`; do not push directly to `main`.

## Tooling

- This project uses CoCo Desktop. Do not use the `cortex` CLI command.
