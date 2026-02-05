USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
        ,@Comments VARCHAR(255)
        ,@systemPath VARCHAR(255)
        ,@ParentSystemId INT
        ,@StampDateTime DATETIME
        ,@AddImportId INT
        ,@StampActionCreate CHAR(1)
        ,@StampUser INT
        ,@RefLicenseTypeIdFull INT
        ,@SystemId INT

/*
Summary
Addition of a new template for download and upload for Update Adviser Gating in the tables Tsystem and TRefLicenseTypeToSystem.
DatabaseName
administration
*/

SELECT @ScriptGUID = '1824A65F-9D00-4028-8359-145C8204B514'
     ,@Comments = 'SE-6028 TSystem Add Security Key for Download Template - Update Adviser Gating'
     ,@StampActionCreate = 'C'
     ,@StampDateTime = getdate()
     ,@StampUser = 0

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY

        SELECT @ParentSystemId = SystemId FROM TSystem WHERE SystemPath = 'home.uploads.datauploader'
        SELECT @RefLicenseTypeIdFull = RefLicenseTypeId FROM TRefLicenseType WHERE LicenseTypeName = 'Full'

        IF (ISNULL(@ParentSystemId, 0) = 0)
            RETURN;

        SET @StampDateTime = GETDATE()
        SET @systemPath = 'home.uploads.datauploader.updateadvisergating'
        SELECT @AddImportId = SystemId FROM TSystem WHERE SystemPath = @systemPath

    BEGIN TRANSACTION
        IF(ISNULL(@AddImportId, 0) = 0)
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM TSystem WHERE Identifier = 'updateadvisergating')
                BEGIN

                INSERT INTO TSystem(Identifier,
                                    [Description],
                                    SystemPath,
                                    SystemType,
                                    ParentId,
                                    Url,
                                    EntityId,
                                    ConcurrencyId)
                OUTPUT inserted.Identifier,
                                   inserted.[Description],
                                   inserted.SystemPath,
                                   inserted.SystemType,
                                   inserted.ParentId,
                                   inserted.Url,
                                   inserted.EntityId,
                                   inserted.ConcurrencyId,
                                   inserted.SystemId,
                                   @StampActionCreate,
                                   @StampDateTime,
                                   @StampUser 
                            INTO TSystemAudit (Identifier,
                                   [Description],
                                   SystemPath,
                                   SystemType,
                                   ParentId,
                                   Url,
                                   EntityId,
                                   ConcurrencyId, 
                                   SystemId,
                                   StampAction,
                                   StampDateTime,
                                   StampUser)
                SELECT 'updateadvisergating',
                       'Update Adviser Gating',
                       @systemPath,
                       '-action',
                       @ParentSystemId,
                       NULL,
                       NULL,
                       1
                END

                SELECT @SystemId = SystemId FROM TSystem WHERE Identifier = 'updateadvisergating'

                IF(@RefLicenseTypeIdFull IS NOT NULL)
                 BEGIN
                    IF NOT EXISTS (SELECT 1 FROM TRefLicenseTypeToSystem WHERE SystemID = @SystemId AND RefLicenseTypeId = @RefLicenseTypeIdFull)

                    BEGIN
                    INSERT INTO TRefLicenseTypeToSystem(RefLicenseTypeId,
                                                        SystemId,
                                                        ConcurrencyId)
                    OUTPUT inserted.RefLicenseTypeId,
                                               inserted.SystemId,
                                               inserted.ConcurrencyId, 
                                               inserted.RefLicenseTypeToSystemId,
                                               @StampActionCreate,
                                               @StampDateTime,
                                               @StampUser 
                                        INTO TRefLicenseTypeToSystemAudit (RefLicenseTypeId,
                                        SystemId,
                                        ConcurrencyId,
                                        RefLicenseTypeToSystemId,
                                        StampAction,
                                        StampDateTime,
                                        StampUser)
                    SELECT @RefLicenseTypeIdFull,
                           @SystemId,
                           1
                END
        END
        END

        INSERT TExecutedDataScript (ScriptGUID,Comments) VALUES (@ScriptGUID,@Comments)
    COMMIT TRANSACTION

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;