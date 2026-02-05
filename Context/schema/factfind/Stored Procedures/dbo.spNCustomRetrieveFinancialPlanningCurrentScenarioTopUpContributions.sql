SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomRetrieveFinancialPlanningCurrentScenarioTopUpContributions]    
  
 @FinancialPlanningId bigint  
  
as  

-- GET ALL THE POLICY DETAIL IDS FIRST  
SELECT PolicyDetailId 
INTO #tempPolicyDetails
FROM policymanagement..TPolicyBusiness PB
INNER JOIN TFInancialPlanningSelectedInvestments fpi ON fpi.InvestmentId = PB.PolicyBusinessId
WHERE fpi.FinancialPlanningId = @FinancialPlanningId

-- GET THE MAIN POLICY IDs (EXCLUDE TopUps)
SELECT MIN(PolicyBusinessId) AS MainPolicyBusinessID
INTO #tempMAINPolicyBusiness
FROM policymanagement..TPolicyBusiness 
WHERE PolicyDetailId IN (SELECT * FROM #tempPolicyDetails)
GROUP BY PolicyDetailId 

-- NOW TopUps on these plans as we will need the contributions from that too 
SELECT 
	PB.PolicyBusinessId
INTO #tempTopupPolicies	
FROM
	 policymanagement..TPolicyBusiness PB WITH (NOLOCK)
	JOIN  policymanagement..TStatusHistory SH WITH (NOLOCK) ON SH.PolicyBusinessId = PB.PolicyBusinessId AND CurrentStatusFg = 1
	JOIN  policymanagement..TStatus S WITH (NOLOCK) ON S.StatusId = SH.StatusId AND S.IntelligentOfficeStatusType = 'In force'
WHERE
	Pb.PolicyDetailId IN (SELECT PolicyDetailId FROM #tempPolicyDetails)
	-- make sure that supplied plan is the main policy record.
	AND PB.PolicyBusinessId NOT IN (SELECT MainPolicyBusinessID FROM #tempMAINPolicyBusiness)
  
  
select distinct   
  0 as AnnualContributionsISA,  
  0 as AnnualContributions 
  
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
     ) as int),0)        
from   #tempTopupPolicies	 fpi  
--contributions  
left join policymanagement..TPolicyMoneyIn mi on mi.policybusinessid = fpi.PolicyBusinessId 
left join policymanagement..TRefFrequency rf on rf.reffrequencyid = mi.reffrequencyid 
inner join policymanagement..TPolicyBusiness pb on pb.policybusinessid = fpi.PolicyBusinessId
inner join policymanagement..TPolicyDetail pd on pd.policydetailid = pb.policydetailid
inner join policymanagement..TPlanDescription pdesc on pdesc.plandescriptionid = pd.plandescriptionid
inner join policymanagement..TRefPlanType2ProdSubType rpt on rpt.RefPlanType2ProdSubTypeId = pdesc.RefPlanType2ProdSubTypeId
inner join 	policymanagement..TRefPlanType r on r.refplantypeid = rpt.refplantypeid 
where 
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
     ) as int),0)        
from  #tempTopupPolicies fpi  
--contributions  
left join policymanagement..TPolicyMoneyIn mi on mi.policybusinessid = fpi.policybusinessid
left join policymanagement..TRefFrequency rf on rf.reffrequencyid = mi.reffrequencyid 
inner join policymanagement..TPolicyBusiness pb on pb.policybusinessid = fpi.policybusinessid
inner join policymanagement..TPolicyDetail pd on pd.policydetailid = pb.policydetailid
inner join policymanagement..TPlanDescription pdesc on pdesc.plandescriptionid = pd.plandescriptionid
inner join policymanagement..TRefPlanType2ProdSubType rpt on rpt.RefPlanType2ProdSubTypeId = pdesc.RefPlanType2ProdSubTypeId
inner join 	policymanagement..TRefPlanType r on r.refplantypeid = rpt.refplantypeid 
where 
  --contribution clauses  
  (rf.reffrequencyid in (1,2,3,4,5,7,8) or rf.reffrequencyid is null) and  
  (mi.startdate < getdate() /*or mi.startdate is null*/) and  
  (mi.stopdate is null or mi.stopdate > getdate())  and
  planTypeName = 'ISA'   )
from #tempScenarioData t  
  
select * from #tempScenarioData  
  
GO


