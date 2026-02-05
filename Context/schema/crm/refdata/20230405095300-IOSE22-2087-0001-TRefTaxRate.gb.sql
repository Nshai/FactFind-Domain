USE [CRM]


DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT
    @ScriptGUID = '649F0A7A-49E6-413B-BD6E-CF910D6D4745',
    @Comments = 'IOSE22-2087 Adding Scottish Tax Rates'
      
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
        SELECT 'Additional Rate',42,0,NULL,1 UNION ALL
		SELECT 'Additional Rate',47,0,NULL,1 

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

-- Drop any temptables explicitly
IF (SELECT OBJECT_ID('tempdb..#temptable1')) IS NOT NULL
       DROP TABLE #temptable1


-- Check for ANY open transactions
-- This applies not only to THIS script but will rollback any open transactions in any scripts that have been run before this one.
IF @@TRANCOUNT > 0
BEGIN
       ROLLBACK
       RETURN
       PRINT 'Open transaction found, aborting'
END

RETURN;