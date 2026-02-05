SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomRetrieveFPInvestments]     
     @FinancialPlanningId bigint,    
     @CRMContactId bigint,     
     @CRMContactId2 bigint,     
     @includeAssets bit = 0,    
     @policyBusinessId bigint = 0,    
     @investmentType varchar (50) = null    
    
as    
--spNCustomRetrieveFPInvestments 0,961980,0,1    
-- TEMPORARY TABLE FOR PERFORMANCE OPTIMISATION
SELECT 
       COUNT(X.PolicyOwnerId)'OwnerCount',
       X.PolicyDetailId,
       MIN(X.CRMCOntactId)'CRMContactId',                
       CASE MAX(X.CRMCOntactId)                
       WHEN MIN(X.CRMCOntactId) THEN NULL                
       ELSE MAX(X.CRMCOntactId)                
       END AS CRMCOntactId2   ,
       MIN(Y.PolicyBusinessId ) AS PolicyBusinessId
into #tempPolicyBusinessDetails

       FROM PolicyManagement..TPolicyOwner  X
       join PolicyManagement..TPolicyBusiness  Y on x.PolicyDetailId = y.PolicyDetailId

       where CRMContactId IN (@CRMContactId, @CRMContactId2)
GROUP BY   X.PolicyDetailId     


