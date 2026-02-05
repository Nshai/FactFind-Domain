USE [crm]

DECLARE
    @ScriptGUID UNIQUEIDENTIFIER,
    @Comments VARCHAR(255)

/*
Summary
----------------------------------------------------------------------
Removing diplicated RelationshipType
DatabaseName    TableName                  Expected Rows
-----------------------------------------------------
crm             TRefRelationshipTypeLink   2
*/

SELECT
    @ScriptGUID = 'F21E81E7-5C01-4B68-ACFA-04D087555E51',
    @Comments = 'DEF-11130 [Internally raised] Duplicated Relationship type [Partner] is displayed in [Add Relationship] pop up in [Relationship] dropdown for a Corporate client'

IF EXISTS (SELECT 1 FROM [TExecutedDataScript] WHERE [ScriptGUID] = @ScriptGUID)
    RETURN

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY
    BEGIN TRANSACTION

    DECLARE
        @duplicatedRefRelCorrespondTypeId INT = 278,
		@duplicatedRefRelTypeId INT = 7,
		@stampDateTime DATETIME = GETUTCDATE(),
		@stampAction CHAR(1) = 'D',
		@stampUser INT = 0

    DELETE [TRefRelationshipTypeLink]
    OUTPUT
        deleted.[RefRelTypeId],
        deleted.[RefRelCorrespondTypeId],
        deleted.[Extensible],
        deleted.[ConcurrencyId],
        deleted.[RefRelationshipTypeLinkId],
        @stampAction,
        @stampDateTime,
        @stampUser
    INTO
        [TRefRelationshipTypeLinkAudit](
            [RefRelTypeId],
            [RefRelCorrespondTypeId],
            [Extensible],
            [ConcurrencyId],
			[RefRelationshipTypeLinkId],
            [StampAction],
            [StampDateTime],
            [StampUser]
        )
    WHERE
	(RefRelTypeId = @duplicatedRefRelTypeId AND RefRelCorrespondTypeId = @duplicatedRefRelCorrespondTypeId)
	OR
	(RefRelTypeId = @duplicatedRefRelCorrespondTypeId AND RefRelCorrespondTypeId = @duplicatedRefRelTypeId)

    INSERT [TExecutedDataScript] ([ScriptGUID], [Comments]) VALUES (@ScriptGUID, @Comments)

    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        THROW
END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN