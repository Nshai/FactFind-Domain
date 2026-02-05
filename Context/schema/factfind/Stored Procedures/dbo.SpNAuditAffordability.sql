SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAffordability]
	@StampUser varchar (255),
	@AffordabilityId bigint,
	@StampAction char(1)
AS

INSERT INTO TAffordabilityAudit 
(CRMContactId, MonthlyIncome, MonthlyExpenditure, MonthlyDispIncome, MonthlyAfford, LumpSumAfford, 
	InvestmentFundSource, EmergencyFundRequired, PenaltyFreeFg, IncomeChangeFg, IncomeChangeNotes, AffordabilityNotes, 
	ConcurrencyId, IsIncomeChangeIncluded, IsExpenditureChangeIncluded, IsNonEssentialRemoved, IsLiabilityExpenditureConsolidated, IsProtectionRebroked,IsLiabilityExpenditureRepaid,
	MonthlyNotes, AgreedBudgetAmount, AmountSetAsideForShortTermNeeds, [AmountPutAsideForEmergencyFund], [EmergencyFundShortfall],
	AffordabilityId, StampAction, StampDateTime, StampUser)
SELECT  CRMContactId, MonthlyIncome, MonthlyExpenditure, MonthlyDispIncome, MonthlyAfford, LumpSumAfford, 
	InvestmentFundSource, EmergencyFundRequired, PenaltyFreeFg, IncomeChangeFg, IncomeChangeNotes, AffordabilityNotes, 
	ConcurrencyId, IsIncomeChangeIncluded, IsExpenditureChangeIncluded, IsNonEssentialRemoved, IsLiabilityExpenditureConsolidated, IsProtectionRebroked,IsLiabilityExpenditureRepaid, 	
	MonthlyNotes, AgreedBudgetAmount, AmountSetAsideForShortTermNeeds, [AmountPutAsideForEmergencyFund], [EmergencyFundShortfall],
	AffordabilityId, @StampAction, GetDate(), @StampUser
FROM TAffordability
WHERE AffordabilityId = @AffordabilityId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
