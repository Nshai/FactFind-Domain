USE policymanagement;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
      , @StampDateTime DATETIME = GETUTCDATE()
      , @StampAction CHAR(1) = 'U'
      , @StampUser INT = 0

/*
Summary
Set isiMPS, isExternallyManaged and isDFM for Portfolio models
DatabaseName        TableName      Expected Rows
PolicyManagement    TPortfolio     ~23350
*/

SELECT @ScriptGUID = 'C44E8B52-144A-4016-8D35-D84864E05960'
      , @Comments = 'PA-14568 Update isiMPS, isExternally Managed and DFM for Models'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

BEGIN TRANSACTION

    BEGIN TRY

-- Set IsIMPS
        UPDATE TPortfolio
        SET IsIMPS =
		(CASE WHEN AppId IS NOT NULL
		THEN 1
		ELSE 0 END)
        OUTPUT
			 DELETED.[Title]
			,DELETED.[Description]
			,DELETED.[IsPublic]
			,DELETED.[IsGroupRestricted]
			,DELETED.[GroupId]
			,DELETED.[IsIncludeSubGroups]
			,DELETED.[IsReadOnly]
			,DELETED.[IsActive]
			,DELETED.[IsLocked]
			,DELETED.[BenchmarkId]
			,DELETED.[IsClientPortal]
			,DELETED.[ATRPortfolioGuid]
			,DELETED.[CreatedBy]
			,DELETED.[CreatedDate]
			,DELETED.[Client]
			,DELETED.[ConcurrencyId]
			,DELETED.[Code]
			,DELETED.[Provider]
			,DELETED.[ChangeDescription]
			,DELETED.[MarketCommentaryHref]
			,DELETED.[IsPrivate]
			,DELETED.[TenantId]
			,DELETED.[AppId]
			,DELETED.[AllowRebalance]
			,DELETED.[PortfolioId]
			,DELETED.[FactSheetLink]
			,DELETED.[TaxQualified]
			,DELETED.[InvestmentManagementStyle]
			,DELETED.[PlatformProvider]
			,DELETED.[IsDiscretionaryFundManaged]
			,DELETED.[ChargeRate]
			,DELETED.[ChargeCurrencyCode]
			,DELETED.[ChargeVATRule]
			,DELETED.[IsExternallyManaged]
			,DELETED.[IsIMPS]
			,@StampAction
			,@StampDateTime
			,@StampUser
			,DELETED.[RiskReference]
        INTO TPortfolioAudit
			([Title]
			,[Description]
			,[IsPublic]
			,[IsGroupRestricted]
			,[GroupId]
			,[IsIncludeSubGroups]
			,[IsReadOnly]
			,[IsActive]
			,[IsLocked]
			,[BenchmarkId]
			,[IsClientPortal]
			,[ATRPortfolioGuid]
			,[CreatedBy]
			,[CreatedDate]
			,[Client]
			,[ConcurrencyId]
			,[Code]
			,[Provider]
			,[ChangeDescription]
			,[MarketCommentaryHref]
			,[IsPrivate]
			,[TenantId]
			,[AppId]
			,[AllowRebalance]
			,[PortfolioId]
			,[FactSheetLink]
			,[TaxQualified]
			,[InvestmentManagementStyle]
			,[PlatformProvider]
			,[IsDiscretionaryFundManaged]
			,[ChargeRate]
			,[ChargeCurrencyCode]
			,[ChargeVATRule]
			,[IsExternallyManaged]
			,[IsIMPS]
			,[StampAction]
			,[StampDateTime]
			,[StampUser]
			,[RiskReference])
        WHERE IsIMPS IS NULL

