SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPlanContact]
	@StampUser varchar (255),
	@PlanContactId bigint,
	@StampAction char(1)
AS

INSERT INTO TPlanContactAudit 
( PlanContactId, SubjectId, SubjectType, PolicyBusinessId, 
	IsTrusted,StampAction, StampDateTime, StampUser) 
Select PlanContactId,SubjectId, SubjectType, PolicyBusinessId, 
	IsTrusted, @StampAction, GetDate(), @StampUser
FROM TPlanContact
WHERE PlanContactId = @PlanContactId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
