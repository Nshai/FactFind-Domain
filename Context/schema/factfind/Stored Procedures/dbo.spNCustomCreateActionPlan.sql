SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE procedure [dbo].[spNCustomCreateActionPlan]  
  
@FinancialPlanningId bigint,  
@ScenarioId bigint,  
@Owner1 bigint,  
@Owner2 bigint = null,  
@RefPlan2ProdSubTypeId bigint,  
@PercentageAllocation decimal(18,9),  
@PolicyBusinessId bigint = null,  
@StampUser varchar(50),  
@Contribution decimal(18,2)  ,
@Withdrawal decimal(18,2)  
  
as  
  
declare @ActionPlanId bigint , @RefPlanTypeId bigint

select @RefPlanTypeId = RefPlanTypeId 
						from policymanagement..TRefPlanType2ProdSubType 
						where RefPlanType2ProdSubTypeId = @RefPlan2ProdSubTypeId     
  
insert into TActionPlan  
(FinancialPlanningId,  
ScenarioId,  
Owner1,  
Owner2,  
RefPlan2ProdSubTypeId,  
PercentageAllocation,  
PolicyBusinessId,  
Contribution,
Withdrawal,
IsExecuted,
RefPlanTypeId)  
select   
@FinancialPlanningId,  
@ScenarioId,  
@Owner1,  
@Owner2,  
@RefPlan2ProdSubTypeId,  
@PercentageAllocation,  
@PolicyBusinessId,  
@Contribution  ,
@Withdrawal,
0,
isnull(@RefPlanTypeId,0)
  
select @ActionPlanId = SCOPE_IDENTITY()  
  
exec spNAuditActionPlan @StampUser,@ActionPlanId,'C'  
  
select @ActionPlanId
GO
