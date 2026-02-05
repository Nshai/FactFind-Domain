/*
Script date: 01/09/2022 15:00:00
Old datetime in the filename is saved from original file to keep scripts execution order in the right way
*/

USE CRM

DECLARE @ScriptGUID UNIQUEIDENTIFIER = '2F0058D7-06A5-45E7-A63A-615116AC5F02',
		@Comments VARCHAR(255) = 'AIOAS-329 Create ref data corporate types - AU'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

BEGIN TRANSACTION

	BEGIN TRY

		SET IDENTITY_INSERT TRefCorporateType ON;

		MERGE TRefCorporateType tgt
		USING (VALUES
			(1, 'Unknown'),
			(2, 'Proprietary Limited (Pty Ltd)'),
			(3, 'Corporation'),
			(4, 'Partnership'),
			(5, 'Sole Trader'),
			(6, 'Non-profit'),
			(7, 'Limited Partnership')
			) AS src (Id, TypeName) ON tgt.RefCorporateTypeId = src.Id
			WHEN MATCHED
				THEN UPDATE SET tgt.TypeName = src.TypeName , ConcurrencyId = 1
			WHEN NOT MATCHED BY SOURCE
				THEN DELETE
			WHEN NOT MATCHED
				THEN INSERT (RefCorporateTypeId, TypeName, HasCompanyRegFg, ArchiveFg, Extensible, ConcurrencyId)
				VALUES (src.Id, src.TypeName, 0, 0, NULL, 1)
			OUTPUT
				CASE WHEN $action IN('DELETE','UPDATE') THEN DELETED.TypeName ELSE INSERTED.TypeName END,
				CASE WHEN $action IN('DELETE','UPDATE') THEN DELETED.HasCompanyRegFg ELSE INSERTED.HasCompanyRegFg END,
				CASE WHEN $action IN('DELETE','UPDATE') THEN DELETED.ArchiveFg ELSE INSERTED.ArchiveFg END,
				CASE WHEN $action IN('DELETE','UPDATE') THEN DELETED.ConcurrencyId ELSE INSERTED.ConcurrencyId END,
				CASE WHEN $action IN('DELETE','UPDATE') THEN DELETED.Extensible ELSE INSERTED.Extensible END,
				CASE WHEN $action IN('DELETE','UPDATE') THEN DELETED.RefCorporateTypeId ELSE INSERTED.RefCorporateTypeId END,
				CASE $action WHEN 'DELETE' THEN 'D' WHEN 'UPDATE' THEN 'U' ELSE 'C' END,
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
				);

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
