SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateFinancialPlanningSelectedFunds]
	@StampUser varchar (255),
	@FinancialPlanningSelectedInvestmentsId bigint, 
	@PolicyBusinessFundId bigint, 	
	@IsAsset bit = 0	
AS


DECLARE @FinancialPlanningSelectedFundsId bigint, @Result int
			
	
INSERT INTO TFinancialPlanningSelectedFunds
(FinancialPlanningSelectedInvestmentsId, PolicyBusinessFundId,  IsAsset, ConcurrencyId)
VALUES(@FinancialPlanningSelectedInvestmentsId, @PolicyBusinessFundId, @IsAsset, 1)

SELECT @FinancialPlanningSelectedFundsId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditFinancialPlanningSelectedFunds @StampUser, @FinancialPlanningSelectedFundsId, 'C'

IF @Result  != 0 GOTO errh

Execute dbo.SpNRetrieveFinancialPlanningSelectedFundsByFinancialPlanningSelectedFundsId @FinancialPlanningSelectedFundsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
