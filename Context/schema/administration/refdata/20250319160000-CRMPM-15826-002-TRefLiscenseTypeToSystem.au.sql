USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
    , @Comments VARCHAR(255)
	, @Comments2 VARCHAR(255)
    , @SystemId INT
	, @SystemId2 INT
    , @SystemPath NVARCHAR(255) = 'adviserworkplace.servicing'
	, @SystemPath2 NVARCHAR(255) = 'adviserworkplace.servicing.feeconsent'
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
administration      TRefLicenseTypeToSystem         2
administration      TRefLicenseTypeToSystemAudit    2
*/

SELECT
    @ScriptGUID = '57DA7E85-89DE-403C-8D81-008B2037D94C',
    @Comments = 'CRMPM-15826: CRM - AU Fee Consent - New Fee Consent Screen- Grid'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON



BEGIN TRY

    BEGIN TRANSACTION

        IF NOT EXISTS (SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE [SystemId] = @SystemId)
		
        BEGIN
			SET @SystemId = (SELECT [SystemId] FROM [dbo].[TSystem] WHERE [SystemPath] = @SystemPath)

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

		IF NOT EXISTS (SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE [SystemId] = @SystemId2)
		
        BEGIN
			SET @SystemId2 = (SELECT [SystemId] FROM [dbo].[TSystem] WHERE [SystemPath] = @SystemPath2)

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
                , @SystemId2
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