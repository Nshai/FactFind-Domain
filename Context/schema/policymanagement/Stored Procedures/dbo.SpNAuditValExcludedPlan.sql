SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditValExcludedPlan]
	@StampUser varchar (255),
	@ValExcludedPlanId bigint,
	@StampAction char(1)
AS

INSERT INTO TValExcludedPlanAudit 
( PolicyBusinessId, RefProdProviderId, ExcludedByUserId, ExcludedDate, 
		EmailAlertSent, ConcurrencyId, 
	ValExcludedPlanId, StampAction, StampDateTime, StampUser) 
Select PolicyBusinessId, RefProdProviderId, ExcludedByUserId, ExcludedDate, 
		EmailAlertSent, ConcurrencyId, 
	ValExcludedPlanId, @StampAction, GetDate(), @StampUser
FROM TValExcludedPlan
WHERE ValExcludedPlanId = @ValExcludedPlanId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
