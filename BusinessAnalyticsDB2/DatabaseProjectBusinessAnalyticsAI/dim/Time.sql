CREATE TABLE [dim].[Time] (
    [DW_SK_Time]       INT           NOT NULL,
    [TimeOfDay]        TIME (0)      NULL,
    [UTCOffsetMinutes] SMALLINT      NULL,
    [UTCOffset]        NVARCHAR (50) NULL,
    [MinuteKey]        SMALLINT      NOT NULL,
    [MinuteName]       NVARCHAR (50) NULL,
    [MinuteOfHourKey]  SMALLINT      NOT NULL,
    [MinuteOfHourName] NVARCHAR (50) NULL,
    [QuarterKey]       SMALLINT      NOT NULL,
    [QuarterName]      NVARCHAR (50) NULL,
    [HalfHourKey]      SMALLINT      NOT NULL,
    [HalfHourName]     NVARCHAR (50) NULL,
    [HourKey]          SMALLINT      NOT NULL,
    [HourName]         NVARCHAR (50) NULL,
    CONSTRAINT [PK_Time] PRIMARY KEY CLUSTERED ([DW_SK_Time] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

CREATE NONCLUSTERED INDEX [NIX_dim_Time_UTCOffsetMinutes_WithIncluded]
    ON [dim].[Time]([UTCOffsetMinutes] ASC)
    INCLUDE([TimeOfDay], [MinuteKey], [MinuteName], [MinuteOfHourKey], [MinuteOfHourName], [QuarterKey], [QuarterName], [HalfHourKey], [HalfHourName], [HourKey], [HourName]) WITH (DATA_COMPRESSION = ROW);


GO

CREATE NONCLUSTERED INDEX [NIX_UTCOffset_WithIncluded]
    ON [dim].[Time]([UTCOffset] ASC)
    INCLUDE([TimeOfDay]) WITH (DATA_COMPRESSION = ROW);


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_TimeOfDay_UTCOffsetMinutes]
    ON [dim].[Time]([TimeOfDay] ASC, [UTCOffsetMinutes] ASC) WITH (DATA_COMPRESSION = ROW);


GO

