SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditActivityCategory2RefSystemEvent]
	@StampUser varchar (255),
	@ActivityCategory2RefSystemEventId bigint,
	@StampAction char(1)
AS

INSERT INTO TActivityCategory2RefSystemEventAudit 
( ActivityCategoryId, RefSystemEventId, ConcurrencyId, 
	ActivityCategory2RefSystemEventId, StampAction, StampDateTime, StampUser) 
Select ActivityCategoryId, RefSystemEventId, ConcurrencyId, 
	ActivityCategory2RefSystemEventId, @StampAction, GetDate(), @StampUser
FROM TActivityCategory2RefSystemEvent
WHERE ActivityCategory2RefSystemEventId = @ActivityCategory2RefSystemEventId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
