SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefPlanAction]
	@StampUser varchar (255),
	@RefPlanActionId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefPlanActionAudit 
( 
	Identifier, 
	Description,
	LongDescription, 
	ConcurrencyId, 
	RefPlanActionId, 
	StampAction, 
	StampDateTime, 
	StampUser
) 
Select 
	Identifier, 
	Description,
	LongDescription, 
	ConcurrencyId, 
	RefPlanActionId, 
	@StampAction, 
	GetDate(), 
	@StampUser
FROM 
	TRefPlanAction
WHERE 
	RefPlanActionId = @RefPlanActionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
