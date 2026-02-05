SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Drop VIEW dbo.VPolicyBusiness_V2
CREATE VIEW dbo.VPolicyBusiness_V2

AS

SELECT	PB.PolicyBusinessId, PB.PolicyDetailId, PB.PolicyNumber, PB.PractitionerId, PB.ReplaceNotes, PB.TnCCoachId, PB.AdviceTypeId, PB.BestAdvicePanelUsedFG, 
	PB.WaiverDefermentPeriod, PB.IndigoClientId, PB.SwitchFG, PB.TotalRegularPremium, PB.TotalLumpSum, PB.MaturityDate, PB.LifeCycleId, PB.PolicyStartDate, 
	PB.PremiumType, PB.AgencyNumber, PB.ProviderAddress, PB.OffPanelFg, PB.BaseCurrency, PB.ExpectedPaymentDate, PB.ProductName, PB.InvestmentTypeId, 
	PB.RiskRating, PB.SequentialRef, PB.ConcurrencyId, PB.IsGuaranteedToProtectOriginalInvestment, PB.ClientTypeId, PB.PlanMigrationRef, PB.UsePriceFeed, 
	PB.LowMaturityValue, PB.MediumMaturityValue, PB.HighMaturityValue, PB.ProjectionDetails, PB.TopupMasterPolicyBusinessId, PB.ServicingUserId as ServicingUserId, 
	P.CRMContactId AS AdviserCRMContactId, U.CRMContactId AS TnCCoachCRMContactId, AU.CRMContactId AS ServicingCRMContactId, PB.PropositionTypeId,
	Case When scheme.GroupSchemeId is null then 0 else 1 End as IsGroupScheme,
	Case When schemeMember.GroupSchemeMemberId is null then 0 else 1 End as IsGroupSchemeMember
	, adviceType.[Description] As AdviceTypeName, adviceType.IntelligentOfficeAdviceType as AdviceTypeIntelligentOfficeAdviceType
	, pbext.PolicyBusinessExtId
	, PB.ParaplannerUserId
	, PB.GroupId
	, pbext.IsProviderManaged
	, PB.PerformanceStartDate
	, PB.PerformanceEndDate
	, PB.ProviderCode2
	, PB.ProviderCode3
FROM dbo.TPolicyBusiness AS PB
INNER JOIN crm.dbo.TPractitioner AS P ON P.PractitionerId = PB.PractitionerId And PB.IndigoClientId = p.IndClientId
LEFT OUTER JOIN compliance.dbo.TTnCCoach AS TnC ON TnC.TnCCoachId = PB.TnCCoachId 
LEFT OUTER JOIN administration.dbo.TUser AS U ON U.UserId = TnC.UserId And PB.IndigoClientId= U.IndigoClientId
LEFT OUTER JOIN administration.dbo.TUser AS AU ON AU.UserId = PB.ServicingUserId And PB.IndigoClientId = AU.IndigoClientId
LEFT JOIN dbo.TGroupScheme as scheme on PB.PolicyBusinessId = scheme.PolicyBusinessId 
LEFT JOIN dbo.TGroupSchemeMember as schemeMember on PB.PolicyBusinessId = schemeMember.PolicyBusinessId 
INNER JOIN TAdviceType adviceType on PB.AdviceTypeId = adviceType.AdviceTypeId And PB.IndigoClientId = adviceType.IndigoClientId
LEFT OUTER JOIN TPolicyBusinessExt pbext on pbext.PolicyBusinessId = pb.PolicyBusinessId
