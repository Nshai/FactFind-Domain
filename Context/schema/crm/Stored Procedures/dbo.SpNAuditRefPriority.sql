SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefPriority]
	@StampUser varchar (255),
	@RefPriorityId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefPriorityAudit 
( PriorityName, IndClientId, ConcurrencyId, 
	RefPriorityId, StampAction, StampDateTime, StampUser) 
Select PriorityName, IndClientId, ConcurrencyId, 
	RefPriorityId, @StampAction, GetDate(), @StampUser
FROM TRefPriority
WHERE RefPriorityId = @RefPriorityId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
