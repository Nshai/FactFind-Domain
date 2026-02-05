SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrievePolicyBusinessFundById]
	@PolicyBusinessFundId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.PolicyBusinessFundId AS [PolicyBusinessFund!1!PolicyBusinessFundId], 
	T1.PolicyBusinessId AS [PolicyBusinessFund!1!PolicyBusinessId], 
	T1.FundId AS [PolicyBusinessFund!1!FundId], 
	ISNULL(T1.FundTypeId, '') AS [PolicyBusinessFund!1!FundTypeId], 
	ISNULL(T1.FundName, '') AS [PolicyBusinessFund!1!FundName], 
	ISNULL(T1.CategoryId, '') AS [PolicyBusinessFund!1!CategoryId], 
	ISNULL(T1.CategoryName, '') AS [PolicyBusinessFund!1!CategoryName], 
	ISNULL(CONVERT(varchar(24), T1.CurrentUnitQuantity), '') AS [PolicyBusinessFund!1!CurrentUnitQuantity], 
	ISNULL(CONVERT(varchar(24), T1.LastUnitChangeDate, 120), '') AS [PolicyBusinessFund!1!LastUnitChangeDate], 
	ISNULL(CONVERT(varchar(24), T1.CurrentPrice), '') AS [PolicyBusinessFund!1!CurrentPrice], 
	ISNULL(CONVERT(varchar(24), T1.LastPriceChangeDate, 120), '') AS [PolicyBusinessFund!1!LastPriceChangeDate], 
	ISNULL(T1.PriceUpdatedByUser, '') AS [PolicyBusinessFund!1!PriceUpdatedByUser], 
	T1.FromFeedFg AS [PolicyBusinessFund!1!FromFeedFg], 
	ISNULL(T1.FundIndigoClientId, '') AS [PolicyBusinessFund!1!FundIndigoClientId], 
	ISNULL(T1.InvestmentTypeId, '') AS [PolicyBusinessFund!1!InvestmentTypeId], 
	ISNULL(T1.RiskRating, '') AS [PolicyBusinessFund!1!RiskRating], 
	T1.EquityFg AS [PolicyBusinessFund!1!EquityFg], 
	T1.ConcurrencyId AS [PolicyBusinessFund!1!ConcurrencyId]
	FROM TPolicyBusinessFund T1
	
	WHERE T1.PolicyBusinessFundId = @PolicyBusinessFundId
	ORDER BY [PolicyBusinessFund!1!PolicyBusinessFundId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
