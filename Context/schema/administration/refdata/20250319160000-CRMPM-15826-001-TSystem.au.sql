USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
    , @Comments VARCHAR(255)
    , @SystemIdentifier NVARCHAR(255) = 'servicing'
	, @SystemIdentifier2 NVARCHAR(255) = 'feeconsent'
    , @SystemDescription NVARCHAR(255) = 'Servicing'
	, @SystemDescription2 NVARCHAR(255) = 'Fee Consent'
    , @SystemType VARCHAR(10) = '-system'
	, @SystemType2 VARCHAR(10) = '-system'
    , @SystemPath NVARCHAR(255) = 'adviserworkplace.servicing'
	, @SystemPath2 NVARCHAR(255) = 'adviserworkplace.servicing.feeconsent'
    , @ParentSystemId INT
	, @ParentSystemId2 INT
    , @ParentSystemPath NVARCHAR(255) = 'adviserworkplace'
	, @ParentSystemPath2 NVARCHAR(255) = 'adviserworkplace.servicing'
    , @StampDateTime DATETIME = GETUTCDATE()
    , @StampAction CHAR(1) = 'C'
    , @StampUser INT = 0
    , @ConcurrencyId INT = 1

/*
Summary
=================================================================
CRMPM-15826: CRM - AU Fee Consent - New Fee Consent Screen- Grid

DatabaseName        TableName                       Expected Rows
=================================================================
administration      TSystem                         2
administration      TSystemAudit                    2
*/

SELECT
    @ScriptGUID = '1BB02079-99A5-472F-9282-A742F8957F61',
    @Comments = 'CRMPM-15826: CRM - AU Fee Consent - New Fee Consent Screen- Grid'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON



BEGIN TRY

    BEGIN TRANSACTION

		SET @ParentSystemId = (SELECT [SystemId] FROM [dbo].[TSystem] WHERE [SystemPath] = @ParentSystemPath)

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

		SET @ParentSystemId2 = (SELECT [SystemId] FROM [dbo].[TSystem] WHERE [SystemPath] = @ParentSystemPath2)

        IF NOT EXISTS (SELECT 1 FROM [dbo].[TSystem] WHERE [SystemPath] = @SystemPath2)
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
                (@SystemIdentifier2
                , @SystemDescription2
                , @SystemPath2
                , @SystemType2
                , @ParentSystemId2
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