USE Administration


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
    @TrandingParentSystemId INT,
    @OrderHistorySystemPath VARCHAR(MAX),
    @OrderBookSystemPath VARCHAR(MAX),
    @OrderBookSystemId INT,
    @CurrentOrdersSystemPath VARCHAR(MAX),
    @TradingParentSystemId INT,
    @CashManagementSystemPath VARCHAR(MAX),
    @CashManagementSystemId INT,
    @InvestCashSystemPath VARCHAR(MAX),
    @RaiseCashSystemPath VARCHAR(MAX),
    @OrderBookParentSystemId INT,
    @LockedAccountsSystemPath VARCHAR(MAX),
    @FunctionType VARCHAR(MAX),
    @ViewType VARCHAR(MAX),
    @ApplicationType VARCHAR(MAX),
    @SystemType VARCHAR(MAX),
    @PortfolioApplicationsSystemPath VARCHAR(MAX)

SELECT 
    @ScriptGUID = '08747ADA-B754-4617-8B53-B5CA40236D7B',
    @Comments = 'AIOUI-1297 - Create portfolio permissions tree',
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
--TSystem (1 row(s) affected)
-----------------------------------------------------------------------------------------------


SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount INT

BEGIN TRY
    SELECT
        @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

    DECLARE
        @PortfolioParentSystemId INT,
        @PortfolioReportsSystemId INT

    ------ Add Portfolio permission (portfolioreporting) ------
    IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @PortfolioSystemPath AND SystemType = @ApplicationType)
    BEGIN
        INSERT INTO TSystem (
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
        VALUES (
            @PortfolioSystemPath,
            'Portfolio',
            @PortfolioSystemPath,
            @ApplicationType,
            NULL,
            NULL,
            NULL,
            1
        )
    END

    SELECT @PortfolioParentSystemId = SystemID
    FROM TSystem
    WHERE SystemPath = @PortfolioSystemPath AND SystemType = @ApplicationType

    ------ Add Portfolio Reports (portfolioreporting.reports) ------
    IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @PortfolioReportsSystemPath AND SystemType = @SystemType)
    BEGIN
        INSERT INTO TSystem (
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
        VALUES (
            'reports',
            'Reports',
            @PortfolioReportsSystemPath,
            @SystemType,
            @PortfolioParentSystemId,
            NULL,
            NULL,
            1
        )
    END

    SELECT @PortfolioReportsSystemId = SystemID
    FROM TSystem
    WHERE SystemPath = @PortfolioReportsSystemPath AND SystemType = @SystemType

    ------ Add Accounts Under Management (portfolioreporting.reports.accountsundermanagement) ------
    IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @PortfolioAccountsUnderManagementSystemPath AND SystemType = @FunctionType)
    BEGIN
        INSERT INTO TSystem (
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
        VALUES (
            'accountsundermanagement',
            'Accounts Under Management',
            @PortfolioAccountsUnderManagementSystemPath,
            @FunctionType,
            @PortfolioReportsSystemId,
            NULL,
            NULL,
            1
        )
    END

    ------ Unmatched Accounts (portfolioreporting.reports.unmatchedaccounts) ------
    IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @PortfolioUnmatchedAccountsSystemPath AND SystemType = @FunctionType)
    BEGIN
        INSERT INTO TSystem (
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
        VALUES (
            'unmatchedaccounts',
            'Unmatched Accounts',
            @PortfolioUnmatchedAccountsSystemPath,
            @FunctionType,
            @PortfolioReportsSystemId,
            NULL,
            NULL,
            1
        )
    END

    ------ Add Portfolio Trading (portfolioreporting.trading) ------
    IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @PortfolioTradingSystemPath AND SystemType = @SystemType)
    BEGIN
        INSERT INTO TSystem (
            [Identifier],
            [Description],
            [SystemPath],
            [SystemType],
            [ParentId], [Url],
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
        VALUES (
            'trading',
            'Trading',
            @PortfolioTradingSystemPath,
            @SystemType,
            @PortfolioParentSystemId,
            NULL,
            NULL,
            1
        )
    END

    ------ Add Order Book permission (portfolioreporting.trading.orderbook)------
    SELECT @TrandingParentSystemId = SystemID
    FROM TSystem
    WHERE SystemPath = @PortfolioTradingSystemPath AND SystemType = @SystemType

    IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @OrderBookSystemPath AND SystemType = @FunctionType)
    BEGIN

        INSERT INTO TSystem (
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
        VALUES (
            'orderbook',
            'Order Book',
            @OrderBookSystemPath,
            @FunctionType,
            @TrandingParentSystemId,
            NULL,
            NULL,
            1
        )
    END

    ------ Add Current Orders (portfolioreporting.trading.orderbook.currentorders) ------
    SELECT @OrderBookSystemId = SystemID
    FROM TSystem
    WHERE SystemPath = @OrderBookSystemPath AND SystemType = @FunctionType

    IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @CurrentOrdersSystemPath AND SystemType = @ViewType)
    BEGIN
        INSERT INTO TSystem (
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
        VALUES (
            'currentorders',
            'Current Orders',
            @CurrentOrdersSystemPath,
            @ViewType,
            @OrderBookSystemId,
            NULL,
            NULL,
            1
        )
    END

    ------ Add History Orders (portfolioreporting.trading.orderbook.orderhistory) ------
    IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @OrderHistorySystemPath AND SystemType = @ViewType)
    BEGIN

        INSERT INTO TSystem (
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
        VALUES (
            'orderhistory',
            'Order History',
            @OrderHistorySystemPath,
            @ViewType,
            @OrderBookSystemId,
            NULL,
            NULL,
            1
        )
    END

    ------ Add Locked Accounts permission (portfolioreporting.trading.orderbook.lockedaccounts) ------
    SELECT @OrderBookParentSystemId = SystemID
    FROM TSystem
    WHERE SystemPath = @OrderBookSystemPath AND SystemType = '-function'

    IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @LockedAccountsSystemPath AND SystemType = @ViewType)
    BEGIN

        INSERT INTO TSystem (
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
        VALUES (
            'lockedaccounts',
            'Locked Accounts',
            @LockedAccountsSystemPath,
            @ViewType,
            @OrderBookParentSystemId,
            NULL,
            NULL,
            1
        )
    END

    ------ Add Cash Management permission (portfolioreporting.trading.cashmanagement) ------
    SELECT @TradingParentSystemId = SystemID
    FROM TSystem
    WHERE SystemPath = @PortfolioTradingSystemPath AND SystemType = @SystemType

    IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @CashManagementSystemPath AND SystemType = @FunctionType)
    BEGIN

        INSERT INTO TSystem (
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
        VALUES (
            'cashmanagement',
            'Cash Management',
            @CashManagementSystemPath,
            @FunctionType,
            @TradingParentSystemId,
            NULL,
            NULL,
            1
        )
    END

    ------ Add Invest Cash (portfolioreporting.trading.cashmanagement.investcash) ------
    SELECT @CashManagementSystemId = SystemID
    FROM TSystem
    WHERE SystemPath = @CashManagementSystemPath AND SystemType = @FunctionType

    IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @InvestCashSystemPath AND SystemType = @ViewType)
    BEGIN
        INSERT INTO TSystem (
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
        VALUES (
            'investcash',
            'Invest Cash',
            @InvestCashSystemPath,
            @ViewType,
            @CashManagementSystemId,
            NULL,
            NULL,
            1
        )
    END

    ------ Add Raise Cash (portfolioreporting.trading.cashmanagement.raisecash) ------
    IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @RaiseCashSystemPath AND SystemType = @ViewType)
    BEGIN
        INSERT INTO TSystem (
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
        VALUES (
            'raisecash',
            'Raise Cash',
            @RaiseCashSystemPath,
            @ViewType,
            @CashManagementSystemId,
            NULL,
            NULL,
            1
        )
    END

    ------ Add Applications (portfolioreporting.applications) ------
    IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @PortfolioApplicationsSystemPath AND SystemType = @SystemType)
    BEGIN

        INSERT INTO TSystem (
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
        VALUES (
            'applications',
            'Applications',
            @PortfolioApplicationsSystemPath,
            @SystemType,
            @PortfolioParentSystemId,
            NULL,
            NULL,
            1
        )
    END

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

IF @starttrancount = 0
    COMMIT TRANSACTION
END TRY
BEGIN CATCH

    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT
    DECLARE @ErrorLine INT
    DECLARE @ErrorNumber INT

    SELECT
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE(),
        @ErrorNumber = ERROR_NUMBER(),
        @ErrorLine = ERROR_LINE()

    /* Insert into logging table - IF ANY */

    IF XACT_STATE() <> 0
        AND @starttrancount = 0
        ROLLBACK TRANSACTION

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN; 