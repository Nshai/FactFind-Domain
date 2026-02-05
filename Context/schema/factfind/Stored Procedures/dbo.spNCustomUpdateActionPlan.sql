SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomUpdateActionPlan]      
      
@ActionPlanId bigint,      
@Owner1 bigint,      
@Owner2 bigint,      
@RefPlan2ProdSubTypeId bigint,      
@PercentageAllocation decimal(18,9),
@Contribution decimal (18,2),    
@Withdrawal decimal (18,2),    
@StampUser varchar(50),
@PlanContributionAmount decimal(18,9),
@ActionPlanValueChange decimal(18,9),
@ActionPlanCurrentPercentage decimal(18,9)
      
as      
      
declare @RefPlanTypeId bigint

select @RefPlanTypeId = RefPlanTypeId 
						from policymanagement..TRefPlanType2ProdSubType 
						where RefPlanType2ProdSubTypeId = @RefPlan2ProdSubTypeId      
      
      
exec spNAuditActionPlan @StampUser,@ActionPlanId,'U'      
      
      
update TACtionPlan      
set  PercentageAllocation = @PercentageAllocation,      
  Owner1 = @Owner1,      
  Owner2 = @Owner2,      
  RefPlan2ProdSubTypeId = @RefPlan2ProdSubTypeId  ,    
  Contribution = @Contribution  ,  
  Withdrawal = @Withdrawal  ,
  RefPlanTypeId = isnull(@RefPlanTypeId,0),
  PlanContributionAmount = @PlanContributionAmount,
  RevisedValueDifferenceAmount = @ActionPlanValueChange,
  RevisedPercentage = @ActionPlanCurrentPercentage
  
where ActionPlanId = @ActionPlanId      
GO
