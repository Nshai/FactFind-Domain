SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateFinancialPlanning]
	@StampUser varchar (255),
	@FactFindId bigint, 
	@AdjustValue bit = 1, 
	@RefPlanningTypeId int, 
	@RefInvestmentTypeId int = 1, 
	@IncludeAssets bit = 0,		
	@GoalType int,
	@RefLumpsumAtRetirementType int
AS


DECLARE @FinancialPlanningId bigint, @Result int
			
	
INSERT INTO TFinancialPlanning
(FactFindId, AdjustValue, RefPlanningTypeId, RefInvestmentTypeId, IncludeAssets,  ConcurrencyId ,GoalType, RefLumpsumAtRetirementTypeId)
VALUES(@FactFindId, @AdjustValue, @RefPlanningTypeId, @RefInvestmentTypeId, @IncludeAssets,  1,@GoalType, @RefLumpsumAtRetirementType)

SELECT @FinancialPlanningId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditFinancialPlanning @StampUser, @FinancialPlanningId, 'C'

 -- Call up the Sync SP to Sync FP data with AdvisaCenta table.
Exec SpNCustomSyncFPGoals @FinancialPlanningId, @StampUser


IF @Result  != 0 GOTO errh

Execute dbo.SpNCustomRetrieveFinancialPlanningByFinancialPlanningId @FinancialPlanningId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
