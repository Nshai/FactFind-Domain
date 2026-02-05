SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpCustomCreateFileQueuePlanAction] @PolicyBusinessId bigint as

declare @RefPlanActionId bigint, @identity bigint
select @RefPlanActionId = RefPlanActionId from TRefPlanAction where identifier = 'filechecking'

insert into TPlanActionHistory
(PolicyBusinessId,
RefPlanActionId,
ChangedTo,
DateOfChange,
ChangedByUserId,
ConcurrencyId)
select
@PolicyBusinessId,
@RefPlanActionId,
'Added to File Queue',
getdate(),
0,
1

select @identity = SCOPE_IDENTITY()

insert into TPlanActionHistoryAudit
(PlanActionHistoryId,
PolicyBusinessId,
RefPlanActionId,
ChangedTo,
DateOfChange,
ChangedByUserId,
ConcurrencyId,
StampAction,
StampDateTime,
StampUser)
select
PlanActionHistoryId,
PolicyBusinessId,
RefPlanActionId,
ChangedTo,
DateOfChange,
ChangedByUserId,
ConcurrencyId,
'C',
getdate(),
'999999999'
from TPlanActionHistory
where @identity = PlanActionHistoryId
GO
