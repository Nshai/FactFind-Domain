SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditDependants]
	@StampUser varchar (255),
	@DependantsId int,
	@StampAction char(1)
AS

INSERT INTO TDependantsAudit 
( CRMContactId, CRMContactId2, Name, DOB, 
		Age, AgeCustom, AgeCustomUntil, Relationship, DependantOf, FinDep, 
		AgeOfInd, ConcurrencyId, 
	DependantsId, StampAction, StampDateTime, StampUser, DependantDurationId, LivingWithClientId,FinancialDependencyEndingOn, Notes) 
Select CRMContactId, CRMContactId2, Name, DOB, 
		Age, AgeCustom, AgeCustomUntil, Relationship, DependantOf, FinDep, 
		AgeOfInd, ConcurrencyId, 
	DependantsId, @StampAction, GetDate(), @StampUser, DependantDurationId, LivingWithClientId,FinancialDependencyEndingOn, Notes
FROM TDependants
WHERE DependantsId = @DependantsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
