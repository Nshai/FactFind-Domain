USE [Administration];

DECLARE
    @ScriptGUID UNIQUEIDENTIFIER,
    @Comments VARCHAR(255),
    @ErrorMessage VARCHAR(MAX),
    @StampDateTime DATETIME,
    @StampActionCreate CHAR(1),
    @StampUser INT,
    @NewSystemPath VARCHAR(MAX),
    @starttrancount INT,
    @ParentSystemId INT,
    @NewSystemId INT;

SELECT
    @ScriptGUID = '9301b5ca-5dc8-4a72-a9ee-6aca6d0716e5',
    @Comments = 'IOADV-3838 Insert New System for Client Response Templates',
    @StampDateTime = GETUTCDATE(),
    @StampActionCreate = 'C',
    @StampUser = 0,
    @NewSystemPath = 'administration.communication.clientresponsetemplates';

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT;

    IF @starttrancount = 0
        BEGIN TRANSACTION;

    -- Get parent system id (administration.communication)
    SELECT TOP 1 @ParentSystemId = SystemId
    FROM TSystem
    WHERE SystemPath = 'administration.communication';

    -- Insert new system only if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @NewSystemPath)
    BEGIN
        INSERT INTO TSystem (
            Identifier, Description, SystemPath, SystemType, ParentId, Url, EntityId, ConcurrencyId, [Order]
        )
        OUTPUT
            INSERTED.SystemId,
            INSERTED.Identifier,
            INSERTED.Description,
            INSERTED.SystemPath,
            INSERTED.SystemType,
            INSERTED.ParentId,
            INSERTED.Url,
            INSERTED.EntityId,
            INSERTED.ConcurrencyId,
            @StampActionCreate,
            @StampDateTime,
            @StampUser
        INTO TSystemAudit (
            SystemId, Identifier, Description, SystemPath, SystemType, ParentId, Url, EntityId, ConcurrencyId,
            StampAction, StampDateTime, StampUser
        )
        VALUES (
            'clientresponsetemplates',
            'Client Response Templates',
            @NewSystemPath,
            '-function',
            @ParentSystemId,
            NULL,
            NULL,
            1,
            0
        );
    END

    -- Get the newly inserted or existing SystemId
    SELECT @NewSystemId = SystemId FROM TSystem WHERE SystemPath = @NewSystemPath;

    -- Insert license type mappings only if not already present
    IF NOT EXISTS (
        SELECT 1 FROM TRefLicenseTypeToSystem WHERE SystemId = @NewSystemId
    )
    BEGIN
        INSERT INTO TRefLicenseTypeToSystem (
            RefLicenseTypeId, SystemId, ConcurrencyId
        )
        OUTPUT
            INSERTED.RefLicenseTypeId,
            INSERTED.SystemId,
            INSERTED.ConcurrencyId,
            INSERTED.RefLicenseTypeToSystemId,
            @StampActionCreate,
            @StampDateTime,
            @StampUser
        INTO TRefLicenseTypeToSystemAudit (
            RefLicenseTypeId, SystemId, ConcurrencyId, RefLicenseTypeToSystemId,
            StampAction, StampDateTime, StampUser
        )
        SELECT RefLicenseTypeId, @NewSystemId, 1
        FROM TRefLicenseType
        WHERE LicenseTypeName IN ('full', 'mortgageadmin');
    END

    INSERT INTO TExecutedDataScript (ScriptGUID, Comments)
    VALUES (@ScriptGUID, @Comments);

    IF @starttrancount = 0
        COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    DECLARE @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT;

    SELECT
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE(),
        @ErrorNumber = ERROR_NUMBER(),
        @ErrorLine = ERROR_LINE();

    -- Optional: Insert error info into a logging table here

    IF XACT_STATE() <> 0 AND @starttrancount = 0
        ROLLBACK TRANSACTION;

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine);
END CATCH

SET XACT_ABORT OFF;
SET NOCOUNT OFF;

RETURN;
