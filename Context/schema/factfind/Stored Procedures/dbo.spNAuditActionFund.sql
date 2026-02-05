SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[spNAuditActionFund]

@StampUser varchar (255),
	@ActionFundId bigint,
	@StampAction char(1)
AS

INSERT INTO TActionFundAudit 
( ActionPlanId,
FundId,
FundUnitId,
PercentageAllocation,
PolicyBusinessFundId,
AddManualFundIfFundUnknown,
UnknownFundName,
RegularContributionPercentage,
ActionFundId,
StampAction,
StampDateTime,
StampUser,
AssetFundId,
ManualRecommendationActionId) 

Select 
ActionPlanId,
FundId,
FundUnitId,
PercentageAllocation,
PolicyBusinessFundId,
AddManualFundIfFundUnknown,
UnknownFundName,
RegularContributionPercentage,
ActionFundId,
 @StampAction, GetDate(), @StampUser,
 AssetFundId,
ManualRecommendationActionId 
FROM TActionFund
WHERE ActionFundId = @ActionFundId

GO
