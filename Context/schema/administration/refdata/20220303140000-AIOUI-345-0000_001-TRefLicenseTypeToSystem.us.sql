USE administration;

DECLARE
    @ScriptGUID UNIQUEIDENTIFIER,
    @Comments VARCHAR(255),
    @ErrorMessage VARCHAR(MAX);

SELECT
    @ScriptGUID = 'A0A5B7EF-4620-4257-9AD8-4D641CD285EE',
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
    @TransactionHistorySystemId int,
    @FullLicenseTypeId int;

BEGIN TRY
    SELECT @TRANCOUNT = @@TRANCOUNT;

    SET @TransactionHistorySystemId = (
        SELECT TOP 1
            [SystemId]
        FROM
            TSystem
        WHERE
            [SystemPath] = 'adviserworkplace.clients.plans.transactionhistoryfulllist' AND [SystemType] = '-view'
    );

    IF @TransactionHistorySystemId IS NULL
        RAISERROR('TransactionHistoryFullList SystemPath not found', 11, 1);

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
        GETDATE(),
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
        @TransactionHistorySystemId,
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
