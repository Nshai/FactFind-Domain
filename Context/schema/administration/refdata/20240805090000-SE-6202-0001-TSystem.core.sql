USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
      , @SystemId INT
      , @SystemPath VARCHAR(256) = 'organisation.actions'
      , @EditNeedsSystemPath VARCHAR(256) = 'administration.organisation.factfind.editneedsquestion'
      , @SystemType VARCHAR(10) = '+subaction'
      , @StampDateTime DATETIME = GETUTCDATE()
      , @StampAction CHAR(1) = 'C'
      , @StampUser INT = 0
      , @ConcurrencyId INT = 1

SELECT @ScriptGUID = '10B74648-CD37-485D-8D62-1C0993C88CAF'
      ,@Comments = 'SE-6202 TSystem Add new permission Edit Needs Questions'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-- Expected row counts:
-- (1 row(s) affected)

SET @SystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = @SystemPath)

BEGIN TRANSACTION

    BEGIN TRY

        -- Insert Dashboards node under MI Reports node.
        IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @EditNeedsSystemPath)
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
                ('editneedsquestion'
                ,'Edit Needs Question'
                ,@EditNeedsSystemPath
                ,@SystemType
                ,@SystemId
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