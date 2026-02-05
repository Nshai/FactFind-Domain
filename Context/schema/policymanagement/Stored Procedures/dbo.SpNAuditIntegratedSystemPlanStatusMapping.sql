SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditIntegratedSystemPlanStatusMapping]
	@StampUser varchar (255),
	@IntegratedSystemPlanStatusMappingId bigint,
	@StampAction char(1)
AS

INSERT INTO TIntegratedSystemPlanStatusMappingAudit 
( 
	ApplicationLinkId, ChangePlanStatusToInForce, ConcurrencyId, IntegratedSystemPlanStatusMappingId, StampAction, StampDateTime, StampUser) 

Select ApplicationLinkId, ChangePlanStatusToInForce, ConcurrencyId, IntegratedSystemPlanStatusMappingId, @StampAction, GetDate(), @StampUser
FROM TIntegratedSystemPlanStatusMapping
WHERE IntegratedSystemPlanStatusMappingId = @IntegratedSystemPlanStatusMappingId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
