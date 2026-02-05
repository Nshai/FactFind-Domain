SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomRetrieveFinancialPlanningCurrentScenarioSummary]    
  
 @FinancialPlanningId bigint  
  
as  
  
select distinct   
0 as InitialLumpSum,  
  'n/a' as Rebalance,  
  'n/a' as TaxWrapper,    
  '' as StartDate,   
  '' as TargetDate,  
  0 as AnnualContributionsISA,  
  0 as AnnualWithdrawalsISA,    
  cast('n/a' as varchar(50)) as escalationtypeISA  ,
  CAST(0 as DECIMAL(16,2)) as AnnualContributions,  
  CAST(0 as DECIMAL(16,2)) as AnnualWithdrawals,  
cast('n/a' as varchar(50)) as escalationtype  
into #tempScenarioData  
from TFInancialPlanningSelectedGoals g  
inner join TObjective o on o.ObjectiveId = g.ObjectiveId  
where g.FinancialPlanningId = @FinancialPlanningId  
  
--update contributions  
update t  
set  t.annualContributions = (select isnull(cast(sum(CASE           
     when  rf.RefFrequencyId=1 then mi.amount * 52                
     when  rf.RefFrequencyId=2 then mi.amount * 26                
     when  rf.RefFrequencyId=3 then mi.amount*13        
     when  rf.RefFrequencyId=4 then mi.amount * 12   
     when  rf.RefFrequencyId=5 then mi.amount * 4             
     when  rf.RefFrequencyId=7 then mi.amount * 2     
     when  rf.RefFrequencyId=8 then mi.amount  
     else 0 END  
     ) as DECIMAL(16,2)),0)        
from  TFInancialPlanningSelectedInvestments fpi  
--contributions  
left join policymanagement..TPolicyMoneyIn mi on mi.policybusinessid = fpi.investmentId and fpi.InvestmentType != 'asset'  
left join policymanagement..TRefFrequency rf on rf.reffrequencyid = mi.reffrequencyid 
inner join policymanagement..TPolicyBusiness pb on pb.policybusinessid = fpi.investmentid
inner join policymanagement..TPolicyDetail pd on pd.policydetailid = pb.policydetailid
inner join policymanagement..TPlanDescription pdesc on pdesc.plandescriptionid = pd.plandescriptionid
inner join policymanagement..TRefPlanType2ProdSubType rpt on rpt.RefPlanType2ProdSubTypeId = pdesc.RefPlanType2ProdSubTypeId
inner join 	policymanagement..TRefPlanType r on r.refplantypeid = rpt.refplantypeid 
where fpi.FinancialPlanningId = @FinancialPlanningId and  
  --contribution clauses  
  (rf.reffrequencyid in (1,2,3,4,5,7,8) or rf.reffrequencyid is null) and  
  (mi.startdate < getdate() /*or mi.startdate is null*/) and  
  (mi.stopdate is null or mi.stopdate > getdate())  and
  planTypeName != 'ISA'   )
from #tempScenarioData t  
  
update t  
set  t.annualContributionsIsa = (select isnull(cast(sum(CASE           
     when  rf.RefFrequencyId=1 then mi.amount * 52                
     when  rf.RefFrequencyId=2 then mi.amount * 26                
     when  rf.RefFrequencyId=3 then mi.amount*13        
     when  rf.RefFrequencyId=4 then mi.amount * 12   
     when  rf.RefFrequencyId=5 then mi.amount * 4             
     when  rf.RefFrequencyId=7 then mi.amount * 2     
     when  rf.RefFrequencyId=8 then mi.amount  
     else 0 END  
     ) as DECIMAL(16,2)),0)        
from  TFInancialPlanningSelectedInvestments fpi  
--contributions  
left join policymanagement..TPolicyMoneyIn mi on mi.policybusinessid = fpi.investmentId and fpi.InvestmentType != 'asset'  
left join policymanagement..TRefFrequency rf on rf.reffrequencyid = mi.reffrequencyid 
inner join policymanagement..TPolicyBusiness pb on pb.policybusinessid = fpi.investmentid
inner join policymanagement..TPolicyDetail pd on pd.policydetailid = pb.policydetailid
inner join policymanagement..TPlanDescription pdesc on pdesc.plandescriptionid = pd.plandescriptionid
inner join policymanagement..TRefPlanType2ProdSubType rpt on rpt.RefPlanType2ProdSubTypeId = pdesc.RefPlanType2ProdSubTypeId
inner join 	policymanagement..TRefPlanType r on r.refplantypeid = rpt.refplantypeid 
where fpi.FinancialPlanningId = @FinancialPlanningId and  
  --contribution clauses  
  (rf.reffrequencyid in (1,2,3,4,5,7,8) or rf.reffrequencyid is null) and  
  (mi.startdate < getdate() /*or mi.startdate is null*/) and  
  (mi.stopdate is null or mi.stopdate > getdate())  and
  planTypeName = 'ISA'   )
