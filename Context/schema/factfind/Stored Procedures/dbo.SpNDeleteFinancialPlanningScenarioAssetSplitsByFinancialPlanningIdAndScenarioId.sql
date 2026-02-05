SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNDeleteFinancialPlanningScenarioAssetSplitsByFinancialPlanningIdAndScenarioId]
	@FinancialPlanningId Bigint,
	@ScenarioId Bigint,
	@StampUser varchar (255)
	
AS


Declare @Result int,@FinancialPlanningScenarioAssetSplitsId bigint

select @FinancialPlanningScenarioAssetSplitsId = FinancialPlanningScenarioAssetSplitsId
													from TFinancialPlanningScenarioAssetSplits
													where @FinancialPlanningId = FinancialPlanningId and
															@ScenarioId = ScenarioId

Execute @Result = dbo.SpNAuditFinancialPlanningScenarioAssetSplits @StampUser, @FinancialPlanningScenarioAssetSplitsId, 'D'

IF @Result  != 0 GOTO errh

DELETE T1 FROM TFinancialPlanningScenarioAssetSplits T1
where @FinancialPlanningId = FinancialPlanningId and @ScenarioId = ScenarioId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:

RETURN (100)
GO
