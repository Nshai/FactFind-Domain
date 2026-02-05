USE [PolicyManagement]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT @ScriptGUID = '5FFA2F9A-F2F4-432C-B437-E1CAFC92F0F0'
      , @Comments = 'IOSE22-1817 Localise Index Types for AU'
      
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN; 

DECLARE @StampAction CHAR(1) = 'C'
	, @StampDateTime AS DATETIME = GETUTCDATE()
	, @StampUser AS VARCHAR(255) = '0'

BEGIN TRANSACTION
    BEGIN TRY

        SET IDENTITY_INSERT TRefIndexType ON; 
 
		INSERT INTO TRefIndexType([RefIndexTypeId], [IndexTypeName], [ConcurrencyId]) 
        OUTPUT inserted.[RefIndexTypeId]
			, inserted.[IndexTypeName]
			, inserted.[ConcurrencyId]
			, @StampAction
			, @StampDateTime
			, @StampUser
        INTO TRefIndexTypeAudit([RefIndexTypeId]
			, [IndexTypeName]
			, [ConcurrencyId]
			, [StampAction]
			, [StampDateTime]
			, [StampUser])
        SELECT 6, 'CPI', 1 
 
		SET IDENTITY_INSERT TRefIndexType OFF
 
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
