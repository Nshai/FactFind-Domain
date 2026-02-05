USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
    , @Comments VARCHAR(255)
    , @SystemIdentifier NVARCHAR(255) = 'changeFeeConsentRefDate'
    , @SystemDescription NVARCHAR(255) = 'Change Fee Consent Ref Date'
    , @SystemType VARCHAR(10) = '+subaction'
    , @SystemPath NVARCHAR(255) = 'client.actions.changeFeeConsentRefDate'
    , @ParentSystemId INT
    , @ParentSystemPath NVARCHAR(255) = 'client.add'
    , @StampDateTime DATETIME = GETUTCDATE()
    , @StampAction CHAR(1) = 'C'
    , @StampUser INT = 0
    , @ConcurrencyId INT = 1

/*
Summary
=================================================================
CRMPM-15721: CRM - AU Fee Consent - New Client Action -Change Fee Consent Ref Date

DatabaseName        TableName                       Expected Rows
=================================================================
administration      TSystem                         1
administration      TSystemAudit                    1
*/

SELECT
    @ScriptGUID = '9E3D738A-2270-4739-9C58-87832AE2A04B',
    @Comments = 'CRMPM-15721: CRM - AU Fee Consent - New Client Action -Change Fee Consent Ref Date-TSystem'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

SET @ParentSystemId = (SELECT [SystemId] FROM [dbo].[TSystem] WHERE [SystemPath] = @ParentSystemPath)

BEGIN TRY

    BEGIN TRANSACTION

        IF NOT EXISTS (SELECT 1 FROM [dbo].[TSystem] WHERE [SystemPath] = @SystemPath)
        BEGIN

            INSERT INTO [dbo].[TSystem]
                ([Identifier]
                , [Description]
                , [SystemPath]
                , [SystemType]
                , [ParentId]
                , [ConcurrencyId])
            OUTPUT
                INSERTED.[Identifier]
                , INSERTED.[Description]
                , INSERTED.[SystemPath]
                , INSERTED.[SystemType]
                , INSERTED.[ParentId]
                , INSERTED.[Url]
                , INSERTED.[EntityId]
                , INSERTED.[ConcurrencyId]
                , INSERTED.[SystemId]
                , @StampAction
                , @StampDateTime
                , @StampUser
                , INSERTED.[Order]
            INTO [dbo].[TSystemAudit]
                ([Identifier]
                , [Description]
                , [SystemPath]
                , [SystemType]
                , [ParentId]
                , [Url]
                , [EntityId]
                , [ConcurrencyId]
                , [SystemId]
                , [StampAction]
                , [StampDateTime]
                , [StampUser]
                , [Order])
            VALUES
                (@SystemIdentifier
                , @SystemDescription
                , @SystemPath
                , @SystemType
                , @ParentSystemId
                , @ConcurrencyId)
        END

        INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    COMMIT TRANSACTION

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;