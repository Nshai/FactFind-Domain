SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditMonthlyBenefit]
	@StampUser varchar (255),
	@MonthlyBenefitId bigint,
	@StampAction char(1)
AS

INSERT INTO TMonthlyBenefitAudit 
( Amount, DeferredPeriod, TenantId, ConcurrencyId, 
		
	MonthlyBenefitId, StampAction, StampDateTime, StampUser) 
Select Amount, DeferredPeriod, TenantId, ConcurrencyId, 
		
	MonthlyBenefitId, @StampAction, GetDate(), @StampUser
FROM TMonthlyBenefit
WHERE MonthlyBenefitId = @MonthlyBenefitId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
