USE [CRM]


DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT
    @ScriptGUID = 'E4FBC21F-E38A-4A70-9C47-98DCBB16AA4E',
    @Comments = 'SE-5167 New Scotland Tax Rate 48%'
      
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN; 

BEGIN TRANSACTION
    
    BEGIN TRY
        -- insert the records
        INSERT INTO
            [TRefTaxRate]
            (
               [Name]
			  ,[TaxRate]
			  ,[IsArchived]
			  ,[Extensible]
			  ,[ConcurrencyId]
            )
        OUTPUT
            INSERTED.[Name],
            INSERTED.TaxRate,
            INSERTED.IsArchived,
			INSERTED.Extensible,
			INSERTED.ConcurrencyId,
			INSERTED.RefTaxRateId,
            'C',
            GETDATE(),
            '0'
        INTO
            [TRefTaxRateAudit]
            (
               [Name]
			  ,[TaxRate]
			  ,[IsArchived]
			  ,[Extensible]
			  ,[ConcurrencyId]
			  ,[RefTaxRateId]
			  ,[StampAction]
			  ,[StampDateTime]
			  ,[StampUser]
            )
        SELECT 'Additional Rate',48,0,NULL,1

        -- END DATA INSERT
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