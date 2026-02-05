SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFinalSalaryPensionsPlanFFExt]
	@StampUser varchar (255),
	@FinalSalaryPensionsPlanFFExtId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinalSalaryPensionsPlanFFExtAudit 
( PolicyBusinessId, Employer, ConcurrencyId, 
	FinalSalaryPensionsPlanFFExtId, StampAction, StampDateTime, StampUser) 
Select PolicyBusinessId, Employer, ConcurrencyId, 
	FinalSalaryPensionsPlanFFExtId, @StampAction, GetDate(), @StampUser
FROM TFinalSalaryPensionsPlanFFExt
WHERE FinalSalaryPensionsPlanFFExtId = @FinalSalaryPensionsPlanFFExtId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