-- Table for Plan Types Details                
DECLARE @PlanDescription TABLE                  
 (                  
  PolicyBusinessId bigint not null PRIMARY KEY,                  
  RefPlanType2ProdSubTypeId bigint not null,      
  PolicyDetailId bigint not null,                  
  CRMContactId bigint not null,                  
  CRMContactId2 bigint null,                  
  Owner varchar(16) not null,                  
  OwnerCount int not null,                  
  PlanType varchar(128) not null,                  
  AgreementTypesFullName varchar(128) not null,                  
  --FactFindSearchType varchar(64) not null,                  
  Provider varchar(128) not null,                  
  PolicyNumber varchar(64) null,                  
  AgencyStatus varchar(50) null,
  StartDate datetime null,                  
  MaturityDate datetime null,                  
  StatusDate datetime not null,                  
  Term tinyint null,                      
  RegularPremium money null,                  
  ActualRegularPremium money null,                  
  TotalLumpSum money null,                  
  TotalPremium money null,                  
  Frequency varchar(32) null,                  
  Valuation money null,                  
  CurrentValue money null,                  
  ValuationDate datetime,                  
  ProductName varchar(255) null,                  
  RefPlanTypeId bigint,                  
  SellingAdviserId bigint,                  
  SellingAdviserName varchar(255),                  
  PlanPurpose varchar(255),         
  AnnualIncome money,      
  ConcurrencyId bigint null,      
  SequentialRef varchar(255)      
 )                  
                   
 -- Basic Plan Details                  
 INSERT INTO @PlanDescription                  
 SELECT                  
  Pb.PolicyBusinessId,                  
 PlanToProd.RefPlanType2ProdSubTypeId  ,      
 Pd.PolicyDetailId,                  
  POWN2.CRMContactId,                  
  POWN2.CRMContactId2,                  
  CASE POWN2.OwnerCount                  
   WHEN 1 THEN                  
    CASE POWN2.CRMContactId                  
     WHEN @CRMContactId THEN 'Client 1'                  
     ELSE 'Client 2'                  
    END                  
   ELSE 'Joint'                      
  END,                  
  POWN2.OwnerCount,                  
  CASE                   
   WHEN LEN(ISNULL(Pst.ProdSubTypeName, '')) > 0 THEN  PType.PlanTypeName + ' (' + Pst.ProdSubTypeName + ')'                  
   ELSE PType.PlanTypeName                  
  END,                    
  CASE                   
   WHEN LEN(ISNULL(Pst.ProdSubTypeName, '')) > 0 THEN  PType.PlanTypeName + ' - ' + Pst.ProdSubTypeName      
   ELSE PType.PlanTypeName                  
  END,       
  RppC.CorporateName,                  
  Pb.PolicyNumber,                  
  ISNULL(Pb.PolicyStartDate,sh.ChangedToDate),                  
  Pb.MaturityDate,                  
  Sh.DateOfChange,                  
  Pd.TermYears,                  
  case                 
    when ISNULL(pb.TotalRegularPremium,0) > 0 then pb.TotalRegularPremium                
    else isnull(pb.TotalLumpSum,0)                
  end,                
  ISNULL(Pb.TotalRegularPremium, 0), -- Actual regular premium                    
  ISNULL(Pb.TotalLumpSum, 0),                    
  ISNULL(Pb.TotalLumpSum, 0) + ISNULL(Pb.TotalRegularPremium, 0),                    
  pb.PremiumType,                  
  -- Valuation                  
  Val.PlanValue,                  
  -- CurrentValue                  
  CASE                  
   WHEN ISNULL(Fund.FundValue, 0) != 0 THEN Fund.FundValue                  
   WHEN Val.PlanValue IS NOT NULL THEN Val.PlanValue               
   ELSE ISNULL(Pb.TotalLumpSum, 0)                  
  END,                  
  Val.PlanValueDate,                  
  pb.ProductName,                  
  pType.RefPlanTypeId,            
  pb.PractitionerId,                  
  isnull(pracCRM.FirstName,'') + ' ' + isnull(pracCRM.LastName,''),                  
  ISNULL(MinPurpose.Descriptor,''),       
 null,                  
  pb.ConcurrencyId       ,      
 pb.SequentialRef           
 FROM                  
  #tempPolicyBusinessDetails
  AS Po                   
  JOIN                  
  (SELECT COUNT(PolicyOwnerId)'OwnerCount',PolicyDetailId,MIN(CRMCOntactId)'CRMContactId',                  
   CASE MAX(CRMCOntactId)                  
    WHEN MIN(CRMCOntactId) THEN NULL                  
    ELSE MAX(CRMCOntactId)                  
   END AS CRMCOntactId2                  
  FROM PolicyManagement..TPolicyOwner                  
  GROUP BY PolicyDetailId)POWN2 ON Po.PolicyDetailId=POWN2.PolicyDetailId                  
  --JOIN [CRM]..TCRMContact PoC WITH(NOLOCK) ON PoC.CRMContactId = Po.CRMContactId AND PoC.CRMContactId IN (@CRMContactId, @CRMContactId2) And Poc.IndClientId=@IndigoClientId                  
  JOIN PolicyManagement..TPolicyDetail Pd  WITH(NOLOCK) ON Pd.PolicyDetailId = Po.PolicyDetailId                  
  JOIN PolicyManagement..TPolicyBusiness Pb WITH(NOLOCK)  ON Pb.PolicyDetailId = Pd.PolicyDetailId                  
  JOIN PolicyManagement..TStatusHistory Sh WITH(NOLOCK) On Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1                  
  JOIN PolicyManagement..TStatus Status WITH(NOLOCK) ON Status.StatusId = Sh.StatusId AND Status.IntelligentOfficeStatusType IN('In Force', 'Paid Up')      
  JOIN PolicyManagement..TPlanDescription PDesc WITH(NOLOCK) ON PDesc.PlanDescriptionId = Pd.PlanDescriptionId                   
  JOIN PolicyManagement..TRefPlanType2ProdSubType PlanToProd WITH(NOLOCK) ON PlanToProd.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId                   
  LEFT JOIN PolicyManagement..TProdSubType Pst WITH(NOLOCK) ON Pst.ProdSubTypeId = PlanToProd.ProdSubTypeId                  
  JOIN PolicyManagement..TRefPlanType PType WITH(NOLOCK) ON PType.RefPlanTypeId = PlanToProd.RefPlanTypeId                  
  JOIN PolicyManagement..TRefProdProvider Rpp WITH(NOLOCK) ON Rpp.RefProdProviderId = PDesc.RefProdProviderId                   
  JOIN [CRM]..TCRMContact RppC WITH(NOLOCK) ON RppC.CRMContactId = Rpp.CRMContactId                  
  JOIN [CRM]..TPractitioner prac WITH (NOLOCK) ON prac.PractitionerId = pb.PractitionerId                  
  JOIN [CRM]..TCRMContact pracCRM WITH (NOLOCK) ON pracCRM.CRMContactId = prac.CRMContactId                   
   --Plan Purpose                  
    LEFT JOIN(                  
      SELECT A.PolicyBusinessId,MIN(PolicyBusinessPurposeId) AS PolicyBusinessPurposeId,MIN(B.Descriptor)'Descriptor'                 
      FROM PolicyManagement..TPolicyBusinessPurpose A                  
      JOIN PolicyManagement..TPlanPurpose B ON A.PlanPurposeId=B.PlanPurposeId     
      join #tempPolicyBusinessDetails XX on  A.PolicyBusinessId = XX.PolicyBusinessId             
      GROUP BY A.PolicyBusinessId)AS MinPurpose ON MinPurpose.PolicyBusinessId=Pb.PolicyBusinessId                   
  -- Latest valuation                  
  LEFT JOIN (                  
    SELECT                   
    V.PolicyBusinessId, Max(PlanValuationId) AS PlanValuationId                  
    FROM                   
    PolicyManagement..TPlanValuation V
    join #tempPolicyBusinessDetails XX  on  V.PolicyBusinessId = XX.PolicyBusinessId                 
    GROUP BY                   
    V.PolicyBusinessId                  
   ) AS LastVal ON LastVal.PolicyBusinessId = Pb.PolicyBusinessId                    
  LEFT JOIN PolicyManagement..TPlanValuation Val ON Val.PlanValuationId = LastVal.PlanValuationId                  
  -- Fund Price                  
  LEFT JOIN (                  
   SELECT                     
    F.PolicyBusinessId,                  
    SUM(ISNULL(CurrentPrice, 0) * ISNULL(CurrentUnitQuantity, 0)) AS FundValue                  
   FROM                  
    PolicyManagement..TPolicyBusinessFund F WITH(NOLOCK) 
    join #tempPolicyBusinessDetails XX  on  F.PolicyBusinessId = XX.PolicyBusinessId                       
   GROUP BY F.PolicyBusinessId                  
   ) AS Fund ON Fund.PolicyBusinessId = Pb.PolicyBusinessId                  
  -- Look for single contribution                  
  LEFT JOIN (                  
   SELECT         
	MNIN.PolicyBusinessId,                  
    COUNT(*) AS Number                  
   FROM                
    PolicyManagement..TPolicyMoneyIn MNIN  WITH(NOLOCK)  
    join #tempPolicyBusinessDetails XX on  MNIN.PolicyBusinessId = XX.PolicyBusinessId                    
   GROUP BY                  
    MNIN.PolicyBusinessId                  
   ) AS Contributions ON Contributions.PolicyBusinessId = Pb.PolicyBusinessId        
   
    
    
