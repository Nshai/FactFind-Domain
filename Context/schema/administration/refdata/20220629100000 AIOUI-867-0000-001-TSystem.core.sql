USE [Administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
      , @OldSystemPath VARCHAR(255) = 'plan.actions.moneytransferacat'
      , @NewSystemPath VARCHAR(255) = 'plan.actions.createacattransfer'
      , @Description VARCHAR(255) = 'Create ACAT Transfer'
      , @SystemType VARCHAR(255) = '+subaction'
      , @Identifier VARCHAR(255) = 'createacattransfer'
      , @StampDateTime datetime = GETUTCDATE()

SELECT @ScriptGUID = '1B2B2D06-137B-4823-A121-9FE62E3B1044'
     , @Comments = 'AIOUI-867 - Rename Money Transfer & ACAT permission name to Create ACAT Transfer'
      
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN; 

-----------------------------------------------------------------------------------------------
-- Summary:
--   Rename Money Transfer & ACAT permission name to Create ACAT Transfer 

-- Expected row counts: 1 row affected
-----------------------------------------------------------------------------------------------

BEGIN TRANSACTION
	
	BEGIN TRY
		UPDATE [dbo].[TSystem]
		SET SystemPath = @NewSystemPath, Description = @Description, SystemType = @SystemType, Identifier = @Identifier
		OUTPUT
			INSERTED.[SystemId],
			INSERTED.[Identifier],
			INSERTED.[Description],
			INSERTED.[SystemPath],
			INSERTED.[SystemType],
			INSERTED.[ParentId],
			INSERTED.[Url],
			INSERTED.[EntityId],
			INSERTED.[ConcurrencyId],
			'U',
			@StampDateTime,
			0,
			INSERTED.[Order]
		INTO TSystemAudit
			(
			[SystemId],
			[Identifier],
			[Description],
			[SystemPath],
			[SystemType],
			[ParentId],
			[Url],
			[EntityId],
			[ConcurrencyId],
			[StampAction],
			[StampDateTime],
			[StampUser],
			[Order]
			)
		WHERE SystemPath = @OldSystemPath
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
