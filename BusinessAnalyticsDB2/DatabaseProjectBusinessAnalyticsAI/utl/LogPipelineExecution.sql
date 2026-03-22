CREATE PROCEDURE utl.LogPipelineExecution
    @PipelineName NVARCHAR(100),
    @ExecutionStatus NVARCHAR(50),
    @Message NVARCHAR(MAX),
    @ExecutionTime DATETIME
AS
BEGIN
    INSERT INTO PipelineLogs (PipelineName, ExecutionStatus, Message, ExecutionTime)
    VALUES (@PipelineName, @ExecutionStatus, @Message, @ExecutionTime);
END

GO

