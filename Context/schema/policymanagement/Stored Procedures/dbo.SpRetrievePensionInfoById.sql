SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrievePensionInfoById]
	@PensionInfoId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.PensionInfoId AS [PensionInfo!1!PensionInfoId], 
	T1.PolicyBusinessId AS [PensionInfo!1!PolicyBusinessId], 
	ISNULL(T1.SRA, '') AS [PensionInfo!1!SRA], 
	ISNULL(CONVERT(varchar(24), T1.PensionableSalary), '') AS [PensionInfo!1!PensionableSalary], 
	ISNULL(T1.RefReturnDeathTypeId, '') AS [PensionInfo!1!RefReturnDeathTypeId], 
	ISNULL(CONVERT(varchar(24), T1.ReturnOnDeathRate), '') AS [PensionInfo!1!ReturnOnDeathRate], 
	ISNULL(T1.ProtectedRightsOnly, '') AS [PensionInfo!1!ProtectedRightsOnly], 
	ISNULL(T1.QualifiesDSSIncentive, '') AS [PensionInfo!1!QualifiesDSSIncentive], 
	ISNULL(T1.RefLifeCoverId, '') AS [PensionInfo!1!RefLifeCoverId], 
	ISNULL(T1.RebatePaid, '') AS [PensionInfo!1!RebatePaid], 
	ISNULL(T1.ContributionUpdated, '') AS [PensionInfo!1!ContributionUpdated], 
	ISNULL(T1.IsCurrent, '') AS [PensionInfo!1!IsCurrent], 
	ISNULL(T1.RefSchemeSetUpId, '') AS [PensionInfo!1!RefSchemeSetUpId], 
	ISNULL(T1.HasWidowsPension, '') AS [PensionInfo!1!HasWidowsPension], 
	ISNULL(T1.HasProtectionAgainstInflation, '') AS [PensionInfo!1!HasProtectionAgainstInflation], 
	ISNULL(T1.ProvidesTaxFreeLumpSum, '') AS [PensionInfo!1!ProvidesTaxFreeLumpSum], 
	ISNULL(T1.ContractedOutOfS2P, '') AS [PensionInfo!1!ContractedOutOfS2P], 
	ISNULL(T1.ExpectedYearsOfService, '') AS [PensionInfo!1!ExpectedYearsOfService], 
	ISNULL(T1.NumberOfYearsCompleted, '') AS [PensionInfo!1!NumberOfYearsCompleted], 
	ISNULL(T1.IsIndexed, '') AS [PensionInfo!1!IsIndexed], 
	ISNULL(T1.RefSchemeBasisId, '') AS [PensionInfo!1!RefSchemeBasisId], 
	ISNULL(CONVERT(varchar(24), T1.FinalSalary), '') AS [PensionInfo!1!FinalSalary], 
	ISNULL(T1.RefContributionPercentageId, '') AS [PensionInfo!1!RefContributionPercentageId], 
	ISNULL(CONVERT(varchar(24), T1.SpousePensionPayableOnDeath), '') AS [PensionInfo!1!SpousePensionPayableOnDeath], 
	ISNULL(CONVERT(varchar(24), T1.ServiceBenefitSpouseEntitled), '') AS [PensionInfo!1!ServiceBenefitSpouseEntitled], 
	ISNULL(CONVERT(varchar(24), T1.BenefitsPayableOnDeath), '') AS [PensionInfo!1!BenefitsPayableOnDeath], 
	ISNULL(CONVERT(varchar(24), T1.DeathBenefit), '') AS [PensionInfo!1!DeathBenefit], 
	ISNULL(T1.IsInTrust, '') AS [PensionInfo!1!IsInTrust], 
	ISNULL(T1.IsNRADeffered, '') AS [PensionInfo!1!IsNRADeffered], 
	T1.ConcurrencyId AS [PensionInfo!1!ConcurrencyId],
	ISNULL(T1.HistoricalCrystallisedPercentage, '') AS [PensionInfo!1!HistoricalCrystallisedPercentage],
	ISNULL(T1.CurrentCrystallisedPercentage, '') AS [PensionInfo!1!CurrentCrystallisedPercentage],
	ISNULL(T1.CrystallisedPercentage, '') AS [PensionInfo!1!CrystallisedPercentage],
	ISNULL(T1.UncrystallisedPercentage, '') AS [PensionInfo!1!UncrystallisedPercentage]
	
	FROM TPensionInfo T1
	
	WHERE T1.PensionInfoId = @PensionInfoId
	ORDER BY [PensionInfo!1!PensionInfoId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
