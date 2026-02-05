USE [PolicyManagement]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT @ScriptGUID = 'D5334175-C5D7-4138-9DB1-919EF8F37638'
      , @Comments = 'PA-2305 Add payment type: Intelliflo advisors'
      
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN; 

BEGIN TRANSACTION
    
    BEGIN TRY
        SET IDENTITY_INSERT TRefAdvisePaymentType ON
        
        INSERT INTO TRefAdvisePaymentType([RefAdvisePaymentTypeId], [Name])
        SELECT 9, 'Intelliflo Advisors' 
                    
        SET IDENTITY_INSERT TRefAdvisePaymentType OFF
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