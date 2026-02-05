SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditLogon]
	@StampUser varchar (255),
	@LogonId bigint,
	@StampAction char(1)
AS

INSERT INTO TLogonAudit 
( UserId, LogonDateTime, LogoffDateTime, Type, 
		SourceAddress, ConcurrencyId, CertificateSerialNumber, 
	LogonId, StampAction, StampDateTime, StampUser, ExternalApplication) 
Select UserId, LogonDateTime, LogoffDateTime, Type, 
		SourceAddress, ConcurrencyId, CertificateSerialNumber, 
	LogonId, @StampAction, GetDate(), @StampUser, ExternalApplication
FROM TLogon
WHERE LogonId = @LogonId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
