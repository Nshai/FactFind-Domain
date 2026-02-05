USE Administration


DECLARE @ScriptGUID uniqueidentifier,
        @Comments varchar(255),
        @ErrorMessage varchar(max), 
        @StampDateTime DATETIME,
        @StampActionCreate CHAR(1),
        @StampUser INT,
        @AccountPerformanceSystemPath varchar(max),
        @AccountPerformanceFullListSystemPath varchar(max),
        @TenantId INT

--Use the line below to generate a GUID.
--Please DO NOT make it part of the script. You should only generate the GUID once.
--SELECT NEWID()

SELECT
    @ScriptGUID = 'DB1682AD-9D00-4947-8E91-ACE38CAA5576',
    @Comments = 'PA-5988 - Create Account Performance Entitlements',
    @StampDateTime = GETUTCDATE(),
    @StampActionCreate = 'C',
    @StampUser = 0,
    @AccountPerformanceSystemPath = 'adviserworkplace.clients.plans.accountperformance',
    @AccountPerformanceFullListSystemPath = 'adviserworkplace.clients.plans.accountperformancefulllist'

/*
    NOTE: By default the scripts will run on ALL environments as part of a data refresh
    If this script needs to be run on a specific environment, change and enable this. 
*/

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Add security key to manage access to Householding

-- Expected row counts:
--TSystem (2 row(s) affected)
-----------------------------------------------------------------------------------------------


SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    SELECT
        @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

        DECLARE 
            @ClientActionSystemId int,
            @AccountPerformanceSystemId int,
            @RefLicenseTypeIdFull int

        SET @ClientActionSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = 'adviserworkplace.clients.plans')

        IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @AccountPerformanceSystemPath)
            BEGIN
                INSERT INTO TSystem ([Identifier], [Description], [SystemPath], [SystemType], [ParentId], [Url], [EntityId], [ConcurrencyId])
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
                    @StampActionCreate,
                    @StampDateTime,
                    @StampUser
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
                    VALUES ('accountperformance', 'Account Performance', @AccountPerformanceSystemPath, '-view', @ClientActionSystemId, NULL, NULL, 1)
            END

        IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @AccountPerformanceFullListSystemPath)
            BEGIN
                INSERT INTO TSystem ([Identifier], [Description], [SystemPath], [SystemType], [ParentId], [Url], [EntityId], [ConcurrencyId])
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
                    @StampActionCreate,
                    @StampDateTime,
                    @StampUser
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
                    VALUES ('accountperformancefulllist', 'Account Performance Full List', @AccountPerformanceFullListSystemPath, '-view', @ClientActionSystemId, NULL, NULL, 1)
            END
        
IF @starttrancount = 0
	COMMIT TRANSACTION
END TRY
BEGIN CATCH

    DECLARE @ErrorSeverity int
    DECLARE @ErrorState int
    DECLARE @ErrorLine int
    DECLARE @ErrorNumber int

    SELECT
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE(),
        @ErrorNumber = ERROR_NUMBER(),
        @ErrorLine = ERROR_LINE()

    /*Insert into logging table - IF ANY    */

    IF XACT_STATE() <> 0
        AND @starttrancount = 0
        ROLLBACK TRANSACTION

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;