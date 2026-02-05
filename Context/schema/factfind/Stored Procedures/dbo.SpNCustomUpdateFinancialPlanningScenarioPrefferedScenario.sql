SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create  PROCEDURE [dbo].[SpNCustomUpdateFinancialPlanningScenarioPrefferedScenario]
	@FinancialPlanningScenarioId Bigint,	
	@StampUser varchar (255),
	@FinancialPlanningId bigint
AS

Declare @Result int,
		@CurrentPreferredFinancialPlanningScenarioId int

--get the currently selected scenario
select @CurrentPreferredFinancialPlanningScenarioId = FinancialPlanningScenarioId 
														from	TFinancialPlanningScenario
														where FinancialPlanningId = @FinancialPlanningId and
															PrefferedScenario = 1
if(@CurrentPreferredFinancialPlanningScenarioId > 0) begin

	Execute @Result = dbo.SpNAuditFinancialPlanningScenario @StampUser, @CurrentPreferredFinancialPlanningScenarioId, 'U'

	IF @Result  != 0 GOTO errh

	UPDATE T1
	SET T1.PrefferedScenario = 0,
		T1.ConcurrencyId = T1.ConcurrencyId + 1
	FROM TFinancialPlanningScenario T1
	WHERE  T1.FinancialPlanningScenarioId = @CurrentPreferredFinancialPlanningScenarioId
end

Execute @Result = dbo.SpNAuditFinancialPlanningScenario @StampUser, @FinancialPlanningScenarioId, 'U'

IF @Result  != 0 GOTO errh

UPDATE T1
SET T1.PrefferedScenario = 1,
	T1.ConcurrencyId = T1.ConcurrencyId + 1
FROM TFinancialPlanningScenario T1
WHERE  T1.FinancialPlanningScenarioId = @FinancialPlanningScenarioId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
