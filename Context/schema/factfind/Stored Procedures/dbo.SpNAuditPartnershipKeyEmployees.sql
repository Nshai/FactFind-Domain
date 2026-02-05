SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPartnershipKeyEmployees]
	@StampUser varchar (255),
	@PartnershipKeyEmployeesId bigint,
	@StampAction char(1)
AS

INSERT INTO TPartnershipKeyEmployeesAudit 
( CRMContactId, Name, RolesDuties, DOB, 
		Smoker, GoodHealth, ConcurrencyId, 
	PartnershipKeyEmployeesId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Name, RolesDuties, DOB, 
		Smoker, GoodHealth, ConcurrencyId, 
	PartnershipKeyEmployeesId, @StampAction, GetDate(), @StampUser
FROM TPartnershipKeyEmployees
WHERE PartnershipKeyEmployeesId = @PartnershipKeyEmployeesId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
