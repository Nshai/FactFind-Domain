SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpCustomUpdateExcludedPlanEmailSent] as

insert into TValExcludedPlanAudit
(
PolicyBusinessId,
RefProdProviderId,
ExcludedByUserId,
ExcludedDate,
EmailAlertSent,
ConcurrencyId,
ValExcludedPlanId,
StampAction,
StampDateTime,
StampUser
)
select
PolicyBusinessId,
RefProdProviderId,
ExcludedByUserId,
ExcludedDate,
EmailAlertSent,
ConcurrencyId,
ValExcludedPlanId,
'U',
getdate(),
'999999999'
from TValExcludedPlan
where	EmailAlertSent = 0

update	e
set		e.EmailAlertSent = 1
from	TValExcludedPlan e
where	EmailAlertSent = 0
GO
