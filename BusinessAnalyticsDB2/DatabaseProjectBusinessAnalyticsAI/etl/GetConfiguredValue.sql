CREATE FUNCTION [etl].[GetConfiguredValue]
(
    @Configuration nvarchar(128)
)
RETURNS nvarchar(128)
AS
BEGIN

    DECLARE @ConfiguredValue nvarchar(128);

    SELECT @ConfiguredValue = [ConfigurationValue]
    FROM [etl].[Configuration]
    WHERE [Configuration] = @Configuration;

    RETURN @ConfiguredValue;

END;

GO

