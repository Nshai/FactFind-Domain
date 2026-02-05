SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditLimitedCompany]
	@StampUser varchar (255),
	@LimitedCompanyId bigint,
	@StampAction char(1)
AS

INSERT INTO TLimitedCompanyAudit 
( CRMContactId, OtherEmployeesToBeProtected, ConcurrencyId, 
	LimitedCompanyId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, OtherEmployeesToBeProtected, ConcurrencyId, 
	LimitedCompanyId, @StampAction, GetDate(), @StampUser
FROM TLimitedCompany
WHERE LimitedCompanyId = @LimitedCompanyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
