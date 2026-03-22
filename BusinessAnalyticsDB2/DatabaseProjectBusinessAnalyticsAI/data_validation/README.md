# Data Validation Framework

This framework lives beside the existing tables and writes only to schema `[data_validation]`.

It must not:

- change existing tables
- change existing data
- affect ETL or loads

It does this instead:

- registers table pairs in metadata
- registers keys per table pair
- registers which `CompanyId` values are in scope per table pair
- runs standard validations
- stores runs, results and samples

## Files in this folder

- `Deploy.Flat.sql`
  Use this in VS Code or other editors as normal SQL.

Folder structure:

- `Tables/`
  Contains metadata and result tables.
- `Views/`
  Contains read models such as latest status.
- `StoredProcedures/`
  Contains execution and seed procedures.

Key files:

- `Tables/CompanyScope.sql`
  Stores which `CompanyId` values are included or excluded per table pair.
- `StoredProcedures/SeedPilotConfig.sql`
  Creates pilot metadata for `STG.Customer`, `STG.Item`, and `DIM.Customer`.
- `StoredProcedures/RunTablePair.sql`
  Runs one validation.
- `StoredProcedures/RunSuite.sql`
  Runs a group of validations.
- `Views/vwLatestStatus.sql`
  Shows the latest validation status per table pair.

## First run

1. Open `Deploy.Flat.sql`.
2. Run the file against the Azure database.
3. Confirm that the objects were created:

```sql
SELECT s.name AS SchemaName, t.name AS TableName
FROM sys.tables AS t
INNER JOIN sys.schemas AS s
    ON s.schema_id = t.schema_id
WHERE s.name = N'data_validation'
ORDER BY t.name;
```

4. Check seeded table pairs:

```sql
SELECT *
FROM data_validation.TablePair
ORDER BY ValidationCode;
```

5. Check seeded pilot scope:

```sql
SELECT
    tp.ValidationCode,
    cs.CompanyId,
    cs.ScopeType,
    cs.Note
FROM data_validation.CompanyScope AS cs
INNER JOIN data_validation.TablePair AS tp
    ON tp.TablePairId = cs.TablePairId
ORDER BY tp.ValidationCode, cs.CompanyId;
```

Pilot seed now includes:

- `CompanyId = 1`
- note: `Danmark`
- scope type: `INCLUDE`

for:

- `STG.Customer`
- `STG.Item`
- `DIM.Customer`

## Run validations

Run one table pair:

```sql
DECLARE @ExecutedBy NVARCHAR(200) = SUSER_SNAME();

EXEC data_validation.RunTablePair
    @ValidationCode = N'STG.Customer',
    @ExecutedBy = @ExecutedBy;
```

Run one group:

```sql
DECLARE @ExecutedBy NVARCHAR(200) = SUSER_SNAME();

EXEC data_validation.RunSuite
    @ValidationGroup = N'STG',
    @ExecutedBy = @ExecutedBy;
```

Run all active table pairs:

```sql
DECLARE @ExecutedBy NVARCHAR(200) = SUSER_SNAME();

EXEC data_validation.RunSuite
    @ValidationGroup = NULL,
    @ExecutedBy = @ExecutedBy;
```

## Read results

Latest status:

```sql
SELECT *
FROM data_validation.vwLatestStatus
ORDER BY ValidationGroup, ValidationCode;
```

Runs:

```sql
SELECT *
FROM data_validation.Run
ORDER BY RunId DESC;
```

Rule results:

```sql
SELECT *
FROM data_validation.Result
ORDER BY ResultId DESC;
```

Samples:

```sql
SELECT *
FROM data_validation.ResultSample
ORDER BY ResultSampleId DESC;
```

## V1 scope

Active standard rules:

- `TABLE_EXISTS`
- `ROWCOUNT_TOTAL`
- `ROWCOUNT_BY_COMPANY`
- `DISTINCT_KEYCOUNT_BY_COMPANY`
- `DUPLICATE_KEYS_LEFT`
- `DUPLICATE_KEYS_RIGHT`
- `MISSING_IN_RIGHT`
- `MISSING_IN_LEFT`

The framework assumes:

- `CompanyId` is the top partition key
- business key is the natural key
- key expressions are metadata-driven with `{alias}`
- company scope is optional and metadata-driven

