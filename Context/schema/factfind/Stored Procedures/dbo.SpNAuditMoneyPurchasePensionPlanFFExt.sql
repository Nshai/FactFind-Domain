SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditMoneyPurchasePensionPlanFFExt]
	@StampUser varchar (255),
	@MoneyPurchasePensionPlanFFExtId bigint,
	@StampAction char(1)
AS

INSERT INTO TMoneyPurchasePensionPlanFFExtAudit 
( PolicyBusinessId, Employer, LumpSumCommutation, ConcurrencyId, 
		
	MoneyPurchasePensionPlanFFExtId, StampAction, StampDateTime, StampUser) 
Select PolicyBusinessId, Employer, LumpSumCommutation, ConcurrencyId, 
		
	MoneyPurchasePensionPlanFFExtId, @StampAction, GetDate(), @StampUser
FROM TMoneyPurchasePensionPlanFFExt
WHERE MoneyPurchasePensionPlanFFExtId = @MoneyPurchasePensionPlanFFExtId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
