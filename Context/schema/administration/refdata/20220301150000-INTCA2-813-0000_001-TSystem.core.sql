USE administration;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @ErrorMessage VARCHAR(MAX)

SELECT
    @ScriptGUID = '06C8B3C5-116E-4CBC-96BC-EDF30A7EEEE2',
    @Comments = 'INTCA2-813  Fix AWP -> Clients/Leads/Plans'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary:
--   Add missing System Paths to TSystem
--   Add new System Paths for license types
--   Delete unnecessary System Paths from license types

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
                DECLARE @SystemIdToHide INT
                -- ADD new SystemPaths to TSystem & assigned those to all licenses

                INSERT INTO TSystem (Identifier, Description, SystemPath, SystemType, ParentId, Url, ConcurrencyId)
                OUTPUT inserted.SystemId, inserted.ParentId
                INTO @SystemIdsTmp (SystemId, ParentId)
                VALUES 
                       ('pensionincome', 'Pension Income', 'adviserworkplace.clients.plans.pensionincome', '-view', 336, NULL, 1);

                INSERT INTO TSystemAudit(SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser)
                SELECT SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, 'C', @CurrentDateTime, @StampUser 
                FROM TSystem
                WHERE SystemId IN (SELECT SystemId FROM @SystemIdsTmp)

                INSERT INTO TRefLicenseTypeToSystem (RefLicenseTypeId, SystemId, ConcurrencyId)
                OUTPUT inserted.RefLicenseTypeId, inserted.SystemId, inserted.ConcurrencyId, inserted.RefLicenseTypeToSystemId, 'C', @CurrentDateTime, @StampUser
                INTO TRefLicenseTypeToSystemAudit (RefLicenseTypeId, SystemId, ConcurrencyId, RefLicenseTypeToSystemId, StampAction, StampDateTime, StampUser)
                SELECT lts.RefLicenseTypeId, s.SystemId, 1
                FROM @SystemIdsTmp s
                INNER JOIN TRefLicenseTypeToSystem lts ON s.ParentId = lts.SystemId

                UPDATE TSystem
                SET Description = 'Pensions', ConcurrencyId = ConcurrencyId + 1
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, inserted.ConcurrencyId, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.plans.pension'

                UPDATE TSystem
                SET Description = 'Valuations/Balance', ConcurrencyId = ConcurrencyId + 1
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, inserted.ConcurrencyId, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'adviserworkplace.clients.plans.valuation'

                UPDATE TSystem
                SET SystemType='-liogroup', ConcurrencyId = ConcurrencyId + 1
                OUTPUT inserted.SystemId, inserted.Identifier, inserted.Description, inserted.SystemPath, inserted.SystemType, inserted.ParentId, inserted.ConcurrencyId, 'U', @CurrentDateTime, @StampUser, inserted.Url
                INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath IN (
                    'adviserworkplace.clients.documents.profile',
                    'adviserworkplace.leads.documents.profile',
                    'adviserworkplace.clients.plans.plantaskview',
                    'adviserworkplace.clients.plans.benefit',
                    'adviserworkplace.clients.opportunities.opportunity'
                )
                
                SELECT @SystemIdToHide = SystemId FROM TSystem WHERE SystemPath = 'adviserworkplace.clients.opportunities.opportunity'

                DELETE FROM TRefLicenseTypeToSystem
                OUTPUT deleted.RefLicenseTypeId, deleted.SystemId, deleted.ConcurrencyId, deleted.RefLicenseTypeToSystemId, 'D', @CurrentDateTime, @StampUser
                INTO TRefLicenseTypeToSystemAudit (RefLicenseTypeId, SystemId, ConcurrencyId, RefLicenseTypeToSystemId, StampAction, StampDateTime, StampUser)
                WHERE SystemId = @SystemIdToHide
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