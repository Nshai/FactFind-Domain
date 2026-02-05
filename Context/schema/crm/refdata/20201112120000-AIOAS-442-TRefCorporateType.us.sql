/*
Script date: 14/12/2022 14:00:00
Old datetime in the filename is saved from original file to keep scripts execution order in the right way
*/

USE CRM

DECLARE @ScriptGUID UNIQUEIDENTIFIER = 'C1111FA0-AD9B-4B03-923C-6B9EA42B71D2',
		@Comments VARCHAR(255) = 'AIOAS-440 Create ref data corporate types in TRefCorporateType for US'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

BEGIN TRANSACTION

	BEGIN TRY

		SET IDENTITY_INSERT TRefCorporateType ON;

		MERGE TRefCorporateType tgt
		USING (VALUES
			(1, 'Unknown'),
			(2, 'Limited Liability Corporation (LLC)'),
			(3, 'C-Corporation'),
			(4, 'S-Corporation'),
			(5, 'Qualified institutional buyer'),
			(6, 'Charities & non-profits'),
			(7, 'Partnership'),
			(8, 'Insurance company'),
			(9, 'Private fund'),
			(10, 'Retirement plans'),
			(11, 'Other'),
			(12, 'Single Member LLC'),
			(13, 'Sole Proprietorship')
			) AS src (Id, TypeName) ON tgt.RefCorporateTypeId = src.Id
			WHEN MATCHED
				THEN UPDATE SET tgt.TypeName = src.TypeName , ConcurrencyId = 1
			WHEN NOT MATCHED
				THEN INSERT (RefCorporateTypeId, TypeName, HasCompanyRegFg, ArchiveFg, Extensible, ConcurrencyId)
				VALUES (src.Id, src.TypeName, 0, 0, NULL, 1)
			OUTPUT
				CASE $action WHEN 'UPDATE' THEN DELETED.TypeName ELSE INSERTED.TypeName END,
				CASE $action WHEN 'UPDATE' THEN DELETED.HasCompanyRegFg ELSE INSERTED.HasCompanyRegFg END,
				CASE $action WHEN 'UPDATE' THEN DELETED.ArchiveFg ELSE INSERTED.ArchiveFg END,
				CASE $action WHEN 'UPDATE' THEN DELETED.ConcurrencyId ELSE INSERTED.ConcurrencyId END,
				CASE $action WHEN 'UPDATE' THEN DELETED.Extensible ELSE INSERTED.Extensible END,
				CASE $action WHEN 'UPDATE' THEN DELETED.RefCorporateTypeId ELSE INSERTED.RefCorporateTypeId END,
				CASE $action WHEN 'UPDATE' THEN 'U' ELSE 'C' END,
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