SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditUserCalendarConfig]
	@StampUser varchar (255),
	@UserCalendarConfigId bigint,
	@StampAction char(1)
AS

INSERT INTO TUserCalendarConfigAudit 
( UserId, DateTime, ConcurrencyId, 
	UserCalendarConfigId, StampAction, StampDateTime, StampUser) 
Select UserId, DateTime, ConcurrencyId, 
	UserCalendarConfigId, @StampAction, GetDate(), @StampUser
FROM TUserCalendarConfig
WHERE UserCalendarConfigId = @UserCalendarConfigId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
