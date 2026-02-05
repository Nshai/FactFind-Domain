SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomCreateActionPlanDN]

@ActionPlanId bigint,
@SingleLumpSum money,
@MonthlyContribution money,
@AnnualWithdrawal money,
@Owner1	bigint,
@Owner2	bigint,
@RefPlan2ProdSubTypeId	bigint,
@MasterPolicyBusinessId	bigint,
@IsSwitch bit,
@StartDate datetime,
@TargetDate datetime,
@HasWithdrawalPercentage bit

as

delete from TActionPlanDN where actionplanid = @actionplanid

insert into TActionPlanDN
(ActionPlanId,
SingleLumpSum,
MonthlyContribution,
AnnualWithdrawal,
Owner1,
Owner2,
RefPlan2ProdSubTypeId,
MasterPolicyBusinessId,
IsSwitch,
StartDate,
TargetDate,
HasWithdrawalPercentage)
select
@ActionPlanId,
@SingleLumpSum,
@MonthlyContribution,
@AnnualWithdrawal,
@Owner1,
@Owner2,
@RefPlan2ProdSubTypeId,
@MasterPolicyBusinessId,
@IsSwitch,
@StartDate,
@TargetDate,
@HasWithdrawalPercentage
GO