from #tempScenarioData t  
  


--update withdrawal  
update t  
set  t.AnnualWithdrawals = (select isnull(cast(sum(CASE           
     when  rf2.RefFrequencyId=1 then mo.amount * 52                
     when  rf2.RefFrequencyId=2 then mo.amount * 26                
     when  rf2.RefFrequencyId=3 then mo.amount*13        
     when  rf2.RefFrequencyId=4 then mo.amount * 12   
     when  rf2.RefFrequencyId=5 then mo.amount * 4             
     when  rf2.RefFrequencyId=7 then mo.amount * 2     
     when  rf2.RefFrequencyId=8 then mo.amount  
     else 0 END  
     ) as DECIMAL(16,2)),0)  
from  TFInancialPlanningSelectedInvestments fpi  
left join policymanagement..TPolicyMoneyOut mo on mo.policybusinessid = fpi.investmentId and fpi.InvestmentType != 'asset'  
left join policymanagement..TRefFrequency rf2 on rf2.reffrequencyid = mo.reffrequencyid  
inner join policymanagement..TPolicyBusiness pb on pb.policybusinessid = fpi.investmentid
inner join policymanagement..TPolicyDetail pd on pd.policydetailid = pb.policydetailid
inner join policymanagement..TPlanDescription pdesc on pdesc.plandescriptionid = pd.plandescriptionid
inner join policymanagement..TRefPlanType2ProdSubType rpt on rpt.RefPlanType2ProdSubTypeId = pdesc.RefPlanType2ProdSubTypeId
inner join 	policymanagement..TRefPlanType r on r.refplantypeid = rpt.refplantypeid 
where fpi.FinancialPlanningId = @FinancialPlanningId and  
  --contribution clauses  
  (rf2.reffrequencyid in (1,2,3,4,5,7,8) or rf2.reffrequencyid is null)  
  and (mo.paymentstartdate  < getdate() /*or mo.paymentstartdate  is null*/)  
  and (mo.PaymentStopDate  is null or mo.PaymentStopDate > getdate()) 
  and PlanTypeName != 'ISA'
  )  
from #tempScenarioData t  
  
--update withdrawal  
update t  
set  t.AnnualWithdrawalsISA = (select isnull(cast(sum(CASE           
     when  rf2.RefFrequencyId=1 then mo.amount * 52                
     when  rf2.RefFrequencyId=2 then mo.amount * 26                
     when  rf2.RefFrequencyId=3 then mo.amount*13        
     when  rf2.RefFrequencyId=4 then mo.amount * 12   
     when  rf2.RefFrequencyId=5 then mo.amount * 4             
     when  rf2.RefFrequencyId=7 then mo.amount * 2     
     when  rf2.RefFrequencyId=8 then mo.amount  
     else 0 END  
     ) as DECIMAL(16,2)),0)  
from  TFInancialPlanningSelectedInvestments fpi  
left join policymanagement..TPolicyMoneyOut mo on mo.policybusinessid = fpi.investmentId and fpi.InvestmentType != 'asset'  
left join policymanagement..TRefFrequency rf2 on rf2.reffrequencyid = mo.reffrequencyid  
inner join policymanagement..TPolicyBusiness pb on pb.policybusinessid = fpi.investmentid
inner join policymanagement..TPolicyDetail pd on pd.policydetailid = pb.policydetailid
inner join policymanagement..TPlanDescription pdesc on pdesc.plandescriptionid = pd.plandescriptionid
inner join policymanagement..TRefPlanType2ProdSubType rpt on rpt.RefPlanType2ProdSubTypeId = pdesc.RefPlanType2ProdSubTypeId
inner join 	policymanagement..TRefPlanType r on r.refplantypeid = rpt.refplantypeid 
where fpi.FinancialPlanningId = @FinancialPlanningId and  
  --contribution clauses  
  (rf2.reffrequencyid in (1,2,3,4,5,7,8) or rf2.reffrequencyid is null)  
  and (mo.paymentstartdate  < getdate() /*or mo.paymentstartdate  is null*/)  
  and (mo.PaymentStopDate  is null or mo.PaymentStopDate > getdate()) 
  and PlanTypeName = 'ISA'
  )  
