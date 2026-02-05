SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCustomUpdateActionPlanExecuted]
@ActionPlanId bigint,
@IsExecuted bit

as

update	TActionPlan
set		IsExecuted = @IsExecuted
where	ActionPlanId = @ActionPlanId
GO
