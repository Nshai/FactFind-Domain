SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNUpdateFinancialPlanningSelectedFundsRevised]
	@FinancialPlanningSelectedFundsRevisedId Bigint,	
	@StampUser varchar (255),
	@FinancialPlanningSelectedFundsId bigint, 
	@PolicyBusinessFundId bigint, 
	@RevisedValue decimal (18,2)  = NULL, 
	@RevisedPercentage decimal (18,2)  = NULL, 
	@IsLocked bit = NULL,
	@IsExecuted bit = NULL

AS


Declare @Result int
Execute @Result = dbo.SpNAuditFinancialPlanningSelectedFundsRevised @StampUser, @FinancialPlanningSelectedFundsRevisedId, 'U'

IF @Result  != 0 GOTO errh


UPDATE T1
SET T1.FinancialPlanningSelectedFundsId = @FinancialPlanningSelectedFundsId, T1.PolicyBusinessFundId = @PolicyBusinessFundId, T1.RevisedValue = @RevisedValue, 
	T1.RevisedPercentage = @RevisedPercentage, T1.IsLocked = @IsLocked,
	T1.IsExecuted = @IsExecuted,
 T1.ConcurrencyId = T1.ConcurrencyId + 1
FROM TFinancialPlanningSelectedFundsRevised T1
WHERE  T1.FinancialPlanningSelectedFundsRevisedId = @FinancialPlanningSelectedFundsRevisedId --And T1.ConcurrencyId = @ConcurrencyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
