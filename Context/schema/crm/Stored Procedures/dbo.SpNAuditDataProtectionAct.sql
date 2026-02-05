SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditDataProtectionAct]
	@StampUser varchar (255),
	@DataProtectionActId bigint,
	@StampAction char(1)
AS

INSERT INTO TDataProtectionActAudit 
(ConcurrencyId, CRMContactId, IsAwareOfRights, HasGivenConsent, IsAwareOfAccess,
	DataProtectionActId, StampAction, StampDateTime, StampUser)
SELECT  ConcurrencyId, CRMContactId, IsAwareOfRights, HasGivenConsent, IsAwareOfAccess,
	DataProtectionActId, @StampAction, GetDate(), @StampUser
FROM TDataProtectionAct
WHERE DataProtectionActId = @DataProtectionActId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
