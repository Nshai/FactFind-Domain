SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomCreateSelectedFundsForInvestment]   
    @StampUser varchar (255),  
    @policyBusinessId bigint,  
    @financialPlanningId bigint  
  

as  


insert into TFinancialPlanningSelectedFunds  
(  
FinancialPlanningSelectedInvestmentsId,  
PolicyBusinessFundId,  
IsAsset,  
ConcurrencyId  
)  
select  FinancialPlanningSelectedInvestmentsId,  
  PolicyBusinessFundId,    
  0,  
  1   
from policymanagement..tpolicybusinessfund a  
inner join TFinancialPlanningSelectedInvestments b on b.InvestmentId = a.policybusinessid  
where b.investmenttype <> 'asset' and  
  b.InvestmentId = @policyBusinessId and  
  b.financialplanningid = @financialPlanningId  
union all 
  
select  FinancialPlanningSelectedInvestmentsId,  
  a.AssetsId,    
  1,  
  1   
from FactFind.dbo.tAssets a    
inner join TFinancialPlanningSelectedInvestments b on b.InvestmentId = a.policybusinessid  
where b.InvestmentId = @policyBusinessId and  
  b.financialplanningid = @financialPlanningId  

  
IF (@@ROWCOUNT > 0) begin  
  
insert into TFinancialPlanningSelectedFundsAudit  
(FinancialPlanningSelectedInvestmentsId,  
PolicyBusinessFundId,  
IsAsset,  
ConcurrencyId,  
FinancialPlanningSelectedFundsId,  
StampAction,  
StampDateTime,  
StampUser)  
select   
a.FinancialPlanningSelectedInvestmentsId,  
a.PolicyBusinessFundId,  
a.IsAsset,  
a.ConcurrencyId,  
a.FinancialPlanningSelectedFundsId,  
'C',  
getdate(),  
@StampUser  
from TFinancialPlanningSelectedFunds a  
inner join TFinancialPlanningSelectedInvestments b on b.FinancialPlanningSelectedInvestmentsId = a.FinancialPlanningSelectedInvestmentsId  
  where b.InvestmentId = @policyBusinessId and  
  b.financialplanningid = @financialPlanningId  
end  
  
select a.*   
from TFinancialPlanningSelectedFunds a  
inner join TFinancialPlanningSelectedInvestments b on b.FinancialPlanningSelectedInvestmentsId = a.FinancialPlanningSelectedInvestmentsId  
where b.InvestmentId = @policyBusinessId and b.FinancialPlanningId = @financialPlanningId  
  
GO
