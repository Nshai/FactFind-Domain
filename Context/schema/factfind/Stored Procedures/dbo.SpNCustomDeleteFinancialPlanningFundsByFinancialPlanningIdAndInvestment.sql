SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteFinancialPlanningFundsByFinancialPlanningIdAndInvestment]
	@FinancialPlanningId Bigint,
	@InvestmentId Bigint,
	@InvestmentType varchar (50),
	@StampUser varchar (255)
	
AS


insert into TFinancialPlanningSelectedFundsAudit
(FinancialPlanningSelectedInvestmentsId,
PolicyBusinessFundId,
IsAsset,
ConcurrencyId,
FinancialPlanningSelectedFundsId,
StampAction,
StampDateTime,
StampUser)
select 
T1.FinancialPlanningSelectedInvestmentsId,
PolicyBusinessFundId,
IsAsset,
T1.ConcurrencyId,
FinancialPlanningSelectedFundsId,
'D',
getdate(),
@StampUser
FROM TFinancialPlanningSelectedFunds T1
Inner join TFinancialPlanningSelectedInvestments T2 on T1.FinancialPlanningSelectedInvestmentsId = T2.FinancialPlanningSelectedInvestmentsId
WHERE	T2.FinancialPlanningId = @FinancialPlanningId and
		T2.InvestmentId = @InvestmentId and
		T2.InvestmentType = @InvestmentType

DELETE T1 
FROM TFinancialPlanningSelectedFunds T1
Inner join TFinancialPlanningSelectedInvestments T2 on T1.FinancialPlanningSelectedInvestmentsId = T2.FinancialPlanningSelectedInvestmentsId
WHERE	T2.FinancialPlanningId = @FinancialPlanningId and
		T2.InvestmentId = @InvestmentId and
		T2.InvestmentType = @InvestmentType

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:

RETURN (100)
GO