-- Set IsExternallyManaged
        UPDATE TPortfolio
        SET IsExternallyManaged = IsIMPS
        OUTPUT
			DELETED.[Title]
			,DELETED.[Description]
			,DELETED.[IsPublic]
			,DELETED.[IsGroupRestricted]
			,DELETED.[GroupId]
			,DELETED.[IsIncludeSubGroups]
			,DELETED.[IsReadOnly]
			,DELETED.[IsActive]
			,DELETED.[IsLocked]
			,DELETED.[BenchmarkId]
			,DELETED.[IsClientPortal]
			,DELETED.[ATRPortfolioGuid]
			,DELETED.[CreatedBy]
			,DELETED.[CreatedDate]
			,DELETED.[Client]
			,DELETED.[ConcurrencyId]
			,DELETED.[Code]
			,DELETED.[Provider]
			,DELETED.[ChangeDescription]
			,DELETED.[MarketCommentaryHref]
			,DELETED.[IsPrivate]
			,DELETED.[TenantId]
			,DELETED.[AppId]
			,DELETED.[AllowRebalance]
			,DELETED.[PortfolioId]
			,DELETED.[FactSheetLink]
			,DELETED.[TaxQualified]
			,DELETED.[InvestmentManagementStyle]
			,DELETED.[PlatformProvider]
			,DELETED.[IsDiscretionaryFundManaged]
			,DELETED.[ChargeRate]
			,DELETED.[ChargeCurrencyCode]
			,DELETED.[ChargeVATRule]
			,DELETED.[IsExternallyManaged]
			,DELETED.[IsIMPS]
			,@StampAction
			,@StampDateTime
			,@StampUser
			,DELETED.[RiskReference]
        INTO TPortfolioAudit
			([Title]
			,[Description]
			,[IsPublic]
			,[IsGroupRestricted]
			,[GroupId]
			,[IsIncludeSubGroups]
			,[IsReadOnly]
			,[IsActive]
			,[IsLocked]
			,[BenchmarkId]
			,[IsClientPortal]
			,[ATRPortfolioGuid]
			,[CreatedBy]
			,[CreatedDate]
			,[Client]
			,[ConcurrencyId]
			,[Code]
			,[Provider]
			,[ChangeDescription]
			,[MarketCommentaryHref]
			,[IsPrivate]
			,[TenantId]
			,[AppId]
			,[AllowRebalance]
			,[PortfolioId]
			,[FactSheetLink]
			,[TaxQualified]
			,[InvestmentManagementStyle]
			,[PlatformProvider]
			,[IsDiscretionaryFundManaged]
			,[ChargeRate]
			,[ChargeCurrencyCode]
			,[ChargeVATRule]
			,[IsExternallyManaged]
			,[IsIMPS]
			,[StampAction]
			,[StampDateTime]
			,[StampUser]
			,[RiskReference])
        WHERE IsExternallyManaged IS NULL

-- Set IsDiscretionaryFundManaged
        UPDATE TPortfolio
        SET IsDiscretionaryFundManaged = 0
        OUTPUT
			DELETED.[Title]
			,DELETED.[Description]
			,DELETED.[IsPublic]
			,DELETED.[IsGroupRestricted]
			,DELETED.[GroupId]
			,DELETED.[IsIncludeSubGroups]
			,DELETED.[IsReadOnly]
			,DELETED.[IsActive]
			,DELETED.[IsLocked]
			,DELETED.[BenchmarkId]
			,DELETED.[IsClientPortal]
			,DELETED.[ATRPortfolioGuid]
			,DELETED.[CreatedBy]
			,DELETED.[CreatedDate]
			,DELETED.[Client]
			,DELETED.[ConcurrencyId]
			,DELETED.[Code]
			,DELETED.[Provider]
			,DELETED.[ChangeDescription]
			,DELETED.[MarketCommentaryHref]
			,DELETED.[IsPrivate]
			,DELETED.[TenantId]
			,DELETED.[AppId]
			,DELETED.[AllowRebalance]
			,DELETED.[PortfolioId]
			,DELETED.[FactSheetLink]
			,DELETED.[TaxQualified]
			,DELETED.[InvestmentManagementStyle]
			,DELETED.[PlatformProvider]
			,DELETED.[IsDiscretionaryFundManaged]
			,DELETED.[ChargeRate]
			,DELETED.[ChargeCurrencyCode]
			,DELETED.[ChargeVATRule]
			,DELETED.[IsExternallyManaged]
			,DELETED.[IsIMPS]
			,@StampAction
			,@StampDateTime
			,@StampUser
			,DELETED.[RiskReference]
        INTO TPortfolioAudit
			([Title]
			,[Description]
			,[IsPublic]
			,[IsGroupRestricted]
			,[GroupId]
			,[IsIncludeSubGroups]
			,[IsReadOnly]
			,[IsActive]
			,[IsLocked]
			,[BenchmarkId]
			,[IsClientPortal]
			,[ATRPortfolioGuid]
			,[CreatedBy]
			,[CreatedDate]
			,[Client]
			,[ConcurrencyId]
			,[Code]
			,[Provider]
			,[ChangeDescription]
			,[MarketCommentaryHref]
			,[IsPrivate]
			,[TenantId]
			,[AppId]
			,[AllowRebalance]
			,[PortfolioId]
			,[FactSheetLink]
			,[TaxQualified]
			,[InvestmentManagementStyle]
			,[PlatformProvider]
			,[IsDiscretionaryFundManaged]
			,[ChargeRate]
			,[ChargeCurrencyCode]
			,[ChargeVATRule]
			,[IsExternallyManaged]
			,[IsIMPS]
			,[StampAction]
			,[StampDateTime]
			,[StampUser]
			,[RiskReference])
        WHERE IsDiscretionaryFundManaged IS NULL

    END TRY
    BEGIN CATCH

        SET @ErrorMessage = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
        WHILE(@@TRANCOUNT > 0)ROLLBACK
        RETURN

    END CATCH

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

COMMIT TRANSACTION

-- Check for ANY open transactions
-- This applies not only to THIS script but will rollback any open transactions in any scripts that have been run before this one.
IF @@TRANCOUNT > 0
BEGIN
       ROLLBACK
       RETURN
       PRINT 'Open transaction found, aborting'
END

RETURN;