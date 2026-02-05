SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditDomain]
	@StampUser varchar (255),
	@DomainId bigint,
	@StampAction char(1)
AS

INSERT INTO TDomainAudit 
(DomainId, GroupId, Host,Application, StampAction, StampDateTime, StampUser) 
Select DomainId, GroupId, Host, Application, @StampAction, GetDate(), @StampUser
FROM TDomain
WHERE DomainId = @DomainId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO