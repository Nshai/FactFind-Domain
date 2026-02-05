USE [crm]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT @ScriptGUID = '39045C31-7ACD-4BBD-909E-06CD7FA0A47E'
      , @Comments = 'DEF-9759 - Add title Duke'
      
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN; 

BEGIN TRANSACTION
	
	BEGIN TRY
		
		SET IDENTITY_INSERT TRefTitle ON
		
		INSERT INTO TRefTitle ([RefTitleId], [TitleName], [ConcurrencyId])
		OUTPUT inserted.TitleName, inserted.ConcurrencyId, inserted.RefTitleId, 'C', GETUTCDATE(), 0
		INTO TRefTitleAudit(TitleName, ConcurrencyId, RefTitleId, StampAction, StampDateTime, StampUser)
		VALUES (83, 'Duke', 1)
					
		SET IDENTITY_INSERT TRefTitle OFF

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