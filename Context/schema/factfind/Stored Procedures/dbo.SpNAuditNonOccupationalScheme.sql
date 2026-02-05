SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditNonOccupationalScheme]
	@StampUser varchar (255),
	@NonOccupationalSchemeId bigint,
	@StampAction char(1)
AS

INSERT INTO TNonOccupationalSchemeAudit 
( CRMContactId, TypeOfContract, NameOfCompany, StartDate, 
		ReviewDate, PolicyHolder, EmployeePremium, EmployerPremium, 
		DeathSumAssured, InTrust, NameOfBeneficiary, PlanContractedOutOfS2P, 
		NameOfProductProvider, ConcurrencyId, 
	NonOccupationalSchemeId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, TypeOfContract, NameOfCompany, StartDate, 
		ReviewDate, PolicyHolder, EmployeePremium, EmployerPremium, 
		DeathSumAssured, InTrust, NameOfBeneficiary, PlanContractedOutOfS2P, 
		NameOfProductProvider, ConcurrencyId, 
	NonOccupationalSchemeId, @StampAction, GetDate(), @StampUser
FROM TNonOccupationalScheme
WHERE NonOccupationalSchemeId = @NonOccupationalSchemeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
