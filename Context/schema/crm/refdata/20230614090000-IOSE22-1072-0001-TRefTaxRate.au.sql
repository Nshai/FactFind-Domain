USE [CRM]


DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT
    @ScriptGUID = '536A8F77-D795-4802-A4F0-6ECCF72A6076',
    @Comments = 'IOSE22-2325 AU Tax Rates changes in the FF > Employment'
      
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN; 

BEGIN TRANSACTION
    
    BEGIN TRY

		UPDATE [TRefTaxRate] SET IsArchived = 1 
        OUTPUT
            DELETED.[Name],
            DELETED.TaxRate,
            DELETED.IsArchived,
			DELETED.Extensible,
			DELETED.ConcurrencyId,
            DELETED.RefTaxRateId,
            'U',
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
        WHERE TaxRate not in (0,19,45)

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
	 SELECT 'Additional Rate',32.5,0,NULL,1 UNION ALL
	 SELECT 'Additional Rate',37,0,NULL,1 
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
