SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefValScheduleItemStatus]
	@StampUser varchar (255),
	@RefValScheduleItemStatusId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefValScheduleItemStatusAudit 
( Identifier, ConcurrencyId, 
	RefValScheduleItemStatusId, StampAction, StampDateTime, StampUser) 
Select Identifier, ConcurrencyId, 
	RefValScheduleItemStatusId, @StampAction, GetDate(), @StampUser
FROM TRefValScheduleItemStatus
WHERE RefValScheduleItemStatusId = @RefValScheduleItemStatusId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
