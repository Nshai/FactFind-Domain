SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCustomDeleteActionFundsForActionPlan]

@actionplanid bigint,
@stampuser varchar(50)

as


insert into TActionFundAudit
(ActionPlanId,
FundId,
FundUnitId,
PercentageAllocation,
PolicyBusinessFundId,
ActionFundId,
StampAction,
StampDateTime,
StampUser)
select
ActionPlanId,
FundId,
FundUnitId,
PercentageAllocation,
PolicyBusinessFundId,
ActionFundId,
'D',
getdate(),
@stampuser
from TActionFund where actionplanid = @actionplanid

delete
from TActionFund where actionplanid = @actionplanid
GO
