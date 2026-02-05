SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditUserPreference]
	@StampUser varchar (255),
	@UserPreferenceId bigint,
	@StampAction char(1)
AS

INSERT INTO TUserPreferenceAudit 
( UserId, PreferenceName, PreferenceValue, ConcurrencyId, 
		
	UserPreferenceId, StampAction, StampDateTime, StampUser) 
Select UserId, PreferenceName, PreferenceValue, ConcurrencyId, 
		
	UserPreferenceId, @StampAction, GetDate(), @StampUser
FROM TUserPreference
WHERE UserPreferenceId = @UserPreferenceId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
