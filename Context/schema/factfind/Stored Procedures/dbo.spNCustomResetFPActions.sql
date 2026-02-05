SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[spNCustomResetFPActions]


@FinancialPlanningId bigint,
@ScenarioId bigint,
@StampUser varchar(50)

as


--new funds
insert into TActionFundAudit
(
ActionPlanId,
FundId,
FundUnitId,
PercentageAllocation,
PolicyBusinessFundId,
ActionFundId,
StampAction,
StampDateTime,
StampUser
)
select
af.ActionPlanId,
af.FundId,
af.FundUnitId,
af.PercentageAllocation,
af.PolicyBusinessFundId,
af.ActionFundId,
'D',
getdate(),
@StampUser
from TActionFund af
inner join TActionPlan ap on ap.actionplanid = af.actionplanid
where	ap.FinancialPlanningid = @FinancialPlanningId and
		ap.Scenarioid = @ScenarioId and
		policybusinessfundid is null

delete af
from TActionFund af
inner join TActionPlan ap on ap.actionplanid = af.actionplanid
where	ap.FinancialPlanningid = @FinancialPlanningId and
		ap.Scenarioid = @ScenarioId and
		policybusinessfundid is null

--new plans
insert into TACtionPlanAudit
(FinancialPlanningId,
ScenarioId,
Owner1,
Owner2,
RefPlan2ProdSubTypeId,
PercentageAllocation,
PolicyBusinessId,
ActionPlanId,
StampAction,
StampDateTime,
StampUser)
select  
ap.FinancialPlanningId,
ap.ScenarioId,
ap.Owner1,
ap.Owner2,
ap.RefPlan2ProdSubTypeId,
ap.PercentageAllocation,
ap.PolicyBusinessId,
ap.ActionPlanId,
'D',
getdate(),
@StampUser
from TActionPlan ap
where	ap.FinancialPlanningid = @FinancialPlanningId and
		ap.Scenarioid = @ScenarioId and
		policybusinessid is null

delete ap
from TActionPlan ap
where	ap.FinancialPlanningid = @FinancialPlanningId and
		ap.Scenarioid = @ScenarioId and
		policybusinessid is null

--existing funds		
insert into TActionFundAudit
(
ActionPlanId,
FundId,
FundUnitId,
PercentageAllocation,
RegularContributionPercentage,
PolicyBusinessFundId,
ActionFundId,
StampAction,
StampDateTime,
StampUser
)
select
af.ActionPlanId,
af.FundId,
af.FundUnitId,
af.PercentageAllocation,
af.RegularContributionPercentage,
af.PolicyBusinessFundId,
af.ActionFundId,
'U',
getdate(),
@StampUser
from TActionFund af
inner join TActionPlan ap on ap.actionplanid = af.actionplanid
where	ap.FinancialPlanningid = @FinancialPlanningId and
		ap.Scenarioid = @ScenarioId and
		policybusinessfundid is not null		
		
update af
set		PercentageAllocation = -99,
		RegularContributionPercentage = -99
from TActionFund af
inner join TActionPlan ap on ap.actionplanid = af.actionplanid
where	ap.FinancialPlanningid = @FinancialPlanningId and
		ap.Scenarioid = @ScenarioId and
		policybusinessfundid is not null
		
--existing plans		
insert into TACtionPlanAudit
(FinancialPlanningId,
ScenarioId,
Owner1,
Owner2,
RefPlan2ProdSubTypeId,
PercentageAllocation,
Contribution,
IsDefault,
IsDefaultContribution,
PolicyBusinessId,
ActionPlanId,
StampAction,
StampDateTime,
StampUser)
select  
ap.FinancialPlanningId,
ap.ScenarioId,
ap.Owner1,
ap.Owner2,
ap.RefPlan2ProdSubTypeId,
ap.PercentageAllocation,
ap.Contribution,
ap.IsDefault,
ap.IsDefaultContribution,
ap.PolicyBusinessId,
ap.ActionPlanId,
'U',
getdate(),
@StampUser
from TActionPlan ap
where	ap.FinancialPlanningid = @FinancialPlanningId and
		ap.Scenarioid = @ScenarioId and
		policybusinessid is not null

update ap
set		PercentageAllocation = -99 ,
Contribution = PlanContributionAmount, -- reset to original plan's contribution,
IsDefault = 0, -- set it back to false so that fund percentages can be recalculated
IsDefaultContribution = 0,  -- set it back to false so that fund percentages can be recalculated
RevisedValueDifferenceAmount = 0

from TActionPlan ap
where	ap.FinancialPlanningid = @FinancialPlanningId and
		ap.Scenarioid = @ScenarioId and
		policybusinessid is not null
						
GO
