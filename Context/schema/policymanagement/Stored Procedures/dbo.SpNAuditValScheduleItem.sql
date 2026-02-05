SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditValScheduleItem]
	@StampUser varchar (255),
	@ValScheduleItemId bigint,
	@StampAction char(1)
AS

INSERT INTO TValScheduleItemAudit 
( ValScheduleId, ValQueueId, NextOccurrence, LastOccurrence, 
	ErrorMessage, RefValScheduleItemStatusId, SaveAsFilePathAndName, ConcurrencyId, 
	ValScheduleItemId, StampAction, StampDateTime, StampUser, DocVersionId) 
Select ValScheduleId, ValQueueId, NextOccurrence, LastOccurrence, 
	ErrorMessage, RefValScheduleItemStatusId, SaveAsFilePathAndName, ConcurrencyId, 
	ValScheduleItemId, @StampAction, GetDate(), @StampUser, DocVersionId
FROM TValScheduleItem
WHERE ValScheduleItemId = @ValScheduleItemId


IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
