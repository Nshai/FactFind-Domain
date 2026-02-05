USE administration;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT 
    @ScriptGUID = '05E12068-9C01-43C4-8CE9-4086E3D6FDFD',
    @Comments = 'CRMPM-15718 CRM - AU Fee Consent - Client Dashboard Widget'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;
/*
Summary: Client Fee Consent Details Widget

Expected row counts:
(1 row(s) inserted)
*/

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount INT
       , @Identifier VARCHAR(50) = 'clientFeeConsentDetails'
       , @Description VARCHAR(255) = 'Client Fee Consent Details'
       , @CreateStampAction CHAR = 'C'
       , @StampUser VARCHAR(1) = '0'
       , @StampDateTime DATETIME = GETDATE()


BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
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

    IF @starttrancount = 0 
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

    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;