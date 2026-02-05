SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEmployeeInformation]
	@StampUser varchar (255),
	@EmployeeInformationId bigint,
	@StampAction char(1)
AS

INSERT INTO TEmployeeInformationAudit 
( CRMContactId, NumOfFTEmp, NumOfPTEmp, NumOfEmpBelow20, 
		NumOfEmp20_29, NumOfEmp30_39, NumOfEmp40_49, NumOfEmp50_59, 
		NumOfEmp60_over, ConcurrencyId, 
	EmployeeInformationId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, NumOfFTEmp, NumOfPTEmp, NumOfEmpBelow20, 
		NumOfEmp20_29, NumOfEmp30_39, NumOfEmp40_49, NumOfEmp50_59, 
		NumOfEmp60_over, ConcurrencyId, 
	EmployeeInformationId, @StampAction, GetDate(), @StampUser
FROM TEmployeeInformation
WHERE EmployeeInformationId = @EmployeeInformationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
