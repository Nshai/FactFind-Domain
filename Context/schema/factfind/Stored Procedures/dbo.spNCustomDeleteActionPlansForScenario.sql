SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCustomDeleteActionPlansForScenario]
@ActionPlanid bigint,
@FinancialPlanningId bigint,
@scenarioid bigint,
@StampUser varchar(50)

as

exec spNAuditActionPlan @StampUser,@ActionPlanId,'D'

delete	a
from	TActionPlan a
where	financialplanningid = @FinancialPlanningId and
		scenarioid = @scenarioid and
		actionplanid = @ActionPlanid

			
		
GO