--update annual income    
update pd    
set  pd.annualincome = pmo.annualIncome    
from @PlanDescription pd    
inner join (select policybusinessid,    
   sum(CASE             
    when  RefFrequencyId=1 then amount * 52                  
       when  RefFrequencyId=2 then amount * 26                  
       when  RefFrequencyId=3 then amount*13          
       when  RefFrequencyId=4 then amount * 12     
       when  RefFrequencyId=5 then amount * 4               
       when  RefFrequencyId=7 then amount * 2       
       when  RefFrequencyId=8 then amount    
       else 0 END    
    )  as annualIncome    
   from policymanagement..TPolicyMoneyOut     
   group by policybusinessid) pmo on pmo.policybusinessid = pd.policybusinessid    
    
    
--INVESTMENTS    
 SELECT             
  SequentialRef   ,    
  Pd.PolicyBusinessId as id,      
  pd.PolicyDetailId,
  pd.CRMContactId,    
  pd.CRMContactId2,    
  Pd.PolicyNumber as policynumber,
  Pd.AgencyStatus,
  Pd.Provider,      
  pd.plantype,    
  pd.AgreementTypesFullName,    
  pd.ProductName,    
  pd.PlanPurpose,    
  case     
 when pd.CRMContactId is not null and pd.CRMContactId2 is not null then c1.Firstname + ' &amp; ' + c2.Firstname    
 when pd.CRMContactId is not null and pd.CRMContactId2 is null then c1.Firstname    
 when pd.CRMContactId is null and pd.CRMContactId2 is not null then c2.Firstname    
 else null    
 end as InvestmentOwner,    
 'investment' as type,    