## Control which CompanyId values are tested

Not all `CompanyId` values exist yet in API or `V1`. The framework now supports per-table-pair scope through:

- `data_validation.CompanyScope`

Rules:

- if active `INCLUDE` rows exist for a table pair, only those `CompanyId` values are tested
- if no active `INCLUDE` rows exist, all `CompanyId` values are tested
- active `EXCLUDE` rows are always removed from the test scope

See current scope:

```sql
SELECT
    tp.ValidationCode,
    cs.CompanyId,
    cs.ScopeType,
    cs.IsActive,
    cs.Note
FROM data_validation.CompanyScope AS cs
INNER JOIN data_validation.TablePair AS tp
    ON tp.TablePairId = cs.TablePairId
ORDER BY tp.ValidationCode, cs.ScopeType, cs.CompanyId;
```

Example: limit `STG.Customer` to companies that exist in API:

```sql
DECLARE @TablePairId INT =
(
    SELECT TablePairId
    FROM data_validation.TablePair
    WHERE ValidationCode = N'STG.Customer'
);

DELETE FROM data_validation.CompanyScope
WHERE TablePairId = @TablePairId;

INSERT INTO data_validation.CompanyScope
(
    TablePairId,
    CompanyId,
    ScopeType,
    IsActive,
    Note
)
VALUES
(@TablePairId, N'1', N'INCLUDE', 1, N'Exists in API'),
(@TablePairId, N'2', N'INCLUDE', 1, N'Exists in API'),
(@TablePairId, N'7', N'INCLUDE', 1, N'Exists in API');
```

Example: exclude one company temporarily:

```sql
DECLARE @TablePairId INT =
(
    SELECT TablePairId
    FROM data_validation.TablePair
    WHERE ValidationCode = N'STG.Customer'
);

INSERT INTO data_validation.CompanyScope
(
    TablePairId,
    CompanyId,
    ScopeType,
    IsActive,
    Note
)
VALUES
(@TablePairId, N'9', N'EXCLUDE', 1, N'Not live in API yet');
```

## When the database changes

The framework is metadata-driven. When new tables appear, the engine normally does not need to change. Do this instead:

1. Ensure the new tables exist in the database.
2. Insert metadata into `data_validation.TablePair`.
3. Insert key definitions into `data_validation.TableKey`.
4. Insert active rules into `data_validation.Rule`.
5. Optionally insert allowed `CompanyId` values into `data_validation.CompanyScope`.
6. Run `RunTablePair` or `RunSuite`.

## Example: when FACT V1 is created

Assume the new table pair is:

- left: `fact.Sales`
- right: `fact_v1.Sales`

### 1. Create the table pair

```sql
INSERT INTO data_validation.TablePair
(
    ValidationCode,
    ValidationGroup,
    LeftSchemaName,
    LeftTableName,
    RightSchemaName,
    RightTableName,
    Description,
    IsActive
)
VALUES
(
    N'FACT.Sales',
    N'FACT',
    N'fact',
    N'Sales',
    N'fact_v1',
    N'Sales',
    N'Legacy fact sales versus fact v1 sales',
    1
);
```

### 2. Create key definitions

Example if the key is `CompanyId + DocumentNo + LineNo`:

```sql
DECLARE @TablePairId INT =
(
    SELECT TablePairId
    FROM data_validation.TablePair
    WHERE ValidationCode = N'FACT.Sales'
);

INSERT INTO data_validation.TableKey
(
    TablePairId,
    KeyOrdinal,
    KeyName,
    LeftExpression,
    RightExpression,
    KeyRole,
    IsActive
)
VALUES
(@TablePairId, 1, N'CompanyId', N'CAST({alias}.[CompanyId] AS NVARCHAR(50))', N'CAST({alias}.[CompanyId] AS NVARCHAR(50))', N'PARTITION', 1),
(@TablePairId, 2, N'DocumentNo', N'CAST({alias}.[DocumentNo] AS NVARCHAR(100))', N'CAST({alias}.[DocumentNo] AS NVARCHAR(100))', N'BUSINESS', 1),
(@TablePairId, 3, N'LineNo', N'CAST({alias}.[LineNo] AS NVARCHAR(100))', N'CAST({alias}.[LineNo] AS NVARCHAR(100))', N'BUSINESS', 1);
```

