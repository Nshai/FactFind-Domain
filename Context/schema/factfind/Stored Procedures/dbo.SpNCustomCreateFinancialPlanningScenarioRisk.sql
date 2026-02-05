SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateFinancialPlanningScenarioRisk]
	@StampUser varchar (255),	
	@FinancialPlanningId bigint,
	@ScenarioId int,
	@RiskDescription varchar(50),
	@RiskNumber int

AS

declare @FinancialPlanningScenarioRiskId bigint

select	@FinancialPlanningScenarioRiskId = FinancialPlanningScenarioRiskId
											from TFinancialPlanningScenarioRisk
											where @FinancialPlanningId = FinancialPlanningId and @ScenarioId = ScenarioId

if(@FinancialPlanningScenarioRiskId is null) begin

	insert into TFinancialPlanningScenarioRisk(
				FinancialPlanningId,
				ScenarioId,
				RiskDescription,
				RiskNumber,
				ConcurrencyId)
	select		@FinancialPlanningId,
				@ScenarioId,
				@RiskDescription,
				@RiskNumber,
				1

	select @FinancialPlanningScenarioRiskId = SCOPE_IDENTITY()

	exec SpNAuditFinancialPlanningScenarioRisk @StampUser,@FinancialPlanningScenarioRiskId,'C'	

end
else begin

	exec SpNAuditFinancialPlanningScenarioRisk @StampUser,@FinancialPlanningScenarioRiskId,'U'

	update	TFinancialPlanningScenarioRisk
	set		RiskDescription = @RiskDescription,
			RiskNumber = @RiskNumber
	where	@FinancialPlanningScenarioRiskId = FinancialPlanningScenarioRiskId

end



IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
