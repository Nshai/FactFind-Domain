USE administration;

DECLARE
    @ScriptGUID UNIQUEIDENTIFIER,
    @Comments VARCHAR(255),
    @ErrorMessage VARCHAR(MAX);

SELECT
    @ScriptGUID = '8C83301C-9232-46DB-B759-E25BFE0B5B11',
    @Comments = 'AIOUI-345 AiO > Account page add permission for Transaction History tab';

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE [ScriptGUID] = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Add permission for Transaction History tab.

-- Expected row counts:
-- (2 row(s) affected)
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE
    @TRANCOUNT int,
    @PlansSystemId int;

BEGIN TRY
    SET @PlansSystemId = (
        SELECT TOP 1
            [SystemId]
        FROM
            TSystem
        WHERE
            [SystemPath] = 'adviserworkplace.clients.plans' AND [SystemType] = '-function'
    );

    IF @PlansSystemId IS NULL
        RAISERROR('PlanSystem SystemPath not found', 11, 1);

    SELECT @TRANCOUNT = @@TRANCOUNT;

    IF @TRANCOUNT = 0
        BEGIN TRANSACTION;

    INSERT INTO TSystem
    (
        [Identifier],
        [Description],
        [SystemPath],
        [SystemType],
        [ParentId],
        [Url],
        [EntityId],
        [ConcurrencyId]
    )
    OUTPUT
        INSERTED.[SystemId],
        INSERTED.[Identifier],
        INSERTED.[Description],
        INSERTED.[SystemPath],
        INSERTED.[SystemType],
        INSERTED.[ParentId],
        INSERTED.[Url],
        INSERTED.[EntityId],
        INSERTED.[ConcurrencyId],
        'C',
        GETDATE(),
        0
    INTO TSystemAudit
    (
        [SystemId],
        [Identifier],
        [Description],
        [SystemPath],
        [SystemType],
        [ParentId],
        [Url],
        [EntityId],
        [ConcurrencyId],
        [StampAction],
        [StampDateTime],
        [StampUser]
    )
    VALUES
    (
        'transactionhistoryfulllist',
        'Transaction History Full List',
        'adviserworkplace.clients.plans.transactionhistoryfulllist',
        '-view',
        @PlansSystemId,
        NULL,
        NULL,
        1
    );

    INSERT TExecutedDataScript ([ScriptGUID], [Comments]) VALUES (@ScriptGUID, @Comments);

    IF @TRANCOUNT = 0
        COMMIT TRANSACTION;

END TRY
BEGIN CATCH

    DECLARE
        @ErrorSeverity INT,
        @ErrorState INT,
        @ErrorLine INT,
        @ErrorNumber INT;

    SELECT
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE(),
        @ErrorNumber = ERROR_NUMBER(),
        @ErrorLine = ERROR_LINE();

    IF XACT_STATE() <> 0 AND @TRANCOUNT = 0
        ROLLBACK TRANSACTION;

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine);

END CATCH

SET XACT_ABORT OFF;
SET NOCOUNT OFF;

RETURN;
