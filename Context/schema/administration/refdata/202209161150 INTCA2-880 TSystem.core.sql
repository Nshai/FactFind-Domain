USE [administration];

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
      , @SystemID VARCHAR(MAX)
      , @ParentSystemID VARCHAR(MAX)
      , @StampDateTime DATETIME
      , @StampUser INT

SELECT 
    @ScriptGUID = '858BD012-1C0A-4B6A-9290-1007B22CDD78',
    @Comments = 'INTCA2-880 - Add permissions for IO Store link',
    @StampDateTime = GETUTCDATE(),
    @StampUser = 0

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Rename security key to manage access to Account Opening functionality

-- Expected row counts: - if you know this
-- TSystem (~370 row(s) affected)
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

    INSERT INTO administration..TSystem ([Identifier],[Description],[SystemPath],[SystemType],[ConcurrencyId])
    OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, inserted.ConcurrencyId, 'C', @StampDateTime, @StampUser, inserted.Url
    INTO administration..TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
    VALUES ('iostore', 'Intelliflo Store', 'iostore', '-application', 1)

    DECLARE @IoStoreSystemId INT

    SELECT @IoStoreSystemId = SystemId FROM administration..TSystem WHERE SystemPath = 'iostore'

    INSERT INTO administration..TRefLicenseTypeToSystem ([RefLicenseTypeId], [SystemId], [ConcurrencyId])
    OUTPUT inserted.RefLicenseTypeToSystemId, inserted.RefLicenseTypeId, inserted.SystemId, inserted.ConcurrencyId, 'C', @StampDateTime, @StampUser
    INTO administration..TRefLicenseTypeToSystemAudit (RefLicenseTypeToSystemId, RefLicenseTypeId, SystemId, ConcurrencyId, StampAction, StampDateTime, StampUser)
    SELECT [RefLicenseTypeId], @IoStoreSystemId, 1 FROM administration..TRefLicenseType

    IF @starttrancount = 0
        COMMIT TRANSACTION

    IF @starttrancount = 0
        BEGIN TRANSACTION

    INSERT INTO administration..TKey ([RightMask],[SystemId],[UserId],[RoleId],[ConcurrencyId])
    OUTPUT inserted.KeyId, inserted.RightMask, inserted.SystemId, inserted.UserId, inserted.RoleId, inserted.ConcurrencyId, 'C', @StampDateTime, @StampUser
    INTO administration..TKeyAudit (KeyId, RightMask, SystemId, UserId, RoleId, ConcurrencyId, StampAction, StampDateTime, StampUser)
    SELECT 1, @IoStoreSystemId, NULL, RoleId, 1
    FROM TRole

    INSERT administration..TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    IF @starttrancount = 0
        COMMIT TRANSACTION

END TRY
BEGIN CATCH

       DECLARE @ErrorSeverity INT
       DECLARE @ErrorState INT
       DECLARE @ErrorLine INT
       DECLARE @ErrorNumber INT

       SELECT @ErrorMessage = ERROR_MESSAGE(),
       @ErrorSeverity = ERROR_SEVERITY(),
       @ErrorState = ERROR_STATE(),
       @ErrorNumber = ERROR_NUMBER(),
       @ErrorLine = ERROR_LINE()

       /*Insert into logging table - IF ANY	*/

    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION
    
       RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;