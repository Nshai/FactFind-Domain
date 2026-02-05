USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
        ,@Comments VARCHAR(255)
        ,@systemPath VARCHAR(255)
        ,@ParentSystemId BIGINT
        ,@StampDateTime DATETIME
        ,@AddImportId bigint
        ,@StampActionCreate CHAR(1)
        ,@StampUser INT
        ,@RefLicenseTypeIdFull BIGINT
        ,@SystemId BIGINT

/*
Summary
Addition of a new template for download and upload for bulk restrict clients in the tables Tsystem and TRefLicenseTypeToSystem.

DatabaseName
administration
*/

SELECT @ScriptGUID = 'A6C46A28-490D-4B34-9382-D1C5BBA8569E'
     ,@Comments = 'SE-3751 TSystem Add Security Key for Download Template - Bulk Restrict Clients'
     ,@StampActionCreate = 'C'
     ,@StampDateTime = getdate()
     ,@StampUser = 0

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY

    BEGIN TRANSACTION

        SELECT @ParentSystemId = SystemId FROM TSystem WHERE SystemPath = 'home.uploads.datauploader'
        SELECT @RefLicenseTypeIdFull = RefLicenseTypeId FROM TRefLicenseType WHERE LicenseTypeName = 'Full'
        
        IF (ISNULL(@ParentSystemId, 0) = 0)
            RETURN;
        
        SET @StampDateTime = GETDATE()
        SET @systemPath = 'home.uploads.datauploader.clientrestrict'
        SELECT @AddImportId = SystemId FROM TSystem WHERE SystemPath = @systemPath
        
        IF(ISNULL(@AddImportId, 0) = 0)
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM TSystem WHERE Identifier = 'clientrestrict')
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
                SELECT 'clientrestrict',
                       'Bulk Restrict Clients',
                       @systemPath,
                       '-action',
                       @ParentSystemId,
                       NULL,
                       NULL,
                       1
                END
                
                SELECT @SystemId = SystemId FROM TSystem WHERE Identifier = 'clientrestrict'
                
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