USE crm;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
      , @TrustForSettlorRelationshipTypeId INT
      , @SettlorForTrustRelationshipTypeId INT

SELECT
    @ScriptGUID = '67812EE7-FF95-4B57-8927-29D4350C3189',
    @Comments = 'REVERT INTTFF-414'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Revert INTTFF-414
-- Expected row affected: 4 + 4 audit
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

            DELETE FROM [crm].[dbo].[TRelationship]
            OUTPUT
                deleted.[RefRelTypeId],
                deleted.[RefRelCorrespondTypeId],
                deleted.[CRMContactFromId],
                deleted.[CRMContactToId],
                deleted.[ExternalContact],
                deleted.[ExternalURL],
                deleted.[OtherRelationship],
                deleted.[IsPartnerFg],
                deleted.[IsFamilyFg],
                deleted.[IsPointOfContactFg],
                deleted.[IncludeInPfp],
                deleted.[ReceivedAccessType],
                deleted.[ReceivedAccessAt],
                deleted.[ReceivedAccessByUserId],
                deleted.[GivenAccessType],
                deleted.[GivenAccessAt],
                deleted.[GivenAccessByUserId],
                deleted.[Extensible],
                deleted.[ConcurrencyId],
                deleted.[RelationshipId],
                'D ',
				GETUTCDATE(),
				0,
                deleted.[StartedAt],
                deleted.[MigrationRef]
            INTO [crm].[dbo].[TRelationshipAudit]([RefRelTypeId]
                ,[RefRelCorrespondTypeId]
                ,[CRMContactFromId]
                ,[CRMContactToId]
                ,[ExternalContact]
                ,[ExternalURL]
                ,[OtherRelationship]
                ,[IsPartnerFg]
                ,[IsFamilyFg]
                ,[IsPointOfContactFg]
                ,[IncludeInPfp]
                ,[ReceivedAccessType]
                ,[ReceivedAccessAt]
                ,[ReceivedAccessByUserId]
                ,[GivenAccessType]
                ,[GivenAccessAt]
                ,[GivenAccessByUserId]
                ,[Extensible]
                ,[ConcurrencyId]
                ,[RelationshipId]
                ,[StampAction]
                ,[StampDateTime]
                ,[StampUser]
                ,[StartedAt]
                ,[MigrationRef])
            WHERE RefRelTypeId in (@TrustForSettlorRelationshipTypeId, @SettlorForTrustRelationshipTypeId) and RefRelCorrespondTypeId in (@TrustForSettlorRelationshipTypeId, @SettlorForTrustRelationshipTypeId) 

            DELETE FROM [crm].[dbo].[TRefRelationshipTypeLink]
            OUTPUT
                deleted.RefRelTypeId,
                deleted.RefRelCorrespondTypeId,
                deleted.Extensible,
                deleted.ConcurrencyId,
                deleted.RefRelationshipTypeLinkId,
                'D',
				GETUTCDATE(),
				0
                INTO TRefRelationshipTypeLinkAudit([RefRelTypeId], [RefRelCorrespondTypeId], [Extensible], [ConcurrencyId], [RefRelationshipTypeLinkId], [StampAction], [StampDateTime], [StampUser])
            WHERE RefRelTypeId in (@TrustForSettlorRelationshipTypeId, @SettlorForTrustRelationshipTypeId) and RefRelCorrespondTypeId in (@TrustForSettlorRelationshipTypeId, @SettlorForTrustRelationshipTypeId)

			UPDATE [crm].[dbo].[TRefRelationshipType]
	            SET [crm].[dbo].[TRefRelationshipType].[ArchiveFg] = 0
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

            DELETE FROM [crm].[dbo].[TRefRelationshipType]
			OUTPUT
                deleted.RelationshipTypeName,
                deleted.ArchiveFg,
                deleted.PersonFg,
                deleted.CorporateFg,
                deleted.TrustFg,
                deleted.AccountFg,
                deleted.Extensible,
                deleted.ConcurrencyId,
				deleted.RefRelationshipTypeId,
                'D ',
				GETUTCDATE(),
				0
			INTO TRefRelationshipTypeAudit([RelationshipTypeName], [ArchiveFg], [PersonFg], [CorporateFg], [TrustFg], [AccountFg], [Extensible],[ConcurrencyId], [RefRelationshipTypeId], [StampAction], [StampDateTime], [StampUser])
			WHERE RefRelationshipTypeId in (@TrustForSettlorRelationshipTypeId, @SettlorForTrustRelationshipTypeId) and RelationshipTypeName in ('Trust (for Settlor)', 'Settlor')



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