SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditKeyEmployeesToBeProtected]
	@StampUser varchar (255),
	@KeyEmployeesToBeProtectedId bigint,
	@StampAction char(1)
AS

INSERT INTO TKeyEmployeesToBeProtectedAudit 
( CRMContactId, ShareHolderName, ShareHolderRole, DOB, 
		SmokerYesNo, SuccessorYesNo, DateJoinedCompany, CurrentValue, 
		PercentageInterest, CurrentYear, LastYear, TwoYearsAgo, 
		ConcurrencyId, 
	KeyEmployeesToBeProtectedId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, ShareHolderName, ShareHolderRole, DOB, 
		SmokerYesNo, SuccessorYesNo, DateJoinedCompany, CurrentValue, 
		PercentageInterest, CurrentYear, LastYear, TwoYearsAgo, 
		ConcurrencyId, 
	KeyEmployeesToBeProtectedId, @StampAction, GetDate(), @StampUser
FROM TKeyEmployeesToBeProtected
WHERE KeyEmployeesToBeProtectedId = @KeyEmployeesToBeProtectedId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
