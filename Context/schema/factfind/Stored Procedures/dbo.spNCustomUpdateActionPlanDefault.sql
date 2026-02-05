SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCustomUpdateActionPlanDefault]
@ActionPlanId bigint,
@IsDefault bit

as

update	TActionPlan
set		IsDefault = @IsDefault
where	ActionPlanId = @ActionPlanId
GO
