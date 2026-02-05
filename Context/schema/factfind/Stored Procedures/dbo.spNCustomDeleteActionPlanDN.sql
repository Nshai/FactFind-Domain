SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCustomDeleteActionPlanDN]

@ActionPlanId bigint	
as

delete from TActionFundDN
where	@ActionPlanId  = actionPlanId
		
delete from TActionPlanDN
where	@ActionPlanId  = actionPlanId
GO
