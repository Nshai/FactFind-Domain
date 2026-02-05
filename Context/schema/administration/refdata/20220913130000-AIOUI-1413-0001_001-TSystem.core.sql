USE administration;

DECLARE
    @ScriptGUID UNIQUEIDENTIFIER,
    @Comments VARCHAR(255),
    @ErrorMessage VARCHAR(MAX);

SELECT
    @ScriptGUID = '2DA534DD-B1D5-428D-ADC9-F0F2A6A33D5B',
    @Comments = 'AIOUI-1413 Permission for Transfer Exceptions page';

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE [ScriptGUID] = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Add permission for Transfer Exceptions Page.

-- Expected row counts:
-- (2 row(s) affected)
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE
    @TRANCOUNT INT,
    @PortfolioReportsSystemId INT;

BEGIN TRY
    SET @PortfolioReportsSystemId = (
        SELECT TOP 1
            [SystemId]
        FROM
            TSystem
        WHERE
            [SystemPath] = 'portfolioreporting.reports' AND [SystemType] = '-system'
    );

    IF @PortfolioReportsSystemId IS NULL
        RAISERROR('portfolioreporting.reports SystemPath not found', 11, 1);

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
        GETUTCDATE(),
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
        'transferexceptions',
        'Transfer Exceptions',
        'portfolioreporting.reports.transferexceptions',
        '-function',
        @PortfolioReportsSystemId,
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
