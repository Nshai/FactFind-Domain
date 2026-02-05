SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditPersonalContact]
	@StampUser varchar (255),
	@PersonalContactId bigint,
	@StampAction char(1)
AS

INSERT INTO TPersonalContactAudit 
( PersonalContactId, CRMContactId, IndigoClientId, StampAction, StampDateTime, StampUser) 
Select PersonalContactId, CRMContactId, IndigoClientId, @StampAction, GetDate(), @StampUser
FROM TPersonalContact
WHERE PersonalContactId = @PersonalContactId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
