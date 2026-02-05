USE [PolicyManagement]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT @ScriptGUID = '243E200B-8540-469E-9EC2-754026CDDB4B'
      , @Comments = 'IOSE22-1078 Localise Credit History Types'
      
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN; 

DECLARE @StampAction CHAR(1) = 'U'
    , @StampDateTime AS DATETIME = GETUTCDATE()
    , @StampUser AS VARCHAR(255) = '0'

BEGIN TRANSACTION
    BEGIN TRY

        UPDATE [dbo].[TRefAdverseCredit]
        SET [Name] = CASE
            WHEN [Name] = 'CCJ/Default' THEN 'Court Judgement/Default'
            WHEN [Name] = 'Bankruptcy/IVA' THEN 'Bankruptcy/PIA'
         END
        OUTPUT
            deleted.[RefAdverseCreditId]
           ,deleted.[Name]
           ,deleted.[ConcurrencyId]
           ,'U'
           ,@StampDateTime
           ,@StampUser
        INTO [dbo].[TRefAdverseCreditAudit] (
            [RefAdverseCreditId]
           ,[Name]
           ,[ConcurrencyId]
           ,[StampAction]
           ,[StampDateTime]
           ,[StampUser]
        )
        WHERE [Name] in ('Bankruptcy/IVA', 'CCJ/Default')

    END TRY
    BEGIN CATCH
    
        SET @ErrorMessage = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
        WHILE(@@TRANCOUNT > 0)ROLLBACK
        RETURN
    
    END CATCH

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)
    
COMMIT TRANSACTION

IF @@TRANCOUNT > 0
BEGIN
       ROLLBACK
       RETURN
       PRINT 'Open transaction found, aborting'
END
RETURN;