case when a.InvestmentId is not null and a.InvestmentType = 'investment' then 1 else 0 end as selected    
,    
isnull(FinancialPlanningSelectedInvestmentsId,0) as FinancialPlanningSelectedInvestmentsId,    
pd.Frequency,    
pd.SellingAdviserId,    
cast (pd.ActualRegularPremium as varchar) as ActualRegularPremium,    
pd.ConcurrencyId,    
pd.PolicyNumber,    
CONVERT(VARCHAR(10), pd.StartDate, 103) as StartDate,    
pd.PlanType as planType,    
cast (pd.Valuation as varchar) as Valuation,    
cast (pd.CurrentValue as varchar) as CurrentValue,    
it.InTrustFG,    
case     
 when pd.CRMContactId is not null and pd.CRMContactId2 is not null then 'Joint'    
 when pd.CRMContactId is not null and pd.CRMContactId2 is null then 'Client 1'    
 when pd.CRMContactId is null and pd.CRMContactId2 is not null then 'Client 2'    
 else null    
 end as FFOwner,    
null as PurchasePrice,    
null as AssetCategoryId,    
null as RelatedtoAddress,    
null as PurchasedOn,    
null as ValuedOn,    
cast(isnull(ext.annualcharges,-99) as varchar) as annualcharges,    
cast(isnull(ext.WrapperCharge,0) as varchar) as wrappercharges,    
cast(isnull(ext.InitialAdviceCharge,0) as varchar) as initialcharges,    
cast(isnull(ext.OngoingAdviceCharge,0) as varchar) as ongoingcharges,    
cast(isnull(AnnualIncome,0) as varchar) as AnnualIncome,    
cast(isnull(ReservedValue,0) as varchar) as ReservedValue ,  
pd.RefPlanType2ProdSubTypeId   
  FROM @PlanDescription pd    
 inner join TRefPlanTypeToSection pts on pts.RefPlanType2ProdSubTypeId = pd.RefPlanType2ProdSubTypeId    
 left join TFinancialPlanningSelectedInvestments a on a.InvestmentId = pd.PolicyBusinessId and a.FinancialPlanningId = @FinancialPlanningId    
  left join crm..tcrmcontact c1 on c1.crmcontactid = pd.CRMContactId           
  left join crm..tcrmcontact c2 on c2.crmcontactid = pd.CRMContactId2    
  LEFT JOIN TOtherInvestmentsPlanFFExt t ON t.PolicyBusinessId = pd.PolicyBusinessId            
  left join policymanagement..TPolicyBusinessExt ext on ext.PolicyBusinessId = pd.PolicyBusinessId    
  LEFT JOIN                 
  (                
   SELECT                 
   MIN(pb.PolicyBenefitId) as PolicyBenefitId,                 
   PolicyBusinessId                
   FROM Policymanagement..TPolicyBenefit pb                
   WHERE CRMContactId in (@CRMContactId, @CRMContactId2)                
   GROUP BY PolicyBusinessId                
  ) pben ON pben.PolicyBusinessId = pd.PolicyBusinessId                
  LEFT JOIN Policymanagement..TPolicyBenefit pb WITH(NOLOCK) ON pb.PolicyBenefitId = pben.PolicyBenefitId                
  LEFT JOIN PolicyManagement..TInTrust iT WITH(NOLOCK) ON iT.InTrustId = pb.InTrustId                
  WHERE     
 (@policyBusinessId = 0 or (@policyBusinessId = pd.PolicyBusinessId and @investmentType = 'investment'))    
 and pts.section = 'Other Investments'    
