SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEmployeeBenefitCont]
	@StampUser varchar (255),
	@EmployeeBenefitContId bigint,
	@StampAction char(1)
AS

INSERT INTO TEmployeeBenefitContAudit 
( CRMContactId, ConcernsYesNo, Concerns, Notes, 
		ConcurrencyId, 
	EmployeeBenefitContId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, ConcernsYesNo, Concerns, Notes, 
		ConcurrencyId, 
	EmployeeBenefitContId, @StampAction, GetDate(), @StampUser
FROM TEmployeeBenefitCont
WHERE EmployeeBenefitContId = @EmployeeBenefitContId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
