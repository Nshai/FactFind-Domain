SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.SpDeletePortfolioWithPortfolioClients
	@PortfolioId bigint,
	@UserId varchar(255)

AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN

BEGIN TRY
    -- Handle TPortfolioAttitudeToRisk 

    INSERT INTO TPortfolioAttitudeToRiskAudit (
		PortfolioAttitudeToRiskId,
		Code,
		PortfolioId,
		Description,
		StampAction,
		StampDateTime,
		StampUser)
    SELECT
        T1.PortfolioAttitudeToRiskId,
        T1.Code,
        T1.PortfolioId,
        T1.Description,
        'D',
        GETDATE(),
        @UserId
    FROM TPortfolioAttitudeToRisk T1 JOIN TPortfolio T2 ON T1.PortfolioId = T2.PortfolioId
	WHERE T1.PortfolioId = @PortfolioId

    DELETE T1 FROM TPortfolioAttitudeToRisk T1 JOIN TPortfolio T2 ON T1.PortfolioId = T2.PortfolioId
	WHERE T1.PortfolioId = @PortfolioId

	 -- Handle TPolicyBusinessExt 

    INSERT INTO TPolicyBusinessExtAudit (
		PolicyBusinessId,
		BandingTemplateId,
		MigrationRef,
		PortalReference,
		ReportNotes,
		AnnualCharges,
		WrapperCharge,
		InitialAdviceCharge,
		OngoingAdviceCharge,
		PensionIncrease,
		ReservedValue,
		ConcurrencyId,
		PolicyBusinessExtId,
		StampAction,
		StampDateTime,
		StampUser,
		QuoteResultId,
		ApplicationReference,
		MortgageRepayPercentage,
		MortgageRepayAmount,
		IsJointExternal,
		IsLendersSolicitorsUsed,
		SystemPortalReference,
		FundIncome,
		IsVisibleToClient,
		IsVisibilityUpdatedByStatusChange,
		HasDfm,
		HasModelPortfolio,
		AgencyStatus,
		AgencyStatusDate,
		AdditionalNotes,
		InterestRate,
		IsPlanValueVisibleToClient,
		ModelId,
		ForwardIncomeToAdviserId,
		ForwardIncomeToUseAdviserBanding,
		WhoCreatedUserId,
		QuoteId)
    SELECT
        T1.PolicyBusinessId,
		T1.BandingTemplateId,
		T1.MigrationRef,
		T1.PortalReference,
		T1.ReportNotes,
		T1.AnnualCharges,
		T1.WrapperCharge,
		T1.InitialAdviceCharge,
		T1.OngoingAdviceCharge,
		T1.PensionIncrease,
		T1.ReservedValue,
		T1.ConcurrencyId,
		T1.PolicyBusinessExtId,
		'U',
        GETDATE(),
        @UserId,
		T1.QuoteResultId,
		T1.ApplicationReference,
		T1.MortgageRepayPercentage,
		T1.MortgageRepayAmount,
		T1.IsJointExternal,
		T1.IsLendersSolicitorsUsed,
		T1.SystemPortalReference,
		T1.FundIncome,
		T1.IsVisibleToClient,
		T1.IsVisibilityUpdatedByStatusChange,
		T1.HasDfm,
		T1.HasModelPortfolio,
		T1.AgencyStatus,
		T1.AgencyStatusDate,
		T1.AdditionalNotes,
		T1.InterestRate,
		T1.IsPlanValueVisibleToClient,
		T1.ModelId,
		T1.ForwardIncomeToAdviserId,
		T1.ForwardIncomeToUseAdviserBanding,
		WhoCreatedUserId,
		T1.QuoteId
    FROM TPolicyBusinessExt T1 JOIN TPortfolio T2 ON T1.ModelId = T2.PortfolioId
	WHERE T1.ModelId = @PortfolioId

    UPDATE  T1 SET T1.ModelId = null
	FROM TPolicyBusinessExt T1 JOIN TPortfolio T2 ON T1.ModelId = T2.PortfolioId
	WHERE T1.ModelId = @PortfolioId

	-- Handle TPortfolioClient 
	
	SELECT PortfolioClientId INTO #PortfolioClientIds FROM TPortfolioClient T1 WHERE T1.PortfolioId = @PortfolioId

    INSERT INTO TPortfolioClientAudit (
		PortfolioId,
		CreatedBy,
		CreatedDate,
		CRMContactId,
		ConcurrencyId,
		PortfolioClientId,
		StampAction,
		StampDateTime,
		StampUser)
    SELECT
        T1.PortfolioId,
        T1.CreatedBy,
        T1.CreatedDate,
        T1.CRMContactId,
        T1.ConcurrencyId,
        T1.PortfolioClientId,
        'D',
        GETDATE(),
        @UserId
    FROM TPortfolioClient T1 JOIN #PortfolioClientIds T2 ON T1.PortfolioClientId = T2.PortfolioClientId

    DELETE T1 FROM TPortfolioClient T1 JOIN #PortfolioClientIds T2 ON T1.PortfolioClientId = T2.PortfolioClientId

	-- Handle TPortfolioFundAssetChartData 
	
	SELECT PortfolioFundAssetChartDataId INTO #PortfolioFundAssetChartDataIds FROM TPortfolioFundAssetChartData T1 WHERE T1.PortfolioId = @PortfolioId

    INSERT INTO TPortfolioFundAssetChartDataAudit (
		PortfolioId,
		AssetXMLData,
		ConcurrencyId,
		PortfolioFundAssetChartDataId,
		StampAction,
		StampDateTime,
		StampUser)
    SELECT
        T1.PortfolioId,
        T1.AssetXMLData,
        T1.ConcurrencyId,
        T1.PortfolioFundAssetChartDataId,
        'D',
        GETDATE(),
        @UserId
    FROM TPortfolioFundAssetChartData T1 JOIN #PortfolioFundAssetChartDataIds T2 ON T1.PortfolioFundAssetChartDataId = T2.PortfolioFundAssetChartDataId

    DELETE T1 FROM TPortfolioFundAssetChartData T1 JOIN #PortfolioFundAssetChartDataIds T2 ON T1.PortfolioFundAssetChartDataId = T2.PortfolioFundAssetChartDataId

	-- Handle TPortfolioFund 
	
	SELECT PortfolioFundId INTO #PortfolioFundIds FROM TPortfolioFund T1 WHERE T1.PortfolioId = @PortfolioId

    INSERT INTO TPortfolioFundAudit (
		PortfolioId,
		FundUnitId,
		AllocationPercentage,
		IsLocked,
		ConcurrencyId,
		PortfolioFundId,
		UnitId,
		StampAction,
		StampDateTime,
		StampUser)
    SELECT
      	T1.PortfolioId,
		T1.FundUnitId,
		T1.AllocationPercentage,
		T1.IsLocked,
		T1.ConcurrencyId,
		T1.PortfolioFundId,
		T1.UnitId,
        'D',
        GETDATE(),
        @UserId
    FROM TPortfolioFund T1 JOIN #PortfolioFundIds T2 ON T1.PortfolioFundId = T2.PortfolioFundId

    DELETE T1  FROM TPortfolioFund T1 JOIN #PortfolioFundIds T2 ON T1.PortfolioFundId = T2.PortfolioFundId

	-- Handle TPortfolio 

    INSERT INTO TPortfolioAudit (
		Title,
		Description,
		IsPublic,
		IsGroupRestricted,
		GroupId,
		IsIncludeSubGroups,
		IsReadOnly,
		IsActive,
		IsLocked,
		BenchmarkId,
		IsClientPortal,
		ATRPortfolioGuid,
		CreatedBy,
		CreatedDate,
		Client,
		ConcurrencyId,
		Code,
		Provider,
		ChangeDescription,
		MarketCommentaryHref,
		IsPrivate,
		TenantId,
		AppId,
		AllowRebalance,
		PortfolioId,
		FactSheetLink,
		TaxQualified,
		InvestmentManagementStyle,
		StampAction,
		StampDateTime,
		StampUser)

    SELECT
        T1.Title,
        T1.Description,
        T1.IsPublic,
        T1.IsGroupRestricted,
        T1.GroupId,
        T1.IsIncludeSubGroups,
        T1.IsReadOnly,
        T1.IsActive,
        T1.IsLocked,
        T1.BenchmarkId,
        T1.IsClientPortal,
        T1.ATRPortfolioGuid,
        T1.CreatedBy,
        T1.CreatedDate,
        T1.Client,
        T1.ConcurrencyId,
        T1.Code,
        T1.Provider,
        T1.ChangeDescription,
        T1.MarketCommentaryHref,
        T1.IsPrivate,
        T1.TenantId,
        T1.AppId,
        T1.AllowRebalance,
        T1.PortfolioId,
        T1.FactSheetLink,
        T1.TaxQualified,
        T1.InvestmentManagementStyle,
        'D',
        GETDATE(),
        @UserId
    FROM TPortfolio T1
    WHERE T1.PortfolioId = @PortfolioId

    DELETE T2 FROM TPortfolio T2  WHERE T2.PortfolioId = @PortfolioId

	IF @tx = 0 COMMIT TRANSACTION TX

END TRY
BEGIN CATCH
	DECLARE @errorMessage varchar(4000), @ErrorSeverity int, @ErrorState int, @Errorline int, @errornumber int, @ErrorProc sysname

    SELECT @ErrorMessage = ERROR_MESSAGE(),
	@ErrorSeverity = ERROR_SEVERITY(),
	@ErrorState = ERROR_STATE(),
	@ErrorLine = ERROR_LINE(),
	@ErrorNumber = ERROR_NUMBER(),
	@ErrorProc   = ERROR_PROCEDURE()

    IF @tx = 0 ROLLBACK TRANSACTION TX

	RAISERROR ('%s Procedure: %s, Line %d, ErrorNo %d', @ErrorSeverity, @ErrorState, @ErrorMessage, @ErrorProc, @ErrorLine, @ErrorNumber)

END CATCH

END

GO