-- Exclude Topups
		AND PD.PolicyBusinessId IN (     
                   SELECT MIN(PolicyBusinessId)     
             FROM policymanagement..TPolicyBusiness A WITH(NOLOCK)
             WHERE A.PolicyDetailId = pd.PolicyDetailId    
             GROUP BY PolicyDetailId    
        )    
    
union    
--CASHDEPOSIT    
SELECT    
 SequentialRef   ,    
  Pd.PolicyBusinessId as id,                
  pd.PolicyDetailId,
  pd.CRMContactId,    
  pd.CRMContactId2,    
  Pd.PolicyNumber as policynumber,    
  Pd.AgencyStatus,
  Pd.Provider,      
  pd.plantype,    
  pd.AgreementTypesFullName,    
  pd.ProductName,    
  pd.PlanPurpose,    
  case     
 when pd.CRMContactId is not null and pd.CRMContactId2 is not null then c1.Firstname + ' &amp; ' + c2.Firstname    
 when pd.CRMContactId is not null and pd.CRMContactId2 is null then c1.Firstname    
 when pd.CRMContactId is null and pd.CRMContactId2 is not null then c2.Firstname    
 else null    
 end as InvestmentOwner,    
 'cashdeposit' as type ,    
    case when a.InvestmentId is not null and a.InvestmentType = 'cashdeposit' then 1 else 0 end as selected,    
isnull(FinancialPlanningSelectedInvestmentsId,0) as FinancialPlanningSelectedInvestmentsId,    
pd.Frequency,    
pd.SellingAdviserId,    
cast (pd.ActualRegularPremium as varchar) as ActualRegularPremium,    
pd.ConcurrencyId,    
pd.PolicyNumber,    
CONVERT(VARCHAR(10), pd.StartDate, 103) as StartDate,    
pd.PlanType,    
cast (pd.Valuation as varchar) as Valuation,    
cast (pd.CurrentValue as varchar) as CurrentValue,    
null,    
case     
 when pd.CRMContactId is not null and pd.CRMContactId2 is not null then 'Joint'    
 when pd.CRMContactId is not null and pd.CRMContactId2 is null then 'Client 1'    
 when pd.CRMContactId is null and pd.CRMContactId2 is not null then 'Client 2'    
 else null    
 end as FFOwner,    
null,    
null,    
null,    
null,    
null,    
cast(isnull(ext.annualcharges,-99) as varchar) as annualcharges,    
cast(isnull(ext.WrapperCharge,0) as varchar) as wrappercharges,    
cast(isnull(ext.InitialAdviceCharge,0) as varchar) as initialcharges,    
cast(isnull(ext.OngoingAdviceCharge,0) as varchar) as ongoingcharges,    
cast(isnull(AnnualIncome,0) as varchar) as AnnualIncome,    
cast(isnull(ReservedValue,0) as varchar) as ReservedValue  ,  
pd.RefPlanType2ProdSubTypeId  
  FROM @PlanDescription pd          
left join TFinancialPlanningSelectedInvestments a on a.InvestmentId = pd.PolicyBusinessId and a.FinancialPlanningId = @FinancialPlanningId    
inner join TRefPlanTypeToSection pts on pts.RefPlanType2ProdSubTypeId = pd.RefPlanType2ProdSubTypeId    
left join crm..tcrmcontact c1 on c1.crmcontactid = pd.CRMContactId           
  left join crm..tcrmcontact c2 on c2.crmcontactid = pd.CRMContactId2    
 left join policymanagement..TPolicyBusinessExt ext on ext.PolicyBusinessId = pd.PolicyBusinessId    
  WHERE (@policyBusinessId = 0 or (@policyBusinessId = pd.PolicyBusinessId and @investmentType = 'cashdeposit'))    
  and pts.section = 'Savings'    
    
union    
    
