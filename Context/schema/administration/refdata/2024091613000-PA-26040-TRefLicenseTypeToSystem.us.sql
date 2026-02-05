USE Administration;


DECLARE @ScriptGUID UNIQUEIDENTIFIER,
    @Comments VARCHAR(255),
    @ErrorMessage VARCHAR(MAX),
    @StampDateTime DATETIME,
    @StampActionCreate CHAR(1),
    @StampUser INT,
    @PortfolioSystemPath VARCHAR(MAX),
    @PortfolioTradingSystemPath VARCHAR(MAX),
    @PortfolioReportsSystemPath VARCHAR(MAX),
    @PortfolioAccountsUnderManagementSystemPath VARCHAR(MAX),
    @PortfolioUnmatchedAccountsSystemPath VARCHAR(MAX),
    @OrderHistorySystemPath VARCHAR(MAX),
    @OrderBookSystemPath VARCHAR(MAX),
    @CurrentOrdersSystemPath VARCHAR(MAX),
    @CashManagementSystemPath VARCHAR(MAX),
    @InvestCashSystemPath VARCHAR(MAX),
    @RaiseCashSystemPath VARCHAR(MAX),
    @LockedAccountsSystemPath VARCHAR(MAX),
    @FunctionType VARCHAR(MAX),
    @ViewType VARCHAR(MAX),
    @ApplicationType VARCHAR(MAX),
    @SystemType VARCHAR(MAX),
    @PortfolioApplicationsSystemPath VARCHAR(MAX)

SELECT 
    @ScriptGUID = 'F8DC229A-E472-4C4D-8882-40309B54DD77',
    @Comments = 'PA-26040 Add full license type for portfolioreporting nodes',
    @StampDateTime = GETUTCDATE(),
    @StampActionCreate = 'C',
    @StampUser = 0

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID AND Comments = @Comments)
    RETURN;

SELECT
    -- Portfolio
    @PortfolioSystemPath = 'portfolioreporting',

    -- Reports
    @PortfolioReportsSystemPath = 'portfolioreporting.reports',
    @PortfolioAccountsUnderManagementSystemPath = 'portfolioreporting.reports.accountsundermanagement',
    @PortfolioUnmatchedAccountsSystemPath = 'portfolioreporting.reports.unmatchedaccounts',

    -- Trading
    @PortfolioTradingSystemPath = 'portfolioreporting.trading',
    @OrderBookSystemPath = 'portfolioreporting.trading.orderbook',
    @CurrentOrdersSystemPath = 'portfolioreporting.trading.orderbook.currentorders',
    @OrderHistorySystemPath = 'portfolioreporting.trading.orderbook.orderhistory',
    @LockedAccountsSystemPath = 'portfolioreporting.trading.orderbook.lockedaccounts',

    -- Cash Management
    @CashManagementSystemPath = 'portfolioreporting.trading.cashmanagement',
    @InvestCashSystemPath = 'portfolioreporting.trading.cashmanagement.investcash',
    @RaiseCashSystemPath = 'portfolioreporting.trading.cashmanagement.raisecash',

    -- Applications
    @PortfolioApplicationsSystemPath = 'portfolioreporting.applications',

    @ApplicationType = '-application',
    @ViewType = '-view',
    @SystemType = '-system',
    @FunctionType = '-function'

-----------------------------------------------------------------------------------------------
-- Summary: Add security key to manage access to Portfolio

