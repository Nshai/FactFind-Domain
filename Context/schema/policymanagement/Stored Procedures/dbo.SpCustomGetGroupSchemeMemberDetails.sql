
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCustomGetGroupSchemeMemberDetails]
	@PolicyBusinessIds varchar(max), 
	@TenantId int
AS
BEGIN

--DECLARE @PolicyBusinessIds varchar(max) = '205, 206, 207',
--		@TenantId int =10155	

SELECT 
gs.GroupSchemeId																AS GroupSchemeId,
gsm.PolicyBusinessId															AS PlanId,
gs.SchemeName																	AS SchemeName,
spb.SequentialRef																AS SequentialRef,
gs.SchemeNumber																	AS SchemeNumber,
gs.PensionSchemeTaxReference													AS PensionSchemeTaxReference,
gs.RenewalDate																	AS RenewalDate,
gs.StagingDate																	AS StagingDate,
gs.TriAnnualDate																AS TriAnnualReviewDate,
gs.PayrollCutOffDay																AS PayrollCutOffDay,
se.Name																			AS SalaryExchange,
ISNULL(gs.DefaultFund, ISNULL(fu.UnitLongName, nf.FundName))					AS DefaultFund,
gs.AnnualMgmtCharge																AS ActiveMemberAmc,
gs.NonActiveMemberAmcPercentage													AS NonActiveMemberAmc,

gs.LumpSumAnnualMgmtCharge														AS LumpSumAmc,
gs.TransferAnnualMgmtCharge														AS TransfersAmc,

gsc.CategoryName																AS CategoryName,
msrt.Name																		AS MinimumServiceRequirement,
gsc.EligibilityAgeFrom															AS EligibilityAgeFrom,
gsc.EligibilityAgeTo															AS EligibilityAgeTo,
ISNULL(bst.Name, gsc.BasisOfSalaryOther)										AS RetirementBasis,
ISNULL(gsc.StandardRetirementAgeMale, gsc.StandardRetirementAgeFemale)			AS SelectRetirementAge,
gsc.EmployerContribution														AS EmployerContribution,
gsc.EmployeeContribution														AS EmployeeContribution,
ISNULL(ppgsc.EmployerPercentagetoPension, pinfo.PercentageReinvestedToPension)	AS EmployeeReinvestedToPension,
CASE WHEN gsm.JoiningDate IS NOT NULL AND gsm.IsLeaver= 0 THEN 1 ELSE 0 END		AS IsSchemeJoiner,
gsm.JoiningDate																	AS SchemeJoiningDate,
gsm.IsLeaver																	AS IsSchemeLeaver,
gsm.LeavingDate																	AS SchemeLeavingDate,

pcs1.Percentage																	AS ContributionStrategyYear1,
pcs1.Details																	AS ContributionStrategyYear1Details,
pcs2.Percentage																	AS ContributionStrategyYear2,
pcs2.Details																	AS ContributionStrategyYear2Details,
pcs3.Percentage																	AS ContributionStrategyYear3,
pcs3.Details																	AS ContributionStrategyYear3Details,
pcs4.Percentage																	AS ContributionStrategyYear4,
pcs4.Details																	AS ContributionStrategyYear4Details,
pcs5.Percentage																	AS ContributionStrategyYear5,
pcs5.Details																	AS ContributionStrategyYear5Details,
gs.PostponementInformation														AS PostponementInformation
FROM  policymanagement..TGroupSchemeMember gsm WITH(NOLOCK)
JOIN policymanagement..FnSplit(@PolicyBusinessIds,',') parsed ON  parsed.Value = gsm.PolicyBusinessId 
JOIN policymanagement..TGroupScheme gs  WITH(NOLOCK) ON gsm.GroupSchemeId = gs.GroupSchemeId 
JOIN policymanagement..TPolicyBusiness spb WITH(NOLOCK) ON spb.PolicyBusinessId = gs.PolicyBusinessId
LEFT JOIN policymanagement..TRefSalaryExchangeType se WITH(NOLOCK) ON se.RefSalaryExchangeTypeId = gs.RefSalaryExchangeTypeId
JOIN policymanagement..TGroupSchemeCategory gsc WITH(NOLOCK) ON gsc.GroupSchemeCategoryId = gsm.GroupSchemeCategoryId
LEFT JOIN policymanagement..TGroupPersonalPensionSchemeCategory ppgsc WITH(NOLOCK) ON ppgsc.GroupSchemeCategoryId = gsc.GroupSchemeCategoryId 
LEFT JOIN policymanagement..TPensionInfo pinfo WITH(NOLOCK) ON pinfo.PolicyBusinessId = gsm.PolicyBusinessId 
LEFT JOIN policymanagement..TRefMinimumServiceRequirementType msrt WITH(NOLOCK) ON msrt.RefMinimumServiceRequirementTypeId = gsc.MinServiceRequirementType 
LEFT JOIN policymanagement..TRefBasisOfSalaryType bst WITH(NOLOCK) ON bst.RefBasisOfSalaryTypeId = gsc.BasisOfSalary 
LEFT JOIN policymanagement..TPensionContributionStrategy pcs1 WITH(NOLOCK) ON pcs1.PolicyBusinessId = gsm.PolicyBusinessId AND pcs1.Period = 'Year1'
LEFT JOIN policymanagement..TPensionContributionStrategy pcs2 WITH(NOLOCK) ON pcs2.PolicyBusinessId = gsm.PolicyBusinessId AND pcs2.Period = 'Year2'
LEFT JOIN policymanagement..TPensionContributionStrategy pcs3 WITH(NOLOCK) ON pcs3.PolicyBusinessId = gsm.PolicyBusinessId AND pcs3.Period = 'Year3'
LEFT JOIN policymanagement..TPensionContributionStrategy pcs4 WITH(NOLOCK) ON pcs4.PolicyBusinessId = gsm.PolicyBusinessId AND pcs4.Period = 'Year4'
LEFT JOIN policymanagement..TPensionContributionStrategy pcs5 WITH(NOLOCK) ON pcs5.PolicyBusinessId = gsm.PolicyBusinessId AND pcs5.Period = 'Year5'
LEFT JOIN fund2..TFundUnit fu WITH(NOLOCK) ON fu.FundUnitId = gs.DefaultFundUnitId
LEFT JOIN policymanagement..TNonFeedFund nf WITH(NOLOCK) ON nf.NonFeedFundId = gs.DefaultNonFeedFundId
WHERE gs.TenantId = @TenantId
END

--select * from policymanagement..TGroupSchemeMember