USE Administration


DECLARE @ScriptGUID uniqueidentifier,
        @Comments varchar(255),
        @ErrorMessage varchar(max), 
        @StampDateTime DATETIME,
        @StampActionCreate CHAR(1),
        @StampUser INT,
        @PortfolioReportsSystemPath varchar(max),
        @PortfolioAdviserCodesSystemPath varchar(max),
        @PortfolioAdviserCodesType varchar(max),
        @SystemType VARCHAR(MAX)

--Use the line below to generate a GUID.
--Please DO NOT make it part of the script. You should only generate the GUID once.
--SELECT NEWID()

SELECT
    @ScriptGUID = '598BBCF5-BB5C-42CC-812B-F0AF3FF36B4E',
    @Comments = 'AIOUI-1794 - Create Adviser Codes',
    @StampDateTime = GETUTCDATE(),
    @StampActionCreate = 'C',
    @StampUser = 0,
    @PortfolioReportsSystemPath = 'portfolioreporting.reports',
    @PortfolioAdviserCodesSystemPath = 'portfolioreporting.reports.advisercodes',
    @PortfolioAdviserCodesType = '-function',
    @SystemType = '-system'


/*
    NOTE: By default the scripts will run on ALL environments as part of a data refresh
    If this script needs to be run on a specific environment, change and enable this. 
*/

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Add security key to manage access to Portfolio

-- Expected row counts:
--TSystem (1 row(s) affected)
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
            @PortfolioReportsSystemId int


        SELECT @PortfolioReportsSystemId = SystemID
		FROM TSystem
		WHERE SystemPath = @PortfolioReportsSystemPath AND SystemType = @SystemType

        ------ Adviser Codes ------

        IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @PortfolioAdviserCodesSystemPath)
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
                    VALUES ('advisercodes', 'Adviser Codes', @PortfolioAdviserCodesSystemPath, @PortfolioAdviserCodesType, @PortfolioReportsSystemId, NULL, NULL, 1)
            END

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

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