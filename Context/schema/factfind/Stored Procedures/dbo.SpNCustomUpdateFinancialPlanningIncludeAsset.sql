SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpNCustomUpdateFinancialPlanningIncludeAsset] 
@StampUser varchar (255),
@FinancialPlanningId bigint,
@Include bit

as

exec dbo.SpNAuditFinancialPlanning @StampUser,@FinancialPlanningId,'U'

update	TFinancialPlanning
set		IncludeAssets = @Include
where	FinancialPlanningId = @FinancialPlanningId
GO
