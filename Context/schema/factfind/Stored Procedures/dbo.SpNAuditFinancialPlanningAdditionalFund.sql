SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFinancialPlanningAdditionalFund]
	@StampUser varchar (255),
	@FinancialPlanningAdditionalFundId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningAdditionalFundAudit 
( FundId, FinancialPlanningId, UnitQuantity, UnitPrice, 
		FundDetails, ConcurrencyId, 
	FinancialPlanningAdditionalFundId, StampAction, StampDateTime, StampUser) 
Select FundId, FinancialPlanningId, UnitQuantity, UnitPrice, 
		FundDetails, ConcurrencyId, 
	FinancialPlanningAdditionalFundId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningAdditionalFund
WHERE FinancialPlanningAdditionalFundId = @FinancialPlanningAdditionalFundId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
