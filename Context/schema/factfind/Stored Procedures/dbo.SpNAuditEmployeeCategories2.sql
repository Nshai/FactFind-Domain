SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEmployeeCategories2]
	@StampUser varchar (255),
	@EmployeeCategories2Id bigint,
	@StampAction char(1)
AS

INSERT INTO TEmployeeCategories2Audit 
( CRMContactId, ComputerisedPayroll, TotalSalaryRoll, StaffingLevelsIncreasing, 
		Reviewdate, EmployeesAffiliatedToTradeUnion, TradeUnionAgreementNeeded, ConcurrencyId, 
		
	EmployeeCategories2Id, StampAction, StampDateTime, StampUser) 
Select CRMContactId, ComputerisedPayroll, TotalSalaryRoll, StaffingLevelsIncreasing, 
		Reviewdate, EmployeesAffiliatedToTradeUnion, TradeUnionAgreementNeeded, ConcurrencyId, 
		
	EmployeeCategories2Id, @StampAction, GetDate(), @StampUser
FROM TEmployeeCategories2
WHERE EmployeeCategories2Id = @EmployeeCategories2Id

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
