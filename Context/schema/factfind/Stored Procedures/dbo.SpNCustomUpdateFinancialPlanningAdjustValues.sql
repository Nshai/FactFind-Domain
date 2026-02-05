SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpNCustomUpdateFinancialPlanningAdjustValues] 
@StampUser varchar (255),
@FinancialPlanningId bigint,
@Adjust bit

as

exec dbo.SpNAuditFinancialPlanning @StampUser,@FinancialPlanningId,'U'

update	TFinancialPlanning
set		AdjustValue = @Adjust
where	FinancialPlanningId = @FinancialPlanningId
GO
