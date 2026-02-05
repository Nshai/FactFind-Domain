USE [CRM]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

/*

Summary
------------------------------
Ticket : SE-6839 : New Tax Rate - Isle of Man
Purpose: To add new Tax Rate 22% to be displayed in FactFind employment tab

DatabaseName    TableName           Expected Rows
---------------------------------------------------
CRM             TRefTaxRate         1 row
CRM             TRefTaxRateAudit    1 row

*/

SELECT
    @ScriptGUID = 'AEBF38E8-CE96-46CA-A196-0A7D26E7D032',
    @Comments = 'SE-6839 New Tax Rate - Isle of Man'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN; 

    BEGIN TRY
      BEGIN TRANSACTION
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
        SELECT 'Additional Rate from July 2024',22,0,NULL,1

        -- END DATA INSERT
        INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

      COMMIT TRANSACTION

    END TRY
    BEGIN CATCH
    
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW
    
    END CATCH

RETURN;