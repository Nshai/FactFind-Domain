USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
      , @MiReportsSystemId INT
      , @MiReportsSystemPath VARCHAR(256) = 'mi'
      , @DashboardsSystemPath VARCHAR(256) = 'mi.dashboards'
      , @DataExportSystemPath VARCHAR(256) = 'mi.dataexport'
      , @SystemType VARCHAR(10) = '-system'
      , @StampDateTime DATETIME = GETUTCDATE()
      , @StampAction CHAR(1) = 'C'
      , @StampUser INT = 0
      , @ConcurrencyId INT = 1

SELECT @ScriptGUID = '8FC0D830-FB5A-4013-B2F2-FEF14687066C'
      ,@Comments = 'CRMPM-3042 TSystem Add new security items by functional area for Business Intelligence UI'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-- Expected row counts:
-- (2 row(s) affected)

SET @MiReportsSystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = @MiReportsSystemPath)

BEGIN TRANSACTION

    BEGIN TRY

        -- Insert Dashboards node under MI Reports node.
        IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @DashboardsSystemPath)
        BEGIN
            INSERT INTO [dbo].[TSystem]
                ([Identifier]
                ,[Description]
                ,[SystemPath]
                ,[SystemType]
                ,[ParentId]
                ,[ConcurrencyId])
            OUTPUT 
                 INSERTED.[SystemId]
                ,INSERTED.[Identifier]
                ,INSERTED.[Description]
                ,INSERTED.[SystemPath]
                ,INSERTED.[SystemType]
                ,INSERTED.[ParentId]
                ,INSERTED.[Url]
                ,INSERTED.[EntityId]
                ,INSERTED.[ConcurrencyId]
                ,INSERTED.[Order]
                ,@StampAction
                ,@StampDateTime
                ,@StampUser
            INTO TSystemAudit
                ([SystemId]
                ,[Identifier]
                ,[Description]
                ,[SystemPath]
                ,[SystemType]
                ,[ParentId]
                ,[Url]
                ,[EntityId]
                ,[Order]
                ,[ConcurrencyId]
                ,[StampAction]
                ,[StampDateTime]
                ,[StampUser])
            VALUES
                ('dashboards'
                ,'Dashboards'
                ,@DashboardsSystemPath
                ,@SystemType
                ,@MiReportsSystemId
                ,@ConcurrencyId)
        END

        -- Insert Data Export node under MI Reports node.
        IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @DataExportSystemPath)
        BEGIN
            INSERT INTO [dbo].[TSystem]
                ([Identifier]
                ,[Description]
                ,[SystemPath]
                ,[SystemType]
                ,[ParentId]
                ,[ConcurrencyId])
            OUTPUT 
                 INSERTED.[SystemId]
                ,INSERTED.[Identifier]
                ,INSERTED.[Description]
                ,INSERTED.[SystemPath]
                ,INSERTED.[SystemType]
                ,INSERTED.[ParentId]
                ,INSERTED.[Url]
                ,INSERTED.[EntityId]
                ,INSERTED.[ConcurrencyId]
                ,INSERTED.[Order]
                ,@StampAction
                ,@StampDateTime
                ,@StampUser
            INTO TSystemAudit
                ([SystemId]
                ,[Identifier]
                ,[Description]
                ,[SystemPath]
                ,[SystemType]
                ,[ParentId]
                ,[Url]
                ,[EntityId]
                ,[Order]
                ,[ConcurrencyId]
                ,[StampAction]
                ,[StampDateTime]
                ,[StampUser])
            VALUES
                ('dataexport'
                ,'Data Export'
                ,@DataExportSystemPath
                ,@SystemType
                ,@MiReportsSystemId
                ,@ConcurrencyId)
        END

    END TRY
    BEGIN CATCH
    
        SET @ErrorMessage = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
        WHILE(@@TRANCOUNT > 0)ROLLBACK
        RETURN
    
    END CATCH

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)
    
COMMIT TRANSACTION

-- Check for ANY open transactions
-- This applies not only to THIS script but will rollback any open transactions in any scripts that have been run before this one.
IF @@TRANCOUNT > 0
BEGIN
       ROLLBACK
       RETURN
       PRINT 'Open transaction found, aborting'
END

RETURN;