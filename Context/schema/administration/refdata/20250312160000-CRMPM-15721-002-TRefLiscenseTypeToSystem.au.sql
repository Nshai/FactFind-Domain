USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
    , @Comments VARCHAR(255)
    , @SystemId INT
    , @SystemPath NVARCHAR(255) = 'client.actions.changeFeeConsentRefDate'
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
administration      TRefLicenseTypeToSystem         1
administration      TRefLicenseTypeToSystemAudit    1
*/

SELECT
    @ScriptGUID = 'E77866E6-4C53-43C0-807A-9506059D9473',
    @Comments = 'CRMPM-15721: CRM - AU Fee Consent - New Client Action -Change Fee Consent Ref Date -TRefLicenseTypeToSystem'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

SET @SystemId = (SELECT [SystemId] FROM [dbo].[TSystem] WHERE [SystemPath] = @SystemPath)

BEGIN TRY

    BEGIN TRANSACTION

        IF NOT EXISTS (SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE [SystemId] = @SystemId)
        BEGIN

            INSERT INTO [dbo].[TRefLicenseTypeToSystem]
                ([RefLicenseTypeId]
                , [SystemId]
                , [ConcurrencyId])
            OUTPUT
                INSERTED.[RefLicenseTypeToSystemId]
                , INSERTED.[RefLicenseTypeId]
                , INSERTED.[SystemId]
                , INSERTED.[ConcurrencyId]
                , @StampAction
                , @StampDateTime
                , @StampUser
            INTO [dbo].[TRefLicenseTypeToSystemAudit]
                ([RefLicenseTypeToSystemId]
                , [RefLicenseTypeId]
                , [SystemId]
                , [ConcurrencyId]
                , [StampAction]
                , [StampDateTime]
                , [StampUser])
            SELECT
                [RefLicenseTypeId]
                , @SystemId
                , @ConcurrencyId
            FROM [dbo].[TRefLicenseType]
            WHERE  LicenseTypeName IN ('full')

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