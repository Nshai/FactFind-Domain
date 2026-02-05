SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteFinancialPlanningInvestmentByFinancialPlanningIdAndInvestment]
	@FinancialPlanningId Bigint,
	@InvestmentId Bigint,
	@InvestmentType varchar (50),
	@StampUser varchar (255)
	
AS

insert into	TFinancialPlanningSelectedInvestmentsAudit(
FinancialPlanningId,
InvestmentId,
InvestmentType,
ConcurrencyId,
FinancialPlanningSelectedInvestmentsId,
StampAction,
StampDateTime,
StampUser
)
select 
FinancialPlanningId,
InvestmentId,
InvestmentType,
ConcurrencyId,
FinancialPlanningSelectedInvestmentsId,
'D',
getdate(),
@StampUser
FROM TFinancialPlanningSelectedInvestments T1
WHERE	T1.FinancialPlanningId = @FinancialPlanningId and
		T1.InvestmentId = @InvestmentId and
		T1.InvestmentType = @InvestmentType

DELETE T1 FROM TFinancialPlanningSelectedInvestments T1
WHERE	T1.FinancialPlanningId = @FinancialPlanningId and
		T1.InvestmentId = @InvestmentId and
		T1.InvestmentType = @InvestmentType

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:

RETURN (100)
GO
