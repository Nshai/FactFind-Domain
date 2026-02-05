SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditPersonalContact2Client]
	@StampUser varchar (255),
	@PersonalContact2ClientId bigint,
	@StampAction char(1)
AS

INSERT INTO TPersonalContact2ClientAudit 
( PersonalContact2ClientId, CRMContactId, PersonalContactId, StampAction, StampDateTime, StampUser) 
SELECT PersonalContact2ClientId, CRMContactId, PersonalContactId, @StampAction, GetDate(), @StampUser
FROM TPersonalContact2Client
WHERE PersonalContact2ClientId = @PersonalContact2ClientId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
