USE [FactFind]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT @ScriptGUID = 'A8A50F80-46D5-4A76-8074-9A5E016112B8',
       @Comments = 'INTTFF-2141 Add new expenditure items for Trusts and corporate party types in UK environment'

 -- check if this script has already run     
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN; 

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION

        -- insert the records
        SET IDENTITY_INSERT TRefExpenditureType ON; 
        
		 INSERT INTO TRefExpenditureType([RefExpenditureTypeId], [ConcurrencyId], [RefExpenditureGroupId], [Name], [Ordinal], [Attributes])	
			SELECT 72, 1, 5,                                                       'Periodic Charge',  71, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL
			SELECT 73, 1, 5,                                                            'LEI Charge',  72, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL
			SELECT 74, 1, 5,                                                            'Tax Return',  73, '{\"party_types\":\"Trust,Corporate\"}' 

        SET IDENTITY_INSERT TRefExpenditureType OFF

        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (@ScriptGUID, @Comments, null, getdate() )

   IF @starttrancount = 0
    COMMIT TRANSACTION

END TRY
BEGIN CATCH
    DECLARE @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH

 SET XACT_ABORT OFF
 SET NOCOUNT OFF  