--ASSET    
 SELECT         
 null,            
  A.AssetsId as id,    
  NULL,
  a.CRMContactId,    
  a.CRMContactId2,    
  null,
  null,
  A.[Description],     
  CategoryName,                  
 CategoryName,                  
  null,    
  null,    
   case     
 when a.CRMContactId is not null and a.CRMContactId2 is not null then c1.Firstname + ' &amp; ' + c2.Firstname    
 when a.CRMContactId is not null and a.CRMContactId2 is null then c1.Firstname    
 when a.CRMContactId is null and a.CRMContactId2 is not null then c2.Firstname    
 else null    
 end as InvestmentOwner,    
 'asset' as type    ,    
case when fp.InvestmentId is not null and fp.InvestmentType = 'asset' then 1 else 0 end as selected,    
isnull(FinancialPlanningSelectedInvestmentsId,0) as FinancialPlanningSelectedInvestmentsId,    
null,    
null,    
null,    
a.concurrencyId,    
null,    
null,    
null,    
a.Amount,    
a.Amount,    
null,    
case     
 when a.CRMContactId is not null and a.CRMContactId2 is not null then 'Joint'    
 when a.CRMContactId is not null and a.CRMContactId2 is null then 'Client 1'    
 when a.CRMContactId is null and a.CRMContactId2 is not null then 'Client 2'    
 else null    
 end as FFOwner,    
PurchasePrice,    
a.AssetCategoryId,    
RelatedtoAddress,    
PurchasedOn,    
ValuedOn,    
'0',    
'0',    
'0',    
'0',    
'0',    
'0',   
'0'    
 FROM                 
  Tassets A      
inner join TAssetCategory b2 on b2.AssetCategoryId = a.AssetCategoryId    
left join TFinancialPlanningSelectedInvestments fp on fp.InvestmentId =  A.AssetsId  and fp.FinancialPlanningId = @FinancialPlanningId      
left join crm..tcrmcontact c1 on c1.crmcontactid = a.CRMContactId           
  left join crm..tcrmcontact c2 on c2.crmcontactid = a.CRMContactId2    
  LEFT JOIN          
 (          
 SELECT A.CRMContactId,B.AddressStoreId,B.AddressLine1          
 FROM CRM..TAddress A          
 JOIN CRM..TAddressStore B ON A.AddressStoreId=B.AddressStoreId          
 WHERE A.CRMContactId IN (@CRMContactId,@CRMContactId2)          
 ) B ON A.RelatedtoAddress=B.AddressLine1 AND A.CRMContactId=B.CRMContactId                  
 WHERE            
(@policyBusinessId = 0 or (@policyBusinessId = a.assetsid and @investmentType = 'asset'))    
and         
  (A.CRMContactId = @CRMContactId OR (A.CRMContactId=@CRMContactId2 AND @CRMContactId2 IS NOT NULL) OR A.CRMContactId2=@CRMContactId)    
and @includeAssets = 1    
           
    
--if this is a request for a single investment return the conributions and renewals    
--This is currently only used for eValue so return the required basis and rate values    
--if isnull(@policyBusinessId,0) > 0 begin    
    
 --Contributions    
 select pd.policybusinessid,    
   pd.PolicyDetailId,
   case    
   when EscalationType is null then 'NONE'    
   when EscalationType = 'Fixed %' then 'NONE'    
   when EscalationType = 'RPI' then 'RPI'    
   when EscalationType = 'Level' then 'NONE'    
   when EscalationType = 'NAEI' then 'NAEI'    
   else 'NONE'    
            end as Basis,    
   case    
   when EscalationType is null then '0'    
   when EscalationType = 'Fixed %' then isnull(EscalationPercentage,0)    
   when EscalationType = 'RPI' then '0'    
   when EscalationType = 'Level' then '0'    
   when EscalationType = 'NAEI' then '0'    
   else '0'    
            end as Rate,    
    cast(sum(CASE             
     when  rf.RefFrequencyId=1 then amount * 52                  
     when  rf.RefFrequencyId=2 then amount * 26                  
     when  rf.RefFrequencyId=3 then amount*13          
     when  rf.RefFrequencyId=4 then amount * 12     
     when  rf.RefFrequencyId=5 then amount * 4               
     when  rf.RefFrequencyId=7 then amount * 2       
     when  rf.RefFrequencyId=8 then amount    
     else 0 END    
     ) as DECIMAL(16,2))  as AnnualContributions    
 from policymanagement..TPolicyMoneyIn mi    
 inner join policymanagement..TRefFrequency rf on rf.reffrequencyid = mi.reffrequencyid    
 left join policymanagement..TRefEscalationType re on re.RefEscalationTypeId = mi.RefEscalationTypeId    
 inner join @PlanDescription pd on pd.policybusinessid = mi.PolicyBusinessId    
 where rf.reffrequencyid in (1,2,3,4,5,7,8) and    
   mi.startdate < getdate() and    
   (mi.stopdate is null or mi.stopdate > getdate())    
 group by pd.policybusinessid,    
	pd.PolicyDetailId,
   case    
   when EscalationType is null then 'NONE'    
   when EscalationType = 'Fixed %' then 'NONE'    
