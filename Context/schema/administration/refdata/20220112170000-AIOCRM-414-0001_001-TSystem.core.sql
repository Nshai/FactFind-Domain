USE administration;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @ErrorMessage VARCHAR(MAX)

DECLARE @SystemIdsTmp TABLE (InsertedSystemId int)
Declare @PersonalSystemId int

SELECT
    @ScriptGUID = '25E6A25E-4217-4D94-99AC-84BF31D0D328',
    @Comments = 'AIOCRM-414 Add core permissions'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary:
--   Add new system pathes within adviserworkplace.client.details

-- Expected row counts: 6 row(s) affected
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

    INSERT INTO TSystem (
        Identifier
        ,Description
        ,SystemPath
        ,SystemType
        ,ParentId
        ,Url
        ,ConcurrencyId
    )
    OUTPUT inserted.SystemId
    INTO @SystemIdsTmp (InsertedSystemId)
    VALUES 
        ('proofidentity', 'ID (USA)', 'adviserworkplace.clients.details.proofofidentity', '-view', 325, NULL, 1),
        ('employment', 'Employment', 'adviserworkplace.clients.details.employment', '-view', 325, NULL, 1),
        ('financeandtax', 'Finance & Tax', 'adviserworkplace.clients.details.financeandtax', '-view', 325, NULL, 1);

    INSERT INTO TSystemAudit(
        SystemId
        ,Identifier
        ,Description
        ,SystemPath
        ,SystemType
        ,ParentId
        ,ConcurrencyId
        ,StampAction
        ,StampDateTime
        ,StampUser
    )
    SELECT
        SystemId
        ,Identifier
        ,Description
        ,SystemPath
        ,SystemType
        ,ParentId
        ,ConcurrencyId
        ,'C'
        ,@CurrentDateTime
        ,@StampUser 
    FROM TSystem
    WHERE SystemId IN (SELECT InsertedSystemId FROM @SystemIdsTmp)

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
