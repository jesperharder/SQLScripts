# Memory

## Current State

- No prior local `Memory.md` existed in this repository, so there was no old memory file to back up.
- No prior local `AGENTS.md` existed in this repository before the current project rules file.
- Repository root is `C:\Users\jespe\OneDrive - Scanpan\Scanpan (7.1.2015)\Development\SQL scripts`.
- Main SQL project is `BusinessAnalyticsDB2/DatabaseProjectBusinessAnalyticsAI/DatabaseProjectBusinessAnalyticsAI.sqlproj`.
- The SQL project uses `Microsoft.Build.Sql` version `2.1.0` and targets Azure SQL.
- The repo has root-level control scripts plus a schema-folder database project under `BusinessAnalyticsDB2/DatabaseProjectBusinessAnalyticsAI`.

## Verified Findings

- `data_validation/README.md` documents the validation framework and confirms it is intended to write only to schema `[data_validation]`.
- `data_validation` V1 validates table existence, row counts, distinct key counts, duplicate keys, and missing keys.
- Current validation assumptions are `CompanyId` as top partition key, metadata-driven business keys, `{alias}` key expressions, and optional metadata-driven company scope.
- `data_validation/Deploy.Flat.sql` is the deployable flat script for the validation framework.
- The working branch is `main` tracking `origin/main`; no local changes were present before creating the local memory/rules files.

## Decisions

- Stable project rules live in `AGENTS.md`.
- `Memory.md` is kept as current state, not a changelog.
- Do not store secrets, temporary credentials, tokens, private endpoint details, or transient troubleshooting notes in memory or agent rules.

## Blockers

- No current blockers recorded.

## Next Checks

- When SQL objects are changed, run or attempt `dotnet build BusinessAnalyticsDB2/DatabaseProjectBusinessAnalyticsAI/DatabaseProjectBusinessAnalyticsAI.sqlproj`.
- When `data_validation` changes, check that the change stays inside schema `[data_validation]` and update `Deploy.Flat.sql` if the deploy script must reflect object changes.
- If database access is available, validate `data_validation` changes by deploying `Deploy.Flat.sql`, running `SeedPilotConfig`, and executing the relevant `RunTablePair` or `RunSuite`.
