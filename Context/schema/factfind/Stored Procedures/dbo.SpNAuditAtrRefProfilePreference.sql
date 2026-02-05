SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrRefProfilePreference]
	@StampUser varchar (255),
	@AtrRefProfilePreferenceId bigint,
	@StampAction char(1)
AS

INSERT INTO TAtrRefProfilePreferenceAudit 
( Identifier, Descriptor, ConcurrencyId, 
	AtrRefProfilePreferenceId, StampAction, StampDateTime, StampUser) 
Select Identifier, Descriptor, ConcurrencyId, 
	AtrRefProfilePreferenceId, @StampAction, GetDate(), @StampUser
FROM TAtrRefProfilePreference
WHERE AtrRefProfilePreferenceId = @AtrRefProfilePreferenceId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