### 3. Create standard rules

```sql
DECLARE @TablePairId INT =
(
    SELECT TablePairId
    FROM data_validation.TablePair
    WHERE ValidationCode = N'FACT.Sales'
);

INSERT INTO data_validation.Rule
(
    TablePairId,
    RuleCode,
    Severity,
    SampleLimit,
    IsActive
)
VALUES
(@TablePairId, N'TABLE_EXISTS', N'ERROR', 100, 1),
(@TablePairId, N'ROWCOUNT_TOTAL', N'ERROR', 100, 1),
(@TablePairId, N'ROWCOUNT_BY_COMPANY', N'ERROR', 100, 1),
(@TablePairId, N'DISTINCT_KEYCOUNT_BY_COMPANY', N'ERROR', 100, 1),
(@TablePairId, N'DUPLICATE_KEYS_LEFT', N'ERROR', 100, 1),
(@TablePairId, N'DUPLICATE_KEYS_RIGHT', N'ERROR', 100, 1),
(@TablePairId, N'MISSING_IN_RIGHT', N'ERROR', 100, 1),
(@TablePairId, N'MISSING_IN_LEFT', N'ERROR', 100, 1);
```

### 4. Add company scope if only some companies are live in FACT V1

```sql
DECLARE @TablePairId INT =
(
    SELECT TablePairId
    FROM data_validation.TablePair
    WHERE ValidationCode = N'FACT.Sales'
);

INSERT INTO data_validation.CompanyScope
(
    TablePairId,
    CompanyId,
    ScopeType,
    IsActive,
    Note
)
VALUES
(@TablePairId, N'1', N'INCLUDE', 1, N'Live in FACT V1'),
(@TablePairId, N'2', N'INCLUDE', 1, N'Live in FACT V1');
```

### 5. Run the test

```sql
DECLARE @ExecutedBy NVARCHAR(200) = SUSER_SNAME();

EXEC data_validation.RunTablePair
    @ValidationCode = N'FACT.Sales',
    @ExecutedBy = @ExecutedBy;
```

## When the key structure changes

If a table gets a new natural key or a new composite key:

1. find `TablePairId`
2. update or deactivate old rows in `data_validation.TableKey`
3. insert new key definitions
4. run the validation again

Example:

```sql
UPDATE data_validation.TableKey
SET IsActive = 0
WHERE TablePairId = @TablePairId;
```

Then insert the new active keys.

## When a table pair should no longer be tested

Deactivate it instead of deleting it:

```sql
UPDATE data_validation.TablePair
SET IsActive = 0,
    UpdatedAt = SYSDATETIMEOFFSET()
WHERE ValidationCode = N'FACT.Sales';
```

## When the framework is redeployed

If you change framework code:

1. run `Deploy.Flat.sql` again
2. run `EXEC data_validation.SeedPilotConfig;`
3. verify that metadata still looks correct
4. run the tests again

Note:

- `Deploy.Flat.sql` drops and recreates objects only inside `[data_validation]`
- it does not touch the existing business tables

## Recommended workflow

1. deploy framework
2. seed pilot metadata
3. add company scope for API/V1 coverage where needed
4. run `STG`
5. review results
6. add more table pairs
7. when `FACT V1` arrives, register new metadata instead of rewriting the engine

## Important in your environment

In your SQL editor, `SUSER_SNAME()` should first be assigned to a variable.

Use this pattern:

```sql
DECLARE @ExecutedBy NVARCHAR(200) = SUSER_SNAME();

EXEC data_validation.RunTablePair
    @ValidationCode = N'STG.Customer',
    @ExecutedBy = @ExecutedBy;
```

Avoid this pattern:

```sql
EXEC data_validation.RunTablePair
    @ValidationCode = N'STG.Customer',
    @ExecutedBy = SUSER_SNAME();
```

## Known V1 limitation

V1 focuses on:

- existence
- counts
- distinct keys
- duplicates
- missing keys

V1 does not yet do:

- full column-to-column validation
- sums and measures on fact level
- tolerances per rule

This can be extended later without changing the existing business tables.
