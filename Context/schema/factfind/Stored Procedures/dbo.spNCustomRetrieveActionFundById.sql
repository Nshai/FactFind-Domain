SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomRetrieveActionFundById]      

@ActionFundId bigint
      
as      

SELECT F.ActionPlanId,
F.FundId,
F.FundUnitId,
F.PercentageAllocation,
F.PolicyBusinessFundId,
F.AddManualFundIfFundUnknown,
F.UnknownFundName,
F.RegularContributionPercentage,
P.IsDefault,
P.IsDefaultContribution

FROM TActionFund F
INNER JOIN TActionPlan  P 
	ON F.ActionPlanId = P.ActionPlanId

WHERE ActionFundId = @ActionFundId
 

GO


