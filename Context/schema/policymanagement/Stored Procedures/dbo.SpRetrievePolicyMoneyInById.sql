SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrievePolicyMoneyInById]
	@PolicyMoneyInId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.PolicyMoneyInId AS [PolicyMoneyIn!1!PolicyMoneyInId], 
	ISNULL(CONVERT(varchar(24), T1.Amount), '') AS [PolicyMoneyIn!1!Amount], 
	ISNULL(CONVERT(varchar(24), T1.EscalationPercentage), '') AS [PolicyMoneyIn!1!EscalationPercentage], 
	T1.RefFrequencyId AS [PolicyMoneyIn!1!RefFrequencyId], 
	ISNULL(CONVERT(varchar(24), T1.StartDate, 120), '') AS [PolicyMoneyIn!1!StartDate], 
	T1.PolicyBusinessId AS [PolicyMoneyIn!1!PolicyBusinessId], 
	ISNULL(T1.RefTaxBasisId, '') AS [PolicyMoneyIn!1!RefTaxBasisId], 
	ISNULL(T1.RefTaxYearId, '') AS [PolicyMoneyIn!1!RefTaxYearId], 
	ISNULL(T1.RefContributionTypeId, '') AS [PolicyMoneyIn!1!RefContributionTypeId], 
	ISNULL(T1.RefContributorTypeId, '') AS [PolicyMoneyIn!1!RefContributorTypeId], 
	ISNULL(T1.CurrentFg, '') AS [PolicyMoneyIn!1!CurrentFg], 
	ISNULL(T1.RefEscalationTypeId, '') AS [PolicyMoneyIn!1!RefEscalationTypeId], 
	ISNULL(CONVERT(varchar(24), T1.SalaryPercentage), '') AS [PolicyMoneyIn!1!SalaryPercentage], 
	ISNULL(CONVERT(varchar(24), T1.StopDate, 120), '') AS [PolicyMoneyIn!1!StopDate], 
	T1.ConcurrencyId AS [PolicyMoneyIn!1!ConcurrencyId]
	FROM TPolicyMoneyIn T1
	
	WHERE T1.PolicyMoneyInId = @PolicyMoneyInId
	ORDER BY [PolicyMoneyIn!1!PolicyMoneyInId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
