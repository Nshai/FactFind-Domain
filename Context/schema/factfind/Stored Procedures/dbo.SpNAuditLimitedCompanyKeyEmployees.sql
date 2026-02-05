SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditLimitedCompanyKeyEmployees]
	@StampUser varchar (255),
	@LimitedCompanyKeyEmployeesId bigint,
	@StampAction char(1)
AS

INSERT INTO TLimitedCompanyKeyEmployeesAudit 
( CRMContactId, Name, RolesDuties, DOB, 
		Smoker, GoodHealth, ConcurrencyId, 
	LimitedCompanyKeyEmployeesId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Name, RolesDuties, DOB, 
		Smoker, GoodHealth, ConcurrencyId, 
	LimitedCompanyKeyEmployeesId, @StampAction, GetDate(), @StampUser
FROM TLimitedCompanyKeyEmployees
WHERE LimitedCompanyKeyEmployeesId = @LimitedCompanyKeyEmployeesId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
