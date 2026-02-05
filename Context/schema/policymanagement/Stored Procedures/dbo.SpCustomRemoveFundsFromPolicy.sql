SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRemoveFundsFromPolicy]
	@PolicyBusinessId bigint
AS
BEGIN

	SET XACT_ABORT ON
	--
	-- TODO: When TPolicyBusinessFundTransaction becomes a synonym to TPolicyBusinessTransaction
	--       we need to change this code so that the references to TPolicyBusinessFundTransaction use TenantId
	--       because the new table is partitioned by TenantId
	--
	DECLARE @tx int
	SELECT @tx = @@TRANCOUNT
	IF @tx = 0 BEGIN TRANSACTION TX
	
	BEGIN TRY

		-- DELETE all PolicyBusinessFundTransation records for this policy
		INSERT INTO TPolicyBusinessFundTransactionAudit (PolicyBusinessFundId, TransactionDate, RefFundTransactionTypeId, Gross, Cost, UnitPrice, UnitQuantity, ConcurrencyId, PolicyBusinessFundTransactionId, StampAction, StampDateTime, StampUser)
		SELECT pbft.PolicyBusinessFundId, TransactionDate, RefFundTransactionTypeId, Gross, pbft.Cost, UnitPrice, UnitQuantity, pbft.ConcurrencyId, PolicyBusinessFundTransactionId, 'D', getdate(), '0'
		FROM TPolicyBusinessFundTransaction pbft
		INNER JOIN TPolicyBusinessFund pbf ON pbft.PolicyBusinessFundId = pbf.PolicyBusinessFundId
		WHERE pbf.PolicyBusinessId = @PolicyBusinessId

		DELETE FROM pbft
		FROM TPolicyBusinessFundTransaction pbft
		INNER JOIN TPolicyBusinessFund pbf on pbft.PolicyBusinessFundId = pbf.PolicyBusinessFundId
		WHERE pbf.PolicyBusinessId = @PolicyBusinessId

		-- DELETE all PolicyBusinessFund records for this policy
		INSERT INTO TPolicyBusinessFundAudit (PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName, CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice, LastPriceChangeDate, PriceUpdatedByUser, FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating, ConcurrencyId, PolicyBusinessFundId, StampAction, StampDateTime, StampUser)
		SELECT PolicyBusinessId, FundId, FundTypeId, FundName, CategoryId, CategoryName, CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice, LastPriceChangeDate, PriceUpdatedByUser, FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating, ConcurrencyId, PolicyBusinessFundId, 'D', getdate(), '0'
		FROM TPolicyBusinessFund
		WHERE PolicyBusinessId = @PolicyBusinessId

		DELETE FROM TPolicyBusinessFund
		WHERE PolicyBusinessId = @PolicyBusinessId

		IF @tx = 0
			COMMIT TRANSACTION TX;

	END TRY
	BEGIN CATCH
		IF @tx = 0
			ROLLBACK TRANSACTION TX;
		THROW;
	END CATCH
END
GO
