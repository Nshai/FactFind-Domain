SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomRetrievePodStylesByCRMContactId] 

@CRMContactId bigint

as

declare @RefFinancialPlanningPodTypeId bigint

select @RefFinancialPlanningPodTypeId = RefFinancialPlanningPodTypeId 
											from TFinancialPlanningPodTypeSelection
											where	CRMContactId = @CRMContactId

if(@RefFinancialPlanningPodTypeId is null) begin
	insert into TFinancialPlanningPodTypeSelection
	(CRMContactId,RefFinancialPlanningPodTypeId,ConcurrencyId)
	select @CRMContactId,1,1
end

select 
b.RefFinancialPlanningPodTypeId,
b.PodImageType,
b.Description,
case when a.RefFinancialPlanningPodTypeId is null then 0 else 1 end as selected
from TRefFinancialPlanningPodType b
left join TFinancialPlanningPodTypeSelection a on b.RefFinancialPlanningPodTypeId = a.RefFinancialPlanningPodTypeId
  and CRMContactId = @CRMContactId 

GO
