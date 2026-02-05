SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteFinancialPlanningFundBySelectedInvesmentIdAndFund]
	@FinancialPlanningSelectedInvestmentId Bigint,
	@PolicyBusinessFundId Bigint,
	@IsAsset int,
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
WHERE	T1.FinancialPlanningSelectedInvestmentsId = @FinancialPlanningSelectedInvestmentId and
		T1.PolicyBusinessFundId = @PolicyBusinessFundId and
		T1.IsAsset = @IsAsset

DELETE T1 
FROM TFinancialPlanningSelectedFunds T1
WHERE	T1.FinancialPlanningSelectedInvestmentsId = @FinancialPlanningSelectedInvestmentId and
		T1.PolicyBusinessFundId = @PolicyBusinessFundId and
		T1.IsAsset = @IsAsset


IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:

RETURN (100)
GO
