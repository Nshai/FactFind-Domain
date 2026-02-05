SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEmployeeBenefit]
	@StampUser varchar (255),
	@EmployeeBenefitId bigint,
	@StampAction char(1)
AS

INSERT INTO TEmployeeBenefitAudit 
( CRMContactId, Benefit, Insurer, NumberOfEmployees, 
		AnnualPremium, LevelOfBenefits, ConcurrencyId, 
	EmployeeBenefitId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Benefit, Insurer, NumberOfEmployees, 
		AnnualPremium, LevelOfBenefits, ConcurrencyId, 
	EmployeeBenefitId, @StampAction, GetDate(), @StampUser
FROM TEmployeeBenefit
WHERE EmployeeBenefitId = @EmployeeBenefitId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
