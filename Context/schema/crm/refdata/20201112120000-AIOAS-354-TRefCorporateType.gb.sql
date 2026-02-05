/*
Script date: 01/09/2022 15:00:00
Old datetime in the filename is saved from original file to keep scripts execution order in the right way
*/

USE CRM

DECLARE @ScriptGUID UNIQUEIDENTIFIER = 'DEDDD906-D039-4100-957F-6DC5D8A67A73',
		@Comments VARCHAR(255) = 'AIOAS-329 Create ref data corporate types - GB'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

BEGIN TRANSACTION

	BEGIN TRY

		SET IDENTITY_INSERT TRefCorporateType ON;

		INSERT INTO TRefCorporateType
		(RefCorporateTypeId, TypeName, HasCompanyRegFg, ArchiveFg, Extensible, ConcurrencyId)
		OUTPUT
			INSERTED.TypeName,
			INSERTED.HasCompanyRegFg,
			INSERTED.ArchiveFg,
			INSERTED.ConcurrencyId,
			INSERTED.Extensible,
			INSERTED.RefCorporateTypeId,
			'C',
			GETUTCDATE(),
			'0'
		INTO
			TRefCorporateTypeAudit
			(
				TypeName,
				HasCompanyRegFg,
				ArchiveFg,
				ConcurrencyId,
				Extensible,
				RefCorporateTypeId,
				StampAction,
				StampDateTime,
				StampUser
			)
		VALUES
		(1, 'Unknown', 0, 0, NULL, 1),
		(2, 'Private Limited Company', 0, 0, NULL, 1),
		(3, 'Public Limited Company', 0, 0,NULL, 1),
		(4, 'Partnership', 0, 0, NULL, 1),
		(5, 'Sole Trader', 0, 0, NULL, 1),
		(6, 'Club, Association or Charity', 0, 0, NULL, 1),
		(7, 'Limited Liability Partnership', 0, 0, NULL, 1),
		(8, 'Insurance Company', 0, 0, NULL, 1),
		(9, 'Bank', 0, 0, NULL, 1),
		(10, 'Investment Company', 0, 0, NULL, 1),
		(11, 'Other', 0, 0, NULL, 1)

		SET IDENTITY_INSERT TRefCorporateType OFF

	END TRY
	BEGIN CATCH

		DECLARE @ErrorMessage VARCHAR(MAX) = ERROR_MESSAGE()
		RAISERROR(@ErrorMessage, 16, 1)
		WHILE(@@TRANCOUNT > 0) ROLLBACK
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