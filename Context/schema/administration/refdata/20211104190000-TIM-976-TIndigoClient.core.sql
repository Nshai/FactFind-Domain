USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
    , @Comments VARCHAR(255)
    , @ErrorMessage VARCHAR(MAX)
    , @InvalidCountryId INT = -9998
    , @IndigoClientId INT

SELECT @ScriptGUID = '18eb7de7-075c-454b-a493-135cfc7f3a0c'
    , @Comments = 'TIM-976-0001_001-SetCountryFrom-9998To1'
    
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN; 

BEGIN TRANSACTION
    
    BEGIN TRY
---------- BEGIN DATA INSERT/UPDATE ----------------------------------------------------
        SET @IndigoClientId = 228;
        IF EXISTS(SELECT * FROM [administration].[dbo].[TIndigoClient] WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId)
        BEGIN
            UPDATE [administration].[dbo].[TIndigoClient] SET Country = 1 WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId;
        END

        SET @IndigoClientId = 676;
        IF EXISTS(SELECT * FROM [administration].[dbo].[TIndigoClient] WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId)
        BEGIN
            UPDATE [administration].[dbo].[TIndigoClient] SET Country = 1 WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId;
        END

        SET @IndigoClientId = 791;
        IF EXISTS(SELECT * FROM [administration].[dbo].[TIndigoClient] WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId)
        BEGIN
            UPDATE [administration].[dbo].[TIndigoClient] SET Country = 1 WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId;
        END

        SET @IndigoClientId = 826;
        IF EXISTS(SELECT * FROM [administration].[dbo].[TIndigoClient] WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId)
        BEGIN
            UPDATE [administration].[dbo].[TIndigoClient] SET Country = 1 WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId;
        END

        SET @IndigoClientId = 10490;
        IF EXISTS(SELECT * FROM [administration].[dbo].[TIndigoClient] WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId)
        BEGIN
            UPDATE [administration].[dbo].[TIndigoClient] SET Country = 1 WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId;
        END

        SET @IndigoClientId = 10632;
        IF EXISTS(SELECT * FROM [administration].[dbo].[TIndigoClient] WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId)
        BEGIN
            UPDATE [administration].[dbo].[TIndigoClient] SET Country = 1 WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId;
        END

        SET @IndigoClientId = 11154;
        IF EXISTS(SELECT * FROM [administration].[dbo].[TIndigoClient] WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId)
        BEGIN
            UPDATE [administration].[dbo].[TIndigoClient] SET Country = 1 WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId;
        END

        SET @IndigoClientId = 13330;
        IF EXISTS(SELECT * FROM [administration].[dbo].[TIndigoClient] WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId)
        BEGIN
            UPDATE [administration].[dbo].[TIndigoClient] SET Country = 1 WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId;
        END

        SET @IndigoClientId = 11645;
        IF EXISTS(SELECT * FROM [administration].[dbo].[TIndigoClient] WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId)
        BEGIN
            UPDATE [administration].[dbo].[TIndigoClient] SET Country = 1 WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId;
        END

        SET @IndigoClientId = 11693;
        IF EXISTS(SELECT * FROM [administration].[dbo].[TIndigoClient] WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId)
        BEGIN
            UPDATE [administration].[dbo].[TIndigoClient] SET Country = 1 WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId;
        END

        SET @IndigoClientId = 11756;
        IF EXISTS(SELECT * FROM [administration].[dbo].[TIndigoClient] WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId)
        BEGIN
            UPDATE [administration].[dbo].[TIndigoClient] SET Country = 1 WHERE IndigoClientId = @IndigoClientId AND Country = @InvalidCountryId;
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