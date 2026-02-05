SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditIndigoClientPreference]
	@StampUser varchar (255),
	@IndigoClientPreferenceId bigint,
	@StampAction char(1)
AS

INSERT INTO TIndigoClientPreferenceAudit 
( IndigoClientId, IndigoClientGuid, PreferenceName, Value, 
		Disabled, Guid, ConcurrencyId, 
	IndigoClientPreferenceId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, IndigoClientGuid, PreferenceName, Value, 
		Disabled, Guid, ConcurrencyId, 
	IndigoClientPreferenceId, @StampAction, GetDate(), @StampUser
FROM TIndigoClientPreference
WHERE IndigoClientPreferenceId = @IndigoClientPreferenceId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
