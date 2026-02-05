USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @MiReportsSystemId INT
      , @DataSharingSystemId INT
      , @StampDateTime DATETIME = GETUTCDATE()
      , @StampAction CHAR(1) = 'C'
      , @StampUser INT = 0
      , @ConcurrencyId INT = 1

SELECT @ScriptGUID = '053E9C66-2102-464B-B095-A36E941861F9'
      ,@Comments = 'IOSMI-1218 TRefLicenseTypeToSystem Add new security items by functional area for Data Sharing to specified license types'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

/*
Expected row counts:

DatabaseName        TableName                       Expected Rows
=================================================================
administration      TRefLicenseTypeToSystem               5
administration      TRefLicenseTypeToSystemAudit          5
*/

SET @MiReportsSystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = 'mi')
SET @DataSharingSystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = 'mi.datasharing')

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY

    BEGIN TRANSACTION

        -- Add datasharing node to license types
        IF NOT EXISTS (SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @DataSharingSystemId)
        BEGIN
            INSERT INTO [dbo].[TRefLicenseTypeToSystem]
                ([RefLicenseTypeId]
                ,[SystemId]
                ,[ConcurrencyId])
            OUTPUT
                 INSERTED.[RefLicenseTypeId]
                ,INSERTED.[SystemId]
                ,INSERTED.[ConcurrencyId]
                ,INSERTED.[RefLicenseTypeToSystemId]
                ,@StampAction
                ,@StampDateTime
                ,@StampUser
            INTO [dbo].[TRefLicenseTypeToSystemAudit]
                ([RefLicenseTypeId]
                ,[SystemId]
                ,[ConcurrencyId]
                ,[RefLicenseTypeToSystemId]
                ,[StampAction]
                ,[StampDateTime]
                ,[StampUser])
            SELECT
                 [RefLicenseTypeId]
                ,@DataSharingSystemId
                ,@ConcurrencyId
            FROM [dbo].[TRefLicenseTypeToSystem]
            WHERE SystemId = @MiReportsSystemId
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