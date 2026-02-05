USE administration;

DECLARE
    @ScriptGUID UNIQUEIDENTIFIER,
    @Comments VARCHAR(255),
    @ErrorMessage VARCHAR(MAX);

SELECT
    @ScriptGUID = '5B3097D7-2E14-4FEC-977E-83F964B6289E',
    @Comments = 'AIOUI-1413 Transfer Exceptions permission for full license';

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
    @TRANCOUNT INT,
    @TransferExceptionsSystemId INT,
    @FullLicenseTypeId INT;

BEGIN TRY
    SELECT @TRANCOUNT = @@TRANCOUNT;

    SET @TransferExceptionsSystemId = (
        SELECT TOP 1
            [SystemId]
        FROM
            TSystem
        WHERE
            [SystemPath] = 'portfolioreporting.reports.transferexceptions' AND [SystemType] = '-function'
    );

    IF @TransferExceptionsSystemId IS NULL
        RAISERROR('Transfer Exceptions SystemPath not found', 11, 1);

    SET @FullLicenseTypeId = (
        SELECT TOP 1
            [RefLicenseTypeId]
        FROM
            TRefLicenseType
        WHERE
            LOWER([LicenseTypeName]) = 'full'
    );

    IF @FullLicenseTypeId IS NULL
        RAISERROR('Full LicentTypeId not found', 11, 1);

    IF @TRANCOUNT = 0
        BEGIN TRANSACTION;

    INSERT INTO TRefLicenseTypeToSystem
    (
        [RefLicenseTypeId],
        [SystemId],
        [ConcurrencyId]
    )
    OUTPUT
        INSERTED.[RefLicenseTypeId],
        INSERTED.[SystemId],
        INSERTED.[ConcurrencyId],
        INSERTED.[RefLicenseTypeToSystemId],
        'C',
        GETUTCDATE(),
        0
    INTO TRefLicenseTypeToSystemAudit
    (
        [RefLicenseTypeId],
        [SystemId],
        [ConcurrencyId],
        [RefLicenseTypeToSystemId],
        [StampAction],
        [StampDateTime],
        [StampUser]
    )
    VALUES
    (
        @FullLicenseTypeId,
        @TransferExceptionsSystemId,
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
