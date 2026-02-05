USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
        ,@Comments VARCHAR(255)
        ,@ErrorMessage VARCHAR(MAX)
        ,@systemPath VARCHAR(255)
        ,@ParentSystemId BIGINT
        ,@StampDateTime DATETIME
        ,@AddImportId bigint
        ,@StampActionCreate CHAR(1)
        ,@StampUser INT
        ,@RefLicenseTypeIdFull BIGINT
        ,@SystemId BIGINT

SELECT @ScriptGUID = 'd3f8a4fc-afa9-485e-9476-d49d33586696'
     ,@Comments = 'IOSE22-1014 TSystem Add Security Key for Download Template - Update Disclosure and Key Facts Documents Issue Date'
     ,@StampActionCreate = 'C'
     ,@StampDateTime = getdate()
     ,@StampUser = 0

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

BEGIN TRANSACTION

    BEGIN TRY
    
        SELECT @ParentSystemId = SystemId FROM TSystem WHERE SystemPath = 'home.uploads.datauploader'
        SELECT @RefLicenseTypeIdFull = RefLicenseTypeId FROM TRefLicenseType WHERE LicenseTypeName = 'Full'
        
        IF (ISNULL(@ParentSystemId, 0) = 0)
            RETURN;
        
        SET @StampDateTime = GETDATE()
        SET @systemPath = 'home.uploads.datauploader.importDisclosureDocuments'
        SELECT @AddImportId = SystemId FROM TSystem WHERE SystemPath = @systemPath
        
        IF(ISNULL(@AddImportId, 0) = 0)
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM TSystem WHERE Identifier = 'importDisclosureDocuments')
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
                SELECT 'importDisclosureDocuments',
                       'Update Disclosure and Key Facts Documents Issue Date',
                       @systemPath,
                       '-action',
                       @ParentSystemId,
                       NULL,
                       NULL,
                       1
                END
                
                SELECT @SystemId = SystemId FROM TSystem WHERE Identifier = 'importDisclosureDocuments'
                
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
    COMMIT TRANSACTION
    INSERT TExecutedDataScript (ScriptGUID,Comments) VALUES (@ScriptGUID,@Comments)
END TRY

BEGIN CATCH
SET @ErrorMessage = ERROR_MESSAGE()
    RAISERROR (@ErrorMessage,16,1)
    WHILE (@@TRANCOUNT > 0)
        ROLLBACK
    RETURN
END CATCH

RETURN;