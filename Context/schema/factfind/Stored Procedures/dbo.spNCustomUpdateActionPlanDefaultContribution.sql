SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCustomUpdateActionPlanDefaultContribution]
@ActionPlanId bigint,
@IsDefaultContribution bit

as

update	TActionPlan
set		IsDefaultContribution = @IsDefaultContribution
where	ActionPlanId = @ActionPlanId
GO
