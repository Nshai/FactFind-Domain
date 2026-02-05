USE administration;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT 
    @ScriptGUID = 'A5ABCA56-067A-4C39-ACE0-3F8D231FCE2E',
    @Comments = 'CRMPM-15823 CRM - CRM - AU Fee Consent - Advisor Dashboard Widget-TDashboardComponent '

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;
/*
Summary: My Fee Consents Widget

Expected row counts:
(1 row(s) inserted)
*/

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @Identifier VARCHAR(50) = 'myFeeConsents'
       , @Description VARCHAR(255) = 'My Fee Consents'
       , @CreateStampAction CHAR = 'C'
       , @StampUser VARCHAR(1) = '0'
       , @StampDateTime DATETIME = GETDATE()

BEGIN TRY

        BEGIN TRANSACTION
        IF NOT EXISTS (SELECT 1 FROM dbo.TDashboardComponent WHERE Identifier = @Identifier)
        BEGIN
            INSERT INTO dbo.TDashboardComponent
                ([Identifier]
                ,[Description]
                ,[ConcurrencyId]
                ,[TenantId])
            OUTPUT Inserted.DashboardComponentId
                ,Inserted.[Identifier]
                ,Inserted.[Description]
                ,Inserted.[ConcurrencyId]
                ,Inserted.[TenantId]
                ,@CreateStampAction
                ,@StampDateTime
                ,@StampUser
            INTO dbo.TDashboardComponentAudit
                ([DashboardComponentId]
                ,[Identifier]
                ,[Description]
                ,[ConcurrencyId]
                ,[TenantId]
                ,[StampAction]
                ,[StampDateTime]
                ,[StampUser])
            VALUES (@Identifier, @Description, 1, NULL);

        END

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

        COMMIT TRANSACTION

END TRY
BEGIN CATCH

    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT
    DECLARE @ErrorLine INT
    DECLARE @ErrorNumber INT

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE(),
           @ErrorNumber = ERROR_NUMBER(),
           @ErrorLine = ERROR_LINE()

    IF XACT_STATE() <> 0 
        ROLLBACK TRANSACTION

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;