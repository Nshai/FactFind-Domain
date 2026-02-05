SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditBenefit]
	@StampUser varchar (255),
	@BenefitId bigint,
	@StampAction char(1)
AS

INSERT INTO TBenefitAudit 
( RefBenefitTypeId, EmployeeId, ConcurrencyId, 
	BenefitId, StampAction, StampDateTime, StampUser) 
Select RefBenefitTypeId, EmployeeId, ConcurrencyId, 
	BenefitId, @StampAction, GetDate(), @StampUser
FROM TBenefit
WHERE BenefitId = @BenefitId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
