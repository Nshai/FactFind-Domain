USE [administration];

DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @ErrorMessage VARCHAR(MAX)
        , @StampActionDelete CHAR(1) = 'D'
        , @StampDateTime DATETIME = GETUTCDATE()
        , @StampUser VARCHAR(255) = '0'
        , @HoldingsUSSystemId INT
        , @HoldingsFullListUSSystemId INT
        , @CurrentOrdersSystemId INT
        , @OrderHistorySystemId INT
        , @InvestCashSystemId INT
        , @RaiseCashSystemId INT
        , @LockedAccountsSystemId INT

SELECT 
    @ScriptGUID = '1840A886-5EC6-47A6-8305-A03FEFC44E84', 
    @Comments = 'IOTD-160 - Remove Holdings, Invest Cash/Raise Cash, Current Orders/Order History/Locked Accounts (US) permissions'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;
/*
Summary
IOTD-160 - Remove Holdings (US) permissions
DatabaseName        TableName      Expected Rows
administration    [TRefLicenseTypeToSystem]     7
administration    [TSystem]                     7
administration	  [TKey]						depends on env
*/

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY

    BEGIN TRANSACTION

    SELECT @HoldingsUSSystemId = [SystemId]
    FROM [dbo].[TSystem]
    WHERE SystemPath = 'adviserworkplace.clients.plans.holdings'

    SELECT @HoldingsFullListUSSystemId = [SystemId]
    FROM [dbo].[TSystem]
    WHERE SystemPath = 'adviserworkplace.clients.plans.holdingsdfulllist'

    SELECT @CurrentOrdersSystemId = [SystemId]
    FROM [dbo].[TSystem]
    WHERE SystemPath = 'portfolioreporting.trading.orderbook.currentorders'

    SELECT @OrderHistorySystemId = [SystemId]
    FROM [dbo].[TSystem]
    WHERE SystemPath = 'portfolioreporting.trading.orderbook.orderhistory'

    SELECT @InvestCashSystemId = [SystemId]
    FROM [dbo].[TSystem]
    WHERE SystemPath = 'portfolioreporting.trading.cashmanagement.investcash'

    SELECT @RaiseCashSystemId = [SystemId]
    FROM [dbo].[TSystem]
    WHERE SystemPath = 'portfolioreporting.trading.cashmanagement.raisecash'

    SELECT @LockedAccountsSystemId = [SystemId]
    FROM [dbo].[TSystem]
    WHERE SystemPath = 'portfolioreporting.trading.orderbook.lockedaccounts'

    DELETE FROM TKey
    OUTPUT DELETED.[KeyId]
      ,DELETED.[RightMask]
      ,DELETED.[SystemId]
      ,DELETED.[UserId]
      ,DELETED.[RoleId]
      ,DELETED.[ConcurrencyId]
      ,@StampActionDelete
      ,@StampDateTime
      ,@StampUser
    INTO TKeyAudit(KeyId
      ,[RightMask]
      ,[SystemId]
      ,[UserId]
      ,[RoleId]
      ,[ConcurrencyId]
      ,[StampAction]
      ,[StampDateTime]
      ,[StampUser])
    WHERE SystemId in (@HoldingsUSSystemId, @HoldingsFullListUSSystemId, @CurrentOrdersSystemId, @OrderHistorySystemId, @InvestCashSystemId, @RaiseCashSystemId, @LockedAccountsSystemId)

    DELETE FROM TRefLicenseTypeToSystem
        OUTPUT DELETED.[RefLicenseTypeToSystemId],
        DELETED.[RefLicenseTypeId],
        DELETED.[SystemId],
        DELETED.[ConcurrencyId],
        @StampActionDelete,
        @StampDateTime,
        @StampUser
    INTO [dbo].[TRefLicenseTypeToSystemAudit]([RefLicenseTypeToSystemId], [RefLicenseTypeId], [SystemId], [ConcurrencyId], [StampAction], [StampDateTime], [StampUser])
    WHERE SystemId in (@HoldingsUSSystemId, @HoldingsFullListUSSystemId, @CurrentOrdersSystemId, @OrderHistorySystemId, @InvestCashSystemId, @RaiseCashSystemId, @LockedAccountsSystemId)

    DELETE FROM TSystem
        OUTPUT  DELETED.[SystemId],
        DELETED.[Identifier],
        DELETED.[Description],
        DELETED.[SystemPath],
        DELETED.[SystemType],
        DELETED.[ParentId],
        DELETED.[Url],
        DELETED.[EntityId],
        DELETED.[ConcurrencyId],
        @StampActionDelete,
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
    WHERE SystemId in (@HoldingsUSSystemId, @HoldingsFullListUSSystemId, @CurrentOrdersSystemId, @OrderHistorySystemId, @InvestCashSystemId, @RaiseCashSystemId, @LockedAccountsSystemId)

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    COMMIT TRANSACTION


END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;