from #tempScenarioData t    
  
if(select count(*) from TFInancialPlanningSelectedInvestments fpi  
inner join policymanagement..TPolicyMoneyOut mo on mo.policybusinessid = fpi.investmentId and fpi.InvestmentType != 'asset'  
where fpi.FinancialPlanningId = @FinancialPlanningId and RefEscalationTypeId > 0) > 0  
begin  
  
 select distinct escalationtype   
 into #escalationtypes  
 from TFInancialPlanningSelectedInvestments fpi  
 inner join policymanagement..TPolicyMoneyOut mo on mo.policybusinessid = fpi.investmentId and fpi.InvestmentType != 'asset'  
 inner join policymanagement..TRefFrequency rf2 on rf2.reffrequencyid = mo.reffrequencyid  
 inner join policymanagement..TRefEscalationType re on re.RefEscalationTypeId = mo.RefEscalationTypeId  
 inner join policymanagement..TPolicyBusiness pb on pb.policybusinessid = fpi.investmentid
inner join policymanagement..TPolicyDetail pd on pd.policydetailid = pb.policydetailid
inner join policymanagement..TPlanDescription pdesc on pdesc.plandescriptionid = pd.plandescriptionid
inner join policymanagement..TRefPlanType2ProdSubType rpt on rpt.RefPlanType2ProdSubTypeId = pdesc.RefPlanType2ProdSubTypeId
inner join 	policymanagement..TRefPlanType r on r.refplantypeid = rpt.refplantypeid 
 where fpi.FinancialPlanningId = @FinancialPlanningId    
   and (rf2.reffrequencyid in (1,2,3,4,5,7,8) or rf2.reffrequencyid is null)  
   and (mo.paymentstartdate  < getdate() /*or mo.paymentstartdate  is null*/)  
   and (mo.PaymentStopDate  is null or mo.PaymentStopDate > getdate())   
   and PlanTypeName != 'ISA'
  
 if(select count(*) from #escalationtypes) = 1 begin  
  update #tempScenarioData  
  set  escalationtype = (select distinct escalationtype from #escalationtypes)  
 end  
 else begin  
  update #tempScenarioData  
  set  escalationtype = 'Various'  
 end  
  
  select distinct escalationtype   
 into #escalationtypesisa 
 from TFInancialPlanningSelectedInvestments fpi  
 inner join policymanagement..TPolicyMoneyOut mo on mo.policybusinessid = fpi.investmentId and fpi.InvestmentType != 'asset'  
 inner join policymanagement..TRefFrequency rf2 on rf2.reffrequencyid = mo.reffrequencyid  
 inner join policymanagement..TRefEscalationType re on re.RefEscalationTypeId = mo.RefEscalationTypeId  
 inner join policymanagement..TPolicyBusiness pb on pb.policybusinessid = fpi.investmentid
inner join policymanagement..TPolicyDetail pd on pd.policydetailid = pb.policydetailid
inner join policymanagement..TPlanDescription pdesc on pdesc.plandescriptionid = pd.plandescriptionid
inner join policymanagement..TRefPlanType2ProdSubType rpt on rpt.RefPlanType2ProdSubTypeId = pdesc.RefPlanType2ProdSubTypeId
inner join 	policymanagement..TRefPlanType r on r.refplantypeid = rpt.refplantypeid 
 where fpi.FinancialPlanningId = @FinancialPlanningId    
   and (rf2.reffrequencyid in (1,2,3,4,5,7,8) or rf2.reffrequencyid is null)  
   and (mo.paymentstartdate  < getdate() /*or mo.paymentstartdate  is null*/)  
   and (mo.PaymentStopDate  is null or mo.PaymentStopDate > getdate())   
   and PlanTypeName = 'ISA'
  
 if(select count(*) from #escalationtypesisa) = 1 begin  
  update #tempScenarioData  
  set  escalationtypeisa = (select distinct escalationtype from #escalationtypesisa)  
 end  
 else begin  
  update #tempScenarioData  
  set  escalationtypeisa = 'Various'  
 end  
  
  
  
end  
  
select * from #tempScenarioData  
  
  
  
  
GO
