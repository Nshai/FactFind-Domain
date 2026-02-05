SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefTaskStatus]
	@StampUser varchar (255),
	@RefTaskStatusId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefTaskStatusAudit 
( Name, ConcurrencyId, 
	RefTaskStatusId, StampAction, StampDateTime, StampUser) 
Select Name, ConcurrencyId, 
	RefTaskStatusId, @StampAction, GetDate(), @StampUser
FROM TRefTaskStatus
WHERE RefTaskStatusId = @RefTaskStatusId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
