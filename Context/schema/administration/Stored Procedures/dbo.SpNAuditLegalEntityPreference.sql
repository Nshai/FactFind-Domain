SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditLegalEntityPreference]
	@StampUser varchar (255),
	@LegalEntityPreferenceId bigint,
	@StampAction char(1)
AS

INSERT INTO TLegalEntityPreferenceAudit 
( GroupId, PreferenceName, PreferenceValue, ConcurrencyId, 
		
	LegalEntityPreferenceId, StampAction, StampDateTime, StampUser) 
Select GroupId, PreferenceName, PreferenceValue, ConcurrencyId, 
		
	LegalEntityPreferenceId, @StampAction, GetDate(), @StampUser
FROM TLegalEntityPreference
WHERE LegalEntityPreferenceId = @LegalEntityPreferenceId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
