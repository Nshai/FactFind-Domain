SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefPlanningType]
	@StampUser varchar (255),
	@RefPlanningTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefPlanningTypeAudit 
( PlanningType, ConcurrencyId, 
	RefPlanningTypeId, StampAction, StampDateTime, StampUser) 
Select PlanningType, ConcurrencyId, 
	RefPlanningTypeId, @StampAction, GetDate(), @StampUser
FROM TRefPlanningType
WHERE RefPlanningTypeId = @RefPlanningTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
