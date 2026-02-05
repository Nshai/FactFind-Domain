SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomCreateActionFundDN]

@ActionFundId bigint,
@ActionPlanId bigint,
@FundId	bigint,
@FundUnitId	bigint,
@PercentageAllocation decimal(18, 2),
@RegularContributionPercentage decimal (18,2),
@IsFromFeed bit = 0
	
as

delete from TActionFundDN
where	@ActionFundId = actionfundId and
		@ActionPlanId  = actionPlanId
		
insert into TActionFundDN
(
ActionPlanId,
ActionFundId,
FundId,
FundUnitId,
PercentageAllocation,
RegularContributionPercentage,
IsFromFeed
)
select
@ActionPlanId,
@ActionFundId,
@FundId,
@FundUnitId,
@PercentageAllocation,
@RegularContributionPercentage,
@IsFromFeed
GO
