# SQL scripts

Root repository for the Scanpan SQL warehouse project and related validation or control scripts.

## Main Areas

- `BusinessAnalyticsDB2/DatabaseProjectBusinessAnalyticsAI/`: main SQL database project
- root `Kontrol Scripts til *.sql`: ad hoc or control queries kept outside object definitions
- `data_validation/`: validation framework inside the SQL project

## Validation

- Preferred project-level build:
  - `dotnet build BusinessAnalyticsDB2/DatabaseProjectBusinessAnalyticsAI/DatabaseProjectBusinessAnalyticsAI.sqlproj`
- For `data_validation` work, follow the deploy and run flow documented inside that project area
