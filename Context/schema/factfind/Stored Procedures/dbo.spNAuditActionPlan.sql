SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNAuditActionPlan]  
  
@StampUser varchar (255),  
 @ActionPlanId bigint,  
 @StampAction char(1)  
AS  
  
INSERT INTO TActionPlanAudit   
	( 
	FinancialPlanningId,  
	ScenarioId,  
	Owner1,  
	Owner2,  
	RefPlan2ProdSubTypeId,  
	PercentageAllocation,  
	PolicyBusinessId,  
	ActionPlanId, 
	StampAction, 
	StampDateTime, 
	StampUser,
	Contribution,
	withdrawal,
	IsOffPanel,
	PlanRecommendationCategory,
	PlanTypeThirdPartyCode,
	PlanTypeThirdPartyDescription,
	ProviderName,
	TopupParentPolicyBusinessId	,
	PlanContributionAmount,
	RevisedValueDifferenceAmount,
	RevisedPercentage,
	IsDefault,
	IsDefaultContribution,
	SolutionGroupId,
	IsNewProposal,
	SellingAdviserPartyId
	)   	
Select 
	FinancialPlanningId,  
	ScenarioId,  
	Owner1,  
	Owner2,  
	RefPlan2ProdSubTypeId,  
	PercentageAllocation,  
	PolicyBusinessId,  
	ActionPlanId, 
	@StampAction, 
	GetDate(), 
	@StampUser,
	Contribution  ,
	withdrawal,
	IsOffPanel,
	PlanRecommendationCategory,
	PlanTypeThirdPartyCode,
	PlanTypeThirdPartyDescription,
	ProviderName,
	TopupParentPolicyBusinessId	,
	PlanContributionAmount,
	RevisedValueDifferenceAmount,
	RevisedPercentage,
	IsDefault	,
	IsDefaultContribution,
	SolutionGroupId,
	IsNewProposal,
	SellingAdviserPartyId
FROM TActionPlan  
WHERE ActionPlanId = @ActionPlanId  


GO