when EscalationType = 'RPI' then 'RPI'    
   when EscalationType = 'Level' then 'NONE'    
   when EscalationType = 'NAEI' then 'NAEI'    
   else 'NONE'    
            end ,    
   case    
   when EscalationType is null then '0'    
   when EscalationType = 'Fixed %' then isnull(EscalationPercentage,0)    
   when EscalationType = 'RPI' then '0'    
   when EscalationType = 'Level' then '0'    
   when EscalationType = 'NAEI' then '0'    
   else '0'    
            end    
    
    
 --Withdrawals    
 select pd.policybusinessid,    
   case    
   when EscalationType is null then 'NONE'    
   when EscalationType = 'Fixed %' then 'NONE'    
   when EscalationType = 'RPI' then 'RPI'    
   when EscalationType = 'Level' then 'NONE'    
   when EscalationType = 'NAEI' then 'NAEI'    
   else 'NONE'    
            end as Basis,    
   case    
   when EscalationType is null then '0'    
   when EscalationType = 'Fixed %' then isnull(EscalationPercentage,0)    
   when EscalationType = 'RPI' then '0'    
   when EscalationType = 'Level' then '0'    
   when EscalationType = 'NAEI' then '0'    
   else '0'    
            end as Rate,    
    cast(sum(CASE             
     when  rf.RefFrequencyId=1 then amount * 52                  
     when  rf.RefFrequencyId=2 then amount * 26                  
     when  rf.RefFrequencyId=3 then amount*13          
     when  rf.RefFrequencyId=4 then amount * 12     
     when  rf.RefFrequencyId=5 then amount * 4               
     when  rf.RefFrequencyId=7 then amount * 2       
     when  rf.RefFrequencyId=8 then amount    
     else 0 END    
     ) as DECIMAL(16,2))  as FutureExpenditures    
 from policymanagement..TPolicyMoneyOut mi    
 inner join policymanagement..TRefFrequency rf on rf.reffrequencyid = mi.reffrequencyid    
 left join policymanagement..TRefEscalationType re on re.RefEscalationTypeId = mi.RefEscalationTypeId    
 inner join @PlanDescription pd on pd.policybusinessid = mi.PolicyBusinessId    
 where rf.reffrequencyid in (1,2,3,4,5,7,8) and    
   paymentstartdate < getdate() and    
   (paymentstopdate is null or paymentstopdate > getdate())     
 group by pd.policybusinessid,    
   case    
   when EscalationType is null then 'NONE'    
   when EscalationType = 'Fixed %' then 'NONE'    
   when EscalationType = 'RPI' then 'RPI'    
   when EscalationType = 'Level' then 'NONE'    
   when EscalationType = 'NAEI' then 'NAEI'    
   else 'NONE'    
            end ,    
   case    
   when EscalationType is null then '0'    
   when EscalationType = 'Fixed %' then isnull(EscalationPercentage,0)    
   when EscalationType = 'RPI' then '0'    
   when EscalationType = 'Level' then '0'    
   when EscalationType = 'NAEI' then '0'    
   else '0'    
            end    
    
--end    
    
    
GO
