SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateFinancialPlanningSelectedFundsRevisedReturnId]
	@StampUser varchar (255),
	@FinancialPlanningSelectedFundsId bigint, 
	@PolicyBusinessFundId bigint, 
	@RevisedValue decimal (18,2)  = NULL, 
	@RevisedPercentage decimal (18,2)  = NULL, 
	@IsLocked bit = 0	,
	@IsExecuted bit = 0	
AS


DECLARE @FinancialPlanningSelectedFundsRevisedId bigint, @Result int
			
	
INSERT INTO TFinancialPlanningSelectedFundsRevised
(FinancialPlanningSelectedFundsId, PolicyBusinessFundId, RevisedValue, RevisedPercentage, IsLocked,IsExecuted, ConcurrencyId)
VALUES(@FinancialPlanningSelectedFundsId, @PolicyBusinessFundId, @RevisedValue, @RevisedPercentage, @IsLocked,@IsExecuted, 1)

SELECT @FinancialPlanningSelectedFundsRevisedId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditFinancialPlanningSelectedFundsRevised @StampUser, @FinancialPlanningSelectedFundsRevisedId, 'C'

IF @Result  != 0 GOTO errh


SELECT @FinancialPlanningSelectedFundsRevisedId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