-- Expected row counts:
--TRefLicenseTypeToSystem (13 row(s) affected)
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
            @PortfolioSystemId int,
            @PortfolioTradingSystemId int,
            @PortfolioReportsSystemId int,
            @PortfolioAccountsUnderManagementSystemId int,
            @PortfolioUnmatchedAccountsSystemId int,
            @OrderBookSystemId INT,
            @CurrentOrdersSystemId INT,
            @OrderHistorySystemId INT,
            @CashManagementSystemId INT,
            @InvestCashSystemId INT,
            @RaiseCashSystemId INT,
            @LockedAccountsSystemId INT,
            @PortfolioApplicationsSystemId INT

        ------ Add TRefLicenseTypeToSystem------

        Set @PortfolioSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @PortfolioSystemPath and SystemType = @ApplicationType)
        Set @PortfolioTradingSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @PortfolioTradingSystemPath and SystemType = @SystemType)
        Set @PortfolioReportsSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @PortfolioReportsSystemPath and SystemType = @SystemType)
        Set @PortfolioAccountsUnderManagementSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @PortfolioAccountsUnderManagementSystemPath and SystemType = @FunctionType)
        Set @PortfolioUnmatchedAccountsSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @PortfolioUnmatchedAccountsSystemPath and SystemType = @FunctionType)
        SET @OrderBookSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @OrderBookSystemPath AND SystemType = @FunctionType)
        SET @CurrentOrdersSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @CurrentOrdersSystemPath AND SystemType = @ViewType)
        SET @OrderHistorySystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @OrderHistorySystemPath AND SystemType = @ViewType)
        SET @CashManagementSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @CashManagementSystemPath AND SystemType = @FunctionType)
        SET @InvestCashSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @InvestCashSystemPath AND SystemType = @ViewType)
        SET @RaiseCashSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @RaiseCashSystemPath AND SystemType = @ViewType)
        SET @LockedAccountsSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @LockedAccountsSystemPath AND SystemType = @ViewType)
        SET @PortfolioApplicationsSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = @PortfolioApplicationsSystemPath AND SystemType = @SystemType)

        -- Portfolio
        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @PortfolioSystemId)
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
                    @PortfolioSystemId,
                    1
                FROM TRefLicenseType WHERE LicenseTypeName IN ('full')
            END

        -- Trading
        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @PortfolioTradingSystemId)
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
                    @PortfolioTradingSystemId,
                    1
                FROM TRefLicenseType WHERE LicenseTypeName IN ('full')
            END

        -- Reports
        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @PortfolioReportsSystemId)
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
                    @PortfolioReportsSystemId,
                    1
                FROM TRefLicenseType WHERE LicenseTypeName IN ('full')
            END

        -- Accounts Under Management
        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @PortfolioAccountsUnderManagementSystemId)
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
                    @PortfolioAccountsUnderManagementSystemId,
                    1
                FROM TRefLicenseType WHERE LicenseTypeName IN ('full')
            END

        -- Unmatched Accounts
        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @PortfolioUnmatchedAccountsSystemId)
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
                    @PortfolioUnmatchedAccountsSystemId,
                    1
                FROM TRefLicenseType WHERE LicenseTypeName IN ('full')
            END

        -- Order Book
        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @OrderBookSystemId)
            BEGIN
                INSERT INTO [dbo].[TRefLicenseTypeToSystem] (
                    [RefLicenseTypeId]
                    ,[SystemId]
                    ,[ConcurrencyId]
                )
                OUTPUT inserted.[RefLicenseTypeId]
                    ,inserted.[SystemId]
                    ,inserted.[ConcurrencyId]
                    ,inserted.[RefLicenseTypeToSystemId]
                    ,@StampActionCreate
                    ,@StampDateTime
                    ,@StampUser
                INTO [dbo].[TRefLicenseTypeToSystemAudit] (
                    [RefLicenseTypeId]
                    ,[SystemId]
                    ,[ConcurrencyId]
                    ,[RefLicenseTypeToSystemId]
                    ,[StampAction]
                    ,[StampDateTime]
                    ,[StampUser])
                SELECT RefLicenseTypeId,
                    @OrderBookSystemId,
                    1
                FROM TRefLicenseType WHERE LicenseTypeName IN ('full')
            END

        -- Current Orders
        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @CurrentOrdersSystemId)
            BEGIN
                INSERT INTO [dbo].[TRefLicenseTypeToSystem] (
                    [RefLicenseTypeId]
                    ,[SystemId]
                    ,[ConcurrencyId]
                )
                OUTPUT inserted.[RefLicenseTypeId]
                    ,inserted.[SystemId]
                    ,inserted.[ConcurrencyId]
                    ,inserted.[RefLicenseTypeToSystemId]
                    ,@StampActionCreate
                    ,@StampDateTime
                    ,@StampUser
                INTO [dbo].[TRefLicenseTypeToSystemAudit] (
                    [RefLicenseTypeId]
                    ,[SystemId]
                    ,[ConcurrencyId]
                    ,[RefLicenseTypeToSystemId]
                    ,[StampAction]
                    ,[StampDateTime]
                    ,[StampUser])
                SELECT RefLicenseTypeId,
                    @CurrentOrdersSystemId,
                    1
                FROM TRefLicenseType WHERE LicenseTypeName IN ('full')
            END

        -- Order History
        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @OrderHistorySystemId)
            BEGIN
                INSERT INTO [dbo].[TRefLicenseTypeToSystem] (
                    [RefLicenseTypeId]
                    ,[SystemId]
                    ,[ConcurrencyId]
                )
                OUTPUT inserted.[RefLicenseTypeId]
                    ,inserted.[SystemId]
                    ,inserted.[ConcurrencyId]
                    ,inserted.[RefLicenseTypeToSystemId]
                    ,@StampActionCreate
                    ,@StampDateTime
                    ,@StampUser
                INTO [dbo].[TRefLicenseTypeToSystemAudit] (
                    [RefLicenseTypeId]
                    ,[SystemId]
                    ,[ConcurrencyId]
                    ,[RefLicenseTypeToSystemId]
                    ,[StampAction]
                    ,[StampDateTime]
                    ,[StampUser]
                )
                SELECT RefLicenseTypeId,
                    @OrderHistorySystemId,
                    1
                FROM TRefLicenseType WHERE LicenseTypeName IN ('full')
            END

        -- Cash Management
        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @CashManagementSystemId)
            BEGIN
                INSERT INTO [dbo].[TRefLicenseTypeToSystem] (
                    [RefLicenseTypeId]
                    ,[SystemId]
                    ,[ConcurrencyId]
                )
                OUTPUT inserted.[RefLicenseTypeId]
                    ,inserted.[SystemId]
                    ,inserted.[ConcurrencyId]
                    ,inserted.[RefLicenseTypeToSystemId]
                    ,@StampActionCreate
                    ,@StampDateTime
                    ,@StampUser
                INTO [dbo].[TRefLicenseTypeToSystemAudit] (
                    [RefLicenseTypeId]
                    ,[SystemId]
                    ,[ConcurrencyId]
                    ,[RefLicenseTypeToSystemId]
                    ,[StampAction]
                    ,[StampDateTime]
                    ,[StampUser])
                SELECT RefLicenseTypeId,
                    @CashManagementSystemId,
                    1
                FROM TRefLicenseType WHERE LicenseTypeName IN ('full')
            END

        -- Invest Cash
        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @InvestCashSystemId)
            BEGIN
                INSERT INTO [dbo].[TRefLicenseTypeToSystem] (
                    [RefLicenseTypeId]
                    ,[SystemId]
                    ,[ConcurrencyId]
                )
                OUTPUT inserted.[RefLicenseTypeId]
                    ,inserted.[SystemId]
                    ,inserted.[ConcurrencyId]
                    ,inserted.[RefLicenseTypeToSystemId]
                    ,@StampActionCreate
                    ,@StampDateTime
                    ,@StampUser
                INTO [dbo].[TRefLicenseTypeToSystemAudit] (
                    [RefLicenseTypeId]
                    ,[SystemId]
                    ,[ConcurrencyId]
                    ,[RefLicenseTypeToSystemId]
                    ,[StampAction]
                    ,[StampDateTime]
                    ,[StampUser])
                SELECT RefLicenseTypeId,
                    @InvestCashSystemId,
                    1
                FROM TRefLicenseType WHERE LicenseTypeName IN ('full')
            END

        -- Raise Cash
        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @RaiseCashSystemId)
            BEGIN
                INSERT INTO [dbo].[TRefLicenseTypeToSystem] (
                    [RefLicenseTypeId]
                    ,[SystemId]
                    ,[ConcurrencyId]
                )
                OUTPUT inserted.[RefLicenseTypeId]
                    ,inserted.[SystemId]
                    ,inserted.[ConcurrencyId]
                    ,inserted.[RefLicenseTypeToSystemId]
                    ,@StampActionCreate
                    ,@StampDateTime
                    ,@StampUser
                INTO [dbo].[TRefLicenseTypeToSystemAudit] (
                    [RefLicenseTypeId]
                    ,[SystemId]
                    ,[ConcurrencyId]
                    ,[RefLicenseTypeToSystemId]
                    ,[StampAction]
                    ,[StampDateTime]
                    ,[StampUser]
                )
                SELECT RefLicenseTypeId,
                    @RaiseCashSystemId,
                    1
                FROM TRefLicenseType WHERE LicenseTypeName IN ('full')
            END

        -- Locked Accounts
        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @LockedAccountsSystemId)
            BEGIN
                INSERT INTO [dbo].[TRefLicenseTypeToSystem] (
                    [RefLicenseTypeId]
                    ,[SystemId]
                    ,[ConcurrencyId]
                )
                OUTPUT inserted.[RefLicenseTypeId]
                    ,inserted.[SystemId]
                    ,inserted.[ConcurrencyId]
                    ,inserted.[RefLicenseTypeToSystemId]
                    ,@StampActionCreate
                    ,@StampDateTime
                    ,@StampUser
                INTO [dbo].[TRefLicenseTypeToSystemAudit] (
                    [RefLicenseTypeId]
                    ,[SystemId]
                    ,[ConcurrencyId]
                    ,[RefLicenseTypeToSystemId]
                    ,[StampAction]
                    ,[StampDateTime]
                    ,[StampUser])
                SELECT RefLicenseTypeId,
                    @LockedAccountsSystemId,
                    1
                FROM TRefLicenseType WHERE LicenseTypeName IN ('full')
            END

        -- Portfolio Applications
        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @PortfolioApplicationsSystemId)
            BEGIN
                INSERT INTO [dbo].[TRefLicenseTypeToSystem] (
                    [RefLicenseTypeId]
                    ,[SystemId]
                    ,[ConcurrencyId]
                )
                OUTPUT inserted.[RefLicenseTypeId]
                    ,inserted.[SystemId]
                    ,inserted.[ConcurrencyId]
                    ,inserted.[RefLicenseTypeToSystemId]
                    ,@StampActionCreate
                    ,@StampDateTime
                    ,@StampUser
                INTO [dbo].[TRefLicenseTypeToSystemAudit] (
                    [RefLicenseTypeId]
                    ,[SystemId]
                    ,[ConcurrencyId]
                    ,[RefLicenseTypeToSystemId]
                    ,[StampAction]
                    ,[StampDateTime]
                    ,[StampUser])
                SELECT RefLicenseTypeId,
                    @PortfolioApplicationsSystemId,
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