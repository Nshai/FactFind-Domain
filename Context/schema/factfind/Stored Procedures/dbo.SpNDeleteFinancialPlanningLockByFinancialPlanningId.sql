SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNDeleteFinancialPlanningLockByFinancialPlanningId]
	@StampUser varchar (255),
	@FinancialPlanningId bigint	
AS


DECLARE @FinancialPlanningLockId bigint

select	@FinancialPlanningLockId = FinancialPlanningLockId from TFinancialPlanningLock where @FinancialPlanningId = FinancialPlanningId

if (isnull(@FinancialPlanningLockId,0) > 0) begin

	Execute dbo.SpNAuditFinancialPlanningLock @StampUser, @FinancialPlanningLockId, 'D'			
		
	delete TFinancialPlanningLock
	where FinancialPlanningId = @FinancialPlanningId

end 

RETURN (0)
GO
