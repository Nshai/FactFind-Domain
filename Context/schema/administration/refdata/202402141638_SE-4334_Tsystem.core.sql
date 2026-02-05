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
Addition of a new template for download and upload for Update tag in the tables Tsystem and TRefLicenseTypeToSystem.
DatabaseName
administration
*/

SELECT @ScriptGUID = '130B89F0-BA01-4D6C-BB8B-2D47764F612F'
     ,@Comments = 'SE-4334 TSystem Add Security Key for Download Template - Update tag'
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
        SET @systemPath = 'home.uploads.datauploader.Updatetag'
        SELECT @AddImportId = SystemId FROM TSystem WHERE SystemPath = @systemPath

    BEGIN TRANSACTION
        IF(ISNULL(@AddImportId, 0) = 0)
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM TSystem WHERE Identifier = 'Updatetag')
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
                SELECT 'Updatetag',
                       'Update Tag',
                       @systemPath,
                       '-action',
                       @ParentSystemId,
                       NULL,
                       NULL,
                       1
                END

                SELECT @SystemId = SystemId FROM TSystem WHERE Identifier = 'Updatetag'

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