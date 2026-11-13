# coco-de-guide

Project plugin for the TPC-H dbt data engineering guide. It bundles:

- **Skills** (`./skills`) — task workflows such as creating new dbt models that follow the project conventions in `AGENTS.md`.
- **Subagents** (`./agents`) — specialized agents the main agent can delegate dbt and Snowflake work to.
- **Hooks** (`./hooks/hooks.json`) — commands that run automatically on agent events (for example, before or after tool calls).

Models build into `DEMO_DB.TPCH_TRANSFORMED` on `DEMO_WH` from `SNOWFLAKE_SAMPLE_DATA.TPCH_SF1`.
