USE crm;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
      , @TrustForSettlorRelationshipTypeId INT
      , @SettlorForTrustRelationshipTypeId INT

SELECT
    @ScriptGUID = '67EAA6D5-936C-41AF-8325-79CE02F51087',
    @Comments = 'INTTFF-414 Relationships Add Trust (for Settlor)'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Relationships - Add Trust (for Settlor)
-- Expected row affected: 3 + 3 audit
-----------------------------------------------------------------------------------------------


SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    -- BEGIN DATA INSERT/UPDATE
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION
            SET @TrustForSettlorRelationshipTypeId = 857
            SET @SettlorForTrustRelationshipTypeId = 858

			UPDATE [crm].[dbo].[TRefRelationshipType]
	            SET [crm].[dbo].[TRefRelationshipType].[ArchiveFg] = 1
			OUTPUT
                inserted.RelationshipTypeName,
                inserted.ArchiveFg,
                inserted.PersonFg,
                inserted.CorporateFg,
                inserted.TrustFg,
                inserted.AccountFg,
                inserted.Extensible,
                inserted.ConcurrencyId,
				inserted.RefRelationshipTypeId,
                'U ',
				GETUTCDATE(),
				0
			INTO TRefRelationshipTypeAudit([RelationshipTypeName], [ArchiveFg], [PersonFg], [CorporateFg], [TrustFg], [AccountFg], [Extensible],[ConcurrencyId], [RefRelationshipTypeId], [StampAction], [StampDateTime], [StampUser])
			WHERE RefRelationshipTypeId = 23

						SET IDENTITY_INSERT TRefRelationshipType ON
			IF NOT EXISTS(SELECT 1 FROM [crm].[dbo].[TRefRelationshipType] WHERE RefRelationshipTypeId = @SettlorForTrustRelationshipTypeId)
            BEGIN
				INSERT INTO TRefRelationshipType([RefRelationshipTypeId], [RelationshipTypeName], [ArchiveFg], [PersonFg], [CorporateFg], [TrustFg], [AccountFg], [Extensible],[ConcurrencyId])
				OUTPUT
					inserted.RelationshipTypeName,
					inserted.ArchiveFg,
					inserted.PersonFg,
					inserted.CorporateFg,
					inserted.TrustFg,
					inserted.AccountFg,
					inserted.Extensible,
					inserted.ConcurrencyId,
					inserted.RefRelationshipTypeId,
					'C ',
					GETUTCDATE(),
					0
					INTO TRefRelationshipTypeAudit([RelationshipTypeName], [ArchiveFg], [PersonFg], [CorporateFg], [TrustFg], [AccountFg], [Extensible],[ConcurrencyId], [RefRelationshipTypeId], [StampAction], [StampDateTime], [StampUser])
				VALUES (@SettlorForTrustRelationshipTypeId,'Settlor', 0, 1, 1, 1, 0, NULL, 3)
			END
            IF NOT EXISTS(SELECT 1 FROM [crm].[dbo].[TRefRelationshipType] WHERE RefRelationshipTypeId = @TrustForSettlorRelationshipTypeId)
            BEGIN
				INSERT INTO TRefRelationshipType([RefRelationshipTypeId], [RelationshipTypeName], [ArchiveFg], [PersonFg], [CorporateFg], [TrustFg], [AccountFg], [Extensible],[ConcurrencyId])
				OUTPUT
					inserted.RelationshipTypeName,
					inserted.ArchiveFg,
					inserted.PersonFg,
					inserted.CorporateFg,
					inserted.TrustFg,
					inserted.AccountFg,
					inserted.Extensible,
					inserted.ConcurrencyId,
					inserted.RefRelationshipTypeId,
					'C ',
					GETUTCDATE(),
					0
					INTO TRefRelationshipTypeAudit([RelationshipTypeName], [ArchiveFg], [PersonFg], [CorporateFg], [TrustFg], [AccountFg], [Extensible],[ConcurrencyId], [RefRelationshipTypeId], [StampAction], [StampDateTime], [StampUser])
				VALUES (@TrustForSettlorRelationshipTypeId,'Trust (for Settlor)', 0, 0, 0, 1, 0, NULL, 3)
            END
            SET IDENTITY_INSERT TRefRelationshipType OFF

            INSERT INTO TRefRelationshipTypeLink([RefRelTypeId], [RefRelCorrespondTypeId], [Extensible], [ConcurrencyId])
            OUTPUT
                inserted.RefRelTypeId,
                inserted.RefRelCorrespondTypeId,
                inserted.Extensible,
                inserted.ConcurrencyId,
                inserted.RefRelationshipTypeLinkId,
                'C',
				GETUTCDATE(),
				0
                INTO TRefRelationshipTypeLinkAudit([RefRelTypeId], [RefRelCorrespondTypeId], [Extensible], [ConcurrencyId], [RefRelationshipTypeLinkId], [StampAction], [StampDateTime], [StampUser])
            VALUES(@TrustForSettlorRelationshipTypeId, @SettlorForTrustRelationshipTypeId, NULL, 1)

			INSERT INTO TRefRelationshipTypeLink([RefRelTypeId], [RefRelCorrespondTypeId], [Extensible], [ConcurrencyId])
            OUTPUT
                inserted.RefRelTypeId,
                inserted.RefRelCorrespondTypeId,
                inserted.Extensible,
                inserted.ConcurrencyId,
                inserted.RefRelationshipTypeLinkId,
                'C',
				GETUTCDATE(),
				0
                INTO TRefRelationshipTypeLinkAudit([RefRelTypeId], [RefRelCorrespondTypeId], [Extensible], [ConcurrencyId], [RefRelationshipTypeLinkId], [StampAction], [StampDateTime], [StampUser])
            VALUES(@SettlorForTrustRelationshipTypeId, @TrustForSettlorRelationshipTypeId, NULL, 1)

    -- END DATA INSERT/UPDATE
            INSERT TExecutedDataScript(ScriptGuid, Comments, TenantId, Timestamp) VALUES (@ScriptGUID, @Comments, null, getdate())

        IF @starttrancount = 0
            COMMIT TRANSACTION

END TRY
BEGIN CATCH

       DECLARE @ErrorSeverity INT
       DECLARE @ErrorState INT
       DECLARE @ErrorLine INT
       DECLARE @ErrorNumber INT

       SELECT @ErrorMessage = ERROR_MESSAGE(),
       @ErrorSeverity = ERROR_SEVERITY(),
       @ErrorState = ERROR_STATE(),
       @ErrorNumber = ERROR_NUMBER(),
       @ErrorLine = ERROR_LINE()

       /*Insert into logging table - IF ANY    */

        IF XACT_STATE() <> 0 AND @starttrancount = 0
            ROLLBACK TRANSACTION

       RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;