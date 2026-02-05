USE administration;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @ErrorMessage VARCHAR(MAX)

SELECT
    @ScriptGUID = '39FB51D7-D8E7-494C-BC6A-D1C7214A92DF',
    @Comments = 'DEF-7133 Fact Find navigation is broken for Trust/Corporate clients'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary:
--   Add missing System Paths to TSystem
--   Add new System Paths for license types

-- Expected row counts: ~ 10000 row(s) affected
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

            -- BEGIN DATA INSERT/UPDATE/DELETE

                DECLARE @CurrentDateTime datetime = GETUTCDATE()
                DECLARE @StampUser int = 0

                DECLARE @SystemIdsTmp TABLE (SystemId int, ParentId int)

                -- ADD new SystemPaths to TSystem & assigned those to all licenses

                INSERT INTO TSystem (Identifier, Description, SystemPath, SystemType, ParentId, Url, ConcurrencyId)
                OUTPUT inserted.SystemId, inserted.ParentId
                INTO @SystemIdsTmp (SystemId, ParentId)
                VALUES 
                       ('declaration', 'Declaration', 'adviserworkplace.clients.factfind.declaration', '-view', 1342, NULL, 1),
                       ('corporateprofile', 'Corporate Profile', 'adviserworkplace.clients.factfind.corporateprofile', '-view', 1342, NULL, 1),
                       ('corporateclienttype', 'Corporate Client Type', 'adviserworkplace.clients.factfind.corporateclienttype', '-view', 1342, NULL, 1),
                       ('corporateemployees', 'Corporate Employees', 'adviserworkplace.clients.factfind.corporateemployees', '-view', 1342, NULL, 1),
                       ('corporateprotection', 'Corporate Protection', 'adviserworkplace.clients.factfind.corporateprotection', '-view', 1342, NULL, 1),
                       ('corporateretirementplanning', 'Corporate Retirement Planning', 'adviserworkplace.clients.factfind.corporateretirementplanning', '-view', 1342, NULL, 1),
                       ('corporatebusinessinvestment', 'Corporate Business Investment', 'adviserworkplace.clients.factfind.corporatebusinessinvestment', '-view', 1342, NULL, 1);

                INSERT INTO TSystemAudit(SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser)
                SELECT SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, 'C', @CurrentDateTime, @StampUser 
                FROM TSystem
                WHERE SystemId IN (SELECT SystemId FROM @SystemIdsTmp)

                INSERT INTO TRefLicenseTypeToSystem (RefLicenseTypeId, SystemId, ConcurrencyId)
                OUTPUT inserted.RefLicenseTypeId, inserted.SystemId, 1, inserted.RefLicenseTypeToSystemId, 'C', @CurrentDateTime, @StampUser
                INTO TRefLicenseTypeToSystemAudit (RefLicenseTypeId, SystemId, ConcurrencyId, RefLicenseTypeToSystemId, StampAction, StampDateTime, StampUser)
                SELECT l.RefLicenseTypeId, s.SystemId, 1
                    FROM TRefLicenseType l 
                        CROSS JOIN @SystemIdsTmp s
                        INNER JOIN TRefLicenseTypeToSystem lts ON s.ParentId = lts.SystemId AND l.RefLicenseTypeId = lts.RefLicenseTypeId

            -- END DATA INSERT/UPDATE/DELETE

        INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

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

        /*Insert into logging table - IF ANY    */

    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF