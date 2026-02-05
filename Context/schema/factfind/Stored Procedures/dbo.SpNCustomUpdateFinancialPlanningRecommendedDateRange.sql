SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomUpdateFinancialPlanningRecommendedDateRange] 
		@FinancialPlanningId bigint,
		@UpdateAll bit = 0,
		@StampUser varchar(255)
as

declare  @FinancialPlanningScenarioId bigint,
		 @StartDate datetime,
		 @TargetDate datetime

--get the dates
select   
	@StartDate = min(StartDate),  
	@TargetDate = max(TargetDate)
	from factfind..TObjective a  
	inner join factfind..TFinancialPlanningSelectedGoals b on a.ObjectiveId = b.ObjectiveId  
	where b.FinancialPlanningId = @FinancialPlanningId  

	if(@StartDate < getdate())
		select @StartDate = getdate()

--update the recommended
if(@UpdateAll =0) begin
	select	@FinancialPlanningScenarioId = FinancialPlanningScenarioId
											from TFinancialPlanningScenario			
											where FinancialPlanningId = @FinancialPlanningId and
												IsReadOnly = 1

	if(	@FinancialPlanningScenarioId is not null) begin

		exec spNAuditFinancialPlanningScenario @StampUser,@FinancialPlanningScenarioId,'U'


		update	TFinancialPlanningScenario
		set		StartDate = @StartDate,
				TargetDate = @TargetDate
		where   @FinancialPlanningScenarioId = FinancialPlanningScenarioId  
			
	end
end

--update everything based on the updateall flag
if(@UpdateAll = 1) begin
	
	update	TFinancialPlanningScenario
	set		StartDate = @StartDate,
			TargetDate = @TargetDate
	where   FinancialPlanningId = @FinancialPlanningId  

end
										

select isnull(@FinancialPlanningScenarioId,0)
GO
