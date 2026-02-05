SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCertificate]
	@StampUser varchar (255),
	@CertificateId bigint,
	@StampAction char(1)
AS

INSERT INTO TCertificateAudit 
( UserId, CRMContactId, Issuer, Subject, 
		ValidFrom, ValidUntil, SerialNumber, IsRevoked, 
		HasExpired, LastCheckedOn, CreatedDate, ConcurrencyId, 
		
	CertificateId, StampAction, StampDateTime, StampUser) 
Select UserId, CRMContactId, Issuer, Subject, 
		ValidFrom, ValidUntil, SerialNumber, IsRevoked, 
		HasExpired, LastCheckedOn, CreatedDate, ConcurrencyId, 
		
	CertificateId, @StampAction, GetDate(), @StampUser
FROM TCertificate
WHERE CertificateId = @CertificateId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
