USE Administration


DECLARE @ScriptGUID uniqueidentifier,
        @Comments varchar(255),
        @ErrorMessage varchar(max), 
        @StampDateTime DATETIME,
        @StampActionCreate CHAR(1),
        @StampUser INT,
        @PortfolioAdviserCodesSystemPath varchar(max),
        @PortfolioAdviserCodesType varchar(max)

--Use the line below to generate a GUID.
--Please DO NOT make it part of the script. You should only generate the GUID once.
--SELECT NEWID()

SELECT
    @ScriptGUID = 'B823D0DE-2F6D-4164-AB67-701D6950CDFD',
    @Comments = 'AIOUI-1794 - Create Ref LicenseType to Adviser codes',
    @StampDateTime = GETUTCDATE(),
    @StampActionCreate = 'C',
    @StampUser = 0,
	@PortfolioAdviserCodesSystemPath = 'portfolioreporting.reports.advisercodes',
	@PortfolioAdviserCodesType = '-function'

/*
    NOTE: By default the scripts will run on ALL environments as part of a data refresh
    If this script needs to be run on a specific environment, change and enable this. 
*/

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Add security key to manage access to Portfolio

-- Expected row counts:
--TRefLicenseTypeToSystem (1 row(s) affected)
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
            @PortfolioAdviserCodesSystemId int
		
		------ Add TRefLicenseTypeToSystem------

        Set @PortfolioAdviserCodesSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @PortfolioAdviserCodesSystemPath and SystemType = @PortfolioAdviserCodesType)

		--for Adviser Codes
        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @PortfolioAdviserCodesSystemId)
		BEGIN
				INSERT INTO [dbo].[TRefLicenseTypeToSystem]
								 ([RefLicenseTypeId]
								 ,[SystemId]
								 ,[ConcurrencyId])
				OUTPUT inserted.[RefLicenseTypeId]
					   ,inserted.[SystemId]
					   ,inserted.[ConcurrencyId]
					   ,inserted.[RefLicenseTypeToSystemId]
					   ,@StampActionCreate
					   ,@StampDateTime
					   ,@StampUser
				INTO [dbo].[TRefLicenseTypeToSystemAudit]
						  ([RefLicenseTypeId]
						   ,[SystemId]
						   ,[ConcurrencyId]
						   ,[RefLicenseTypeToSystemId]
						   ,[StampAction]
						   ,[StampDateTime]
						   ,[StampUser])
                SELECT RefLicenseTypeId,
                       @PortfolioAdviserCodesSystemId,
                       1
				FROM TRefLicenseType WHERE LicenseTypeName IN ('full')
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