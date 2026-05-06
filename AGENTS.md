# Project AGENTS.md

## Scope

- Applies to the `SQL scripts` repository rooted at this folder.
- Personal/global Codex instructions still apply unless this file defines a more specific project rule.

## Project Structure

- `BusinessAnalyticsDB2/DatabaseProjectBusinessAnalyticsAI/` is the SQL Server database project.
- `DatabaseProjectBusinessAnalyticsAI.sqlproj` uses `Microsoft.Build.Sql` and targets Azure SQL (`SqlAzureV12DatabaseSchemaProvider`).
- Schema folders map to database schemas, including `dbo`, `dim`, `dim_v1`, `etl`, `etl_v1`, `fct`, `fct_v1`, `meta`, `pbi`, `stg_bc`, `stg_bc_api`, `stg_bc_cloud`, `stg_navdb`, `utl`, and `data_validation`.
- Root-level `Kontrol Scripts til *.sql` files are control/ad hoc validation scripts and should be kept separate from database object definitions.
- The `data_validation` folder contains a self-contained validation framework. Its generated/deployable flat script is `data_validation/Deploy.Flat.sql`.

## Stable Working Rules

- Inspect existing SQL objects and naming patterns before adding or changing SQL.
- Keep changes minimal and scoped to the requested schema/object.
- Preserve existing schema boundaries; do not move objects between schema folders unless the database contract changes.
- Use English for code comments.
- Avoid storing secrets, tokens, connection strings, private IP notes, or temporary credentials in repo files, `AGENTS.md`, or `Memory.md`.
- Do not silently change production-impacting scripts. Surface assumptions and required deployment steps explicitly.
- Prefer metadata changes over engine rewrites in `data_validation` when adding new table pairs, keys, scope, or rules.

## SQL Contracts

- Business table changes must not be introduced through the `data_validation` framework.
- `data_validation` objects may only write inside schema `[data_validation]`.
- `data_validation/Deploy.Flat.sql` may drop/recreate objects inside `[data_validation]`; it must not alter existing business schemas or data.
- `CompanyId` is the top partition key for the current validation framework.
- Validation key expressions are metadata-driven and use `{alias}` placeholders.
- Table-pair scope is controlled by `data_validation.CompanyScope`: active `INCLUDE` rows limit scope, and active `EXCLUDE` rows are always removed.
- Deactivate validation table pairs or keys by setting `IsActive = 0` instead of deleting metadata unless a cleanup request explicitly says otherwise.
- In SQL editor execution examples, assign `SUSER_SNAME()` to a variable before passing it to procedures.

## Validation Rules

- For project-level validation, prefer building the SQL project when practical:
  `dotnet build BusinessAnalyticsDB2/DatabaseProjectBusinessAnalyticsAI/DatabaseProjectBusinessAnalyticsAI.sqlproj`
- For `data_validation` changes, validate the deploy flow described in `BusinessAnalyticsDB2/DatabaseProjectBusinessAnalyticsAI/data_validation/README.md`:
  deploy `Deploy.Flat.sql`, run `EXEC data_validation.SeedPilotConfig;`, then run `RunTablePair` or `RunSuite`.
- When database access is unavailable, validate by inspecting generated SQL, object dependencies, and git diffs, and state that runtime SQL execution was not performed.

## Git Rules

- Use non-interactive git commands.
- Use `git --no-pager diff` for diffs.
- Do not revert unrelated user changes.
- Check `git status --short --branch` before and after edits.

## Memory Rules

- `AGENTS.md` changes only when stable project rules change.
- `Memory.md` tracks current project state, blockers, decisions, verified findings, and next checks.
- If a `Memory.md` item becomes a repeated rule, move it to `AGENTS.md`.
- If a `Memory.md` item becomes obsolete, replace it with current state rather than appending history.
