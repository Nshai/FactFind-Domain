SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEmployeeCategories]
	@StampUser varchar (255),
	@EmployeeCategoriesId bigint,
	@StampAction char(1)
AS

INSERT INTO TEmployeeCategoriesAudit 
( CRMContactId, Category, Number, DetailsOfDuties, 
		NormalRetirement, WorkingHours, RegularOvertime, AverageWeeklyEarnings, 
		ConcurrencyId, 
	EmployeeCategoriesId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Category, Number, DetailsOfDuties, 
		NormalRetirement, WorkingHours, RegularOvertime, AverageWeeklyEarnings, 
		ConcurrencyId, 
	EmployeeCategoriesId, @StampAction, GetDate(), @StampUser
FROM TEmployeeCategories
WHERE EmployeeCategoriesId = @EmployeeCategoriesId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
