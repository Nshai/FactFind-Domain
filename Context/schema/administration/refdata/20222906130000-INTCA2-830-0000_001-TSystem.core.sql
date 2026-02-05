USE administration;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @ErrorMessage VARCHAR(MAX)

SELECT
    @ScriptGUID = 'A8C8077C-C107-492E-A967-679EED588BE7',
    @Comments = 'INTCA2-830 Add TSystem keys not covered in the INTCA2-149'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary:
--   Add missing System Paths to TSystem
--   Update TRefLicenseTypeToSystem
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

        -- BEGIN DATA INSERT/UPDATE/DELETE

            DECLARE @CurrentDateTime DATETIME = GETUTCDATE()
            DECLARE @StampUser INT = 0
            DECLARE @SystemIdsTmp TABLE (SystemId int, ParentId int)

            -- ADD new SystemPath to TSystem & assigned those to all licenses
            
            INSERT INTO TSystem (Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId)
            OUTPUT inserted.SystemId, inserted.ParentId
            INTO @SystemIdsTmp (SystemId, ParentId)
            VALUES
                -- Adviser Workplace -> Clients -> Plans
                ('excludedfromschedules', 'Excluded from Schedules', 'adviserworkplace.clients.plans.excludedfromschedules', '-view', 336, 1),
                ('clientview', 'Client View', 'adviserworkplace.clients.plans.clientview', '-view', 336, 1),
                ('unscheduledvaluations', 'Unscheduled Valuations', 'adviserworkplace.clients.plans.unscheduledvaluations', '-view', 336, 1),
                ('scheduledvaluations', 'Scheduled Valuations', 'adviserworkplace.clients.plans.scheduledvaluations', '-view', 336, 1),
                ('valuations', 'Valuations', 'adviserworkplace.clients.plans.valuations', '-view', 336, 1),
                ('assets', 'Assets', 'adviserworkplace.clients.plans.assets', '-view', 336, 1),
                -- Adviser Workplace -> Clients -> Fees
                ('feeinvoice', 'Fee Invoice', 'adviserworkplace.clients.fees.feeinvoice', '-view', 353, 1),
                -- Administration -> Organisation -> Price Maintenance
                ('sedolconfiguration', 'SEDOL Configuration', 'administration.organisation.pricemaintenance.sedolconfiguration', '-view', 1018, 1),
                -- Administration -> Organisation -> Groups
                ('tradingstyle', 'Trading Style', 'administration.organisation.groups.tradingstyle', '-view', 509, 1),
                -- Administration -> Organisation -> Leads
                ('postcodeallocation', 'Postcode Allocation', 'administration.organisation.leadadmin.postcodeallocation', '-view', 1281, 1),
                ('postcodepatches', 'Postcode Patches', 'administration.organisation.leadadmin.postcodepatches', '-view', 1281, 1),
                ('managepostcodes', 'Manage Postcodes', 'administration.organisation.leadadmin.managepostcodes', '-view', 1281, 1),
                -- Administration -> Group Reference Data -> Group Tasks
                ('eventlisttemplates', 'Event List Templates', 'administration.groupreferencedata.grouptasks.eventlisttemplates', '-view', 1279, 1)

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

            UPDATE TSystem
                SET SystemPath = 'administration.groupreferencedata', ConcurrencyId = ConcurrencyId + 1
            OUTPUT deleted.SystemId, deleted.Identifier, deleted.Description, deleted.SystemPath, deleted.SystemType, deleted.ParentId, 1, 'U', @CurrentDateTime, @StampUser, deleted.Url
            INTO TSystemAudit (SystemId, Identifier, Description, SystemPath, SystemType, ParentId, ConcurrencyId, StampAction, StampDateTime, StampUser, Url)
                WHERE SystemPath = 'administration.groupreferencedata.grouptasks' AND SystemId = 1278;

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
        DECLARE @ErrorProc sysname

        SELECT @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE(),
        @ErrorNumber = ERROR_NUMBER(),
        @ErrorLine = ERROR_LINE(),
        @ErrorProc = ERROR_PROCEDURE()

        /*Insert into logging table - IF ANY    */

    IF XACT_STATE() <> 0 AND @starttrancount = 0
        ROLLBACK TRANSACTION

    RAISERROR ('ErrorNo: %d, Severity: %d, State: %d, Procedure: %s, Line %d, Message %s',
        1,1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProc, @ErrorLine, @ErrorMessage);

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;