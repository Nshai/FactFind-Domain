SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditQuotePension]
	@StampUser varchar (255),
	@QuotePensionId bigint,
	@StampAction char(1)
AS

INSERT INTO TQuotePensionAudit 
( QuoteItemId, Contribution, EmployerContribution, RetirementAge, 
		TotalFundValue, Pension, CashSum, ReducedPension, 
		MediumGrowthRate, ConcurrencyId, 
	QuotePensionId, StampAction, StampDateTime, StampUser) 
Select QuoteItemId, Contribution, EmployerContribution, RetirementAge, 
		TotalFundValue, Pension, CashSum, ReducedPension, 
		MediumGrowthRate, ConcurrencyId, 
	QuotePensionId, @StampAction, GetDate(), @StampUser
FROM TQuotePension
WHERE QuotePensionId = @QuotePensionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
