SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCustomCreateFundProposalsForPlan]
@ActionPlanId bigint, @Stampuser varchar(99)    
    
as    
    
declare @PolicyBusinessId bigint    
    
select @PolicyBusinessId = MasterPolicyBusinessId from TActionPlandn where actionplanid = @ActionPlanId    
    
--Fund Proposals    
insert into policymanagement..TFundProposalAudit    
(PolicyBusinessId,FundUnitId,IsFromSeed,Percentage,TenantId,ConcurrencyId,FundProposalId,StampAction,StampDateTime,StampUser)    
select PolicyBusinessId,FundUnitId,IsFromSeed,Percentage,TenantId,ConcurrencyId,FundProposalId,'D',getdate(),@stampuser    
from policymanagement..TFundProposal where policybusinessid = @PolicyBusinessId    
    
delete from policymanagement..TFundProposal where policybusinessid = @PolicyBusinessId    
    
insert into policymanagement..TFundProposal    
(PolicyBusinessId,FundUnitId,IsFromSeed,Percentage,TenantId,ConcurrencyId)    
    
select masterpolicybusinessid, isnull(Fundunitid,d.fundid),isnull(fromfeedfg,1), PercentageAllocation,indclientid,1    
from TActionPlandn a    
inner join TActionFund b on b.actionplanid = a.actionplanid    
inner join crm..TCRMContact c on c.crmcontactid = a.owner1    
left join policymanagement..TPolicyBusinessFund d on d.policybusinessfundid = b.policybusinessFundId    
where a.actionplanid = @ActionPlanId and percentageallocation > 0    
    
GO
