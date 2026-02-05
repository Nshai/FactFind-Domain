USE [CRM]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

/*

Summary
Ticket : SE-7595 : New Australian Tax Rates
Purpose: To add new Tax Rate 16% and 30% to FactFind employment tab

DatabaseName    TableName           Expected Rows
CRM             TRefTaxRate         2 row
CRM             TRefTaxRateAudit    2 row

*/

SELECT
    @ScriptGUID = '61DAD827-2F8D-4121-B771-DBAAA0BBF62B',
    @Comments = 'SE-7595 : New Australian Tax Rates'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN; 

    BEGIN TRY
      BEGIN TRANSACTION
        /* insert the records*/
        INSERT INTO
            [TRefTaxRate]
            (
               [Name],
               [TaxRate],
               [IsArchived],
               [Extensible],
               [ConcurrencyId]
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
               [Name],
               [TaxRate],
               [IsArchived],
               [Extensible],
               [ConcurrencyId],
               [RefTaxRateId],
               [StampAction],
               [StampDateTime],
               [StampUser]
            )
        VALUES
            ('Additional Rate from August 2024',16,0,NULL,1),
            ('Additional Rate from August 2024',30,0,NULL,1);

        /* END DATA INSERT*/
        INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

      COMMIT TRANSACTION

    END TRY
    BEGIN CATCH
    
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW
    
    END CATCH

RETURN;