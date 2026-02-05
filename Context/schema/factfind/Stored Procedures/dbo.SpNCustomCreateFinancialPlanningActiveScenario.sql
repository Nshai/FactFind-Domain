SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomCreateFinancialPlanningActiveScenario]

@FinancialPlanningId bigint,
@FinancialPlanningScenarioId bigint,
@StampUser varchar(255)

as

declare @identity bigint,
		@action varchar(1)

--don't do nothing if the scenario no longer exists
if(select 1 from TFinancialPlanningScenario 
		where financialplanningscenarioid = @FinancialPlanningScenarioId) > 0 begin

	--if exists then update
	if (select 1 from TFinancialPlanningActiveScenario 
			where FinancialPlanningId = @FinancialPlanningId) >0 begin
									
		update	TFinancialPlanningActiveScenario
		set		FinancialPlanningScenarioId = @FinancialPlanningScenarioId,
				ConcurrencyId = ConcurrencyId +1
		where	FinancialPlanningId = @FinancialPlanningId
			
		select @identity = FinancialPlanningActiveScenarioId from TFinancialPlanningActiveScenario 
								where FinancialPlanningId = @FinancialPlanningId	
		select @action = 'U'
					
	end else begin
		
		insert into TFinancialPlanningActiveScenario
		(FinancialPlanningId,
		FinancialPlanningScenarioId,
		ConcurrencyId)
		select @FinancialPlanningId,@FinancialPlanningScenarioId,1
		
		select @identity = SCOPE_IDENTITY()
		select @action = 'C'

	end

	exec SpNAuditFinancialPlanningActiveScenario @StampUser,@identity,@action

end

GO
