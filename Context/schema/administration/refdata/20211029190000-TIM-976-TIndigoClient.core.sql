USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
    , @Comments VARCHAR(255)
    , @ErrorMessage VARCHAR(MAX)

SELECT @ScriptGUID = '8c26502a-e521-4847-b899-2d7dabfcef42'
    , @Comments = 'TIM-976-0001_001-SetCountryFrom-9998To1'
    
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN; 

BEGIN TRANSACTION
    
    BEGIN TRY
---------- BEGIN DATA INSERT/UPDATE ----------------------------------------------------
        IF EXISTS(SELECT * FROM [administration].[dbo].[TIndigoClient] WHERE Country = -9988)
        BEGIN
	        UPDATE [administration].[dbo].[TIndigoClient] SET Country = 1 WHERE Country = -9988;
        END

---------- END DATA INSERT/UPDATE ------------------------------------------------------
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
