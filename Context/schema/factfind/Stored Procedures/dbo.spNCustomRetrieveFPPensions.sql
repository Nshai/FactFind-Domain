SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomRetrieveFPPensions] 
					@FinancialPlanningId bigint, 
					@CRMContactId bigint, 
					@CRMContactId2 bigint, 
					@includeAssets bit = 0,
					@policyBusinessId bigint = 0,
					@investmentType varchar (50) = null

as

--get the default Annual Pension Increase for this planning session
declare @AnnualPensionIncrease varchar (50)
select	@AnnualPensionIncrease = PensionIncrease from TFinancialPlanningExt where FinancialPlanningId = @FinancialPlanningId

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
   

-- final salary plans            
SELECT distinct             
 SequentialRef   ,
Pd.PolicyBusinessId as id,
pd.PolicyDetailId,
pd.Frequency,
pd.SellingAdviserId,
pd.ActualRegularPremium,
pd.ConcurrencyId,
pd.PolicyNumber,
pd.AgencyStatus,
pd.StartDate,
cast(pd.Valuation as varchar) as Valuation,
cast(pd.CurrentValue as varchar) as CurrentValue,
pd.PlanPurpose,

case 
	when pd.CRMContactId is not null and pd.CRMContactId2 is not null then 'Joint'
	when pd.CRMContactId is not null and pd.CRMContactId2 is null then 'Client 1'
	when pd.CRMContactId is null and pd.CRMContactId2 is not null then 'Client 2'
	else null
 end as FFOwner,
pd.Provider,
pd.RefPlanType2ProdSubTypeId,
pd.plantype,
pd.AgreementTypesFullName ,
 case 
	when pd.CRMContactId is not null and pd.CRMContactId2 is not null then c1.Firstname + ' &amp; ' + c2.Firstname
	when pd.CRMContactId is not null and pd.CRMContactId2 is null then c1.Firstname
	when pd.CRMContactId is null and pd.CRMContactId2 is not null then c2.Firstname
	else null
 end as InvestmentOwner,
'pension' as type,
case when a.InvestmentId is not null and a.InvestmentType = 'pension' 
		and PensionableSalary is not null 
		and ExpectedYearsOfService  is not null 
		and AccrualRate  is not null 
then 1 else 0 end as selected,
isnull(FinancialPlanningSelectedInvestmentsId,0) as FinancialPlanningSelectedInvestmentsId,
cast(isnull(pbext.annualcharges,0) as varchar) as AnnualCharges,
cast(isnull(pbext.WrapperCharge,0) as varchar) as wrappercharges,
cast(isnull(pbext.InitialAdviceCharge,0) as varchar) as initialcharges,
cast(isnull(pbext.OngoingAdviceCharge,0) as varchar) as ongoingcharges,
isnull(pbext.PensionIncrease,@AnnualPensionIncrease) as PensionIncrease,
case						
			when @AnnualPensionIncrease = 'RPI' then 'RPI'
			when @AnnualPensionIncrease = 'Limited to 5' then 'LPI'
			when @AnnualPensionIncrease = 'Limited to 2.5' then 'LPI'
			else 'NONE'
												end as PensionIncreaseBasis,
			case
			when @AnnualPensionIncrease = 'RPI' then '0'
			when @AnnualPensionIncrease = 'Limited to 5' then '5'
			when @AnnualPensionIncrease = 'Limited to 2.5' then '2.5'
			when @AnnualPensionIncrease in ('1','2','3','4','5') then @AnnualPensionIncrease
			else 'NONE'
												end as PensionIncreaseRate,
SpousePercentage,
--RetirementAge,
GuaranteePeriod,
PensionableSalary, 
ExpectedYearsOfService, 
AccrualRate,
SRA,
0 as ReservedValue
 
 FROM @PlanDescription pd            
inner join TRefPlanTypeToSection pts on pts.RefPlanType2ProdSubTypeId = pd.RefPlanType2ProdSubTypeId
  left join TFinancialPlanningSelectedInvestments a on a.InvestmentId = pd.PolicyBusinessId and a.FinancialPlanningId = @FinancialPlanningId
  left join TFinancialPlanningExt fpExt on fpExt.FinancialPlanningId = a.FinancialPlanningId
  left join crm..tcrmcontact c1 on c1.crmcontactid = pd.CRMContactId       
  left join crm..tcrmcontact c2 on c2.crmcontactid = pd.CRMContactId2
  INNER JOIN PolicyManagement..TPensionInfo tpi WITH(NOLOCK) ON tpi.PolicyBusinessId = pd.PolicyBusinessId            
  /* LEFT JOIN TFinalSalaryPensionsPlanFFExt ext WITH(NOLOCK) ON ext.PolicyBusinessId = pd.PolicyBusinessId*/
  left join policymanagement..TPolicyBusinessExt pbext on pbext.PolicyBusinessId = pd.PolicyBusinessId
  	
  WHERE pts.section = 'Final Salary Schemes' and 
		(@policyBusinessId = 0 or @policyBusinessId = pd.PolicyBusinessId) 


union
          
 -- money purchase pension plans            
 SELECT                   
 SequentialRef   ,
Pd.PolicyBusinessId as id,
pd.PolicyDetailId,
pd.Frequency,
pd.SellingAdviserId,
pd.ActualRegularPremium,
pd.ConcurrencyId,
pd.PolicyNumber,
pd.AgencyStatus,
pd.StartDate,

cast(pd.Valuation as varchar) as Valuation,
cast(pd.CurrentValue as varchar) as CurrentValue,
pd.PlanPurpose,

case 
	when pd.CRMContactId is not null and pd.CRMContactId2 is not null then 'Joint'
	when pd.CRMContactId is not null and pd.CRMContactId2 is null then 'Client 1'
	when pd.CRMContactId is null and pd.CRMContactId2 is not null then 'Client 2'
	else null
 end as FFOwner,
pd.Provider,
pd.RefPlanType2ProdSubTypeId,
pd.PlanType,
pd.AgreementTypesFullName,
case 
	when pd.CRMContactId is not null and pd.CRMContactId2 is not null then c1.Firstname + ' &amp; ' + c2.Firstname
	when pd.CRMContactId is not null and pd.CRMContactId2 is null then c1.Firstname
	when pd.CRMContactId is null and pd.CRMContactId2 is not null then c2.Firstname
	else null
 end as PensionOwner,
'pension' as type,
case when a.InvestmentId is not null and a.InvestmentType = 'pension' then 1 else 0 end as selected,
isnull(FinancialPlanningSelectedInvestmentsId,0) as FinancialPlanningSelectedInvestmentsId,
cast(isnull(pbext.annualcharges,0) as varchar) as AnnualCharges,
cast(isnull(pbext.WrapperCharge,0) as varchar) as wrappercharges,
cast(isnull(pbext.InitialAdviceCharge,0) as varchar) as initialcharges,
cast(isnull(pbext.OngoingAdviceCharge,0) as varchar) as ongoingcharges,
isnull(pbext.PensionIncrease,@AnnualPensionIncrease) as PensionIncrease,
case						
			when isnull(pbext.PensionIncrease,@AnnualPensionIncrease) = 'RPI' then 'RPI'
			when isnull(pbext.PensionIncrease,@AnnualPensionIncrease) = 'Limited to 5' then 'LPI'
			when isnull(pbext.PensionIncrease,@AnnualPensionIncrease) = 'Limited to 2.5' then 'LPI'
			else 'NONE'
												end as PensionIncreaseBasis,
			case
			when @AnnualPensionIncrease = 'RPI' then '0'
			when @AnnualPensionIncrease = 'Limited to 5' then '5'
			when @AnnualPensionIncrease = 'Limited to 2.5' then '2.5'
			when @AnnualPensionIncrease in ('1','2','3','4','5') then @AnnualPensionIncrease
			else 'NONE'
												end as PensionIncreaseRate,
SpousePercentage,
--RetirementAge,
GuaranteePeriod,
null,
null,
null,
null,
0 as ReservedValue
  FROM @PlanDescription pd            
inner join TRefPlanTypeToSection pts on pts.RefPlanType2ProdSubTypeId = pd.RefPlanType2ProdSubTypeId
  left join TFinancialPlanningSelectedInvestments a on a.InvestmentId = pd.PolicyBusinessId  and a.FinancialPlanningId = @FinancialPlanningId
  left join TFinancialPlanningExt fpExt on fpExt.FinancialPlanningId = a.FinancialPlanningId  
left join crm..tcrmcontact c1 on c1.crmcontactid = pd.CRMContactId       
  left join crm..tcrmcontact c2 on c2.crmcontactid = pd.CRMContactId2            
  /*LEFT JOIN PolicyManagement..TPensionInfo tpi WITH(NOLOCK) ON tpi.PolicyBusinessId = pd.PolicyBusinessId            
  LEFT JOIN TMoneyPurchasePensionPlanFFExt ext WITH(NOLOCK) ON ext.PolicyBusinessId = pd.PolicyBusinessId*/
  left join policymanagement..TPolicyBusinessExt pbext on pbext.PolicyBusinessId = pd.PolicyBusinessId
  LEFT JOIN (            
   SELECT pmi.PolicyBusinessId, pmiSelf.Amount as SelfContributionAmount, pmiEmp.Amount as EmployerContributionAmount, pmiSelfLump.Amount as SelfLumpContributionAmount, pmiEmpLump.Amount as EmployerLumpContributionAmount              
   FROM PolicyManagement..TPolicyMoneyIn pmi WITH(NOLOCK)      
   LEFT JOIN PolicyManagement..TPolicyMoneyIn pmiSelf WITH(NOLOCK) ON pmiSelf.PolicyBusinessId = pmi.PolicyBusinessId AND pmiSelf.RefContributorTypeId = 1 
		AND pmiSelf.RefContributionTypeId = 1 AND (pmiSelf.StartDate <= getdate() and (pmiSelf.StopDate is null or pmiSelf.StopDate > getdate()))      
   LEFT JOIN PolicyManagement..TPolicyMoneyIn pmiEmp WITH(NOLOCK) ON pmiEmp.PolicyBusinessId = pmi.PolicyBusinessId AND pmiEmp.RefContributorTypeId = 2 
		AND pmiEmp.RefContributionTypeId = 1 AND (pmiEmp.StartDate <= getdate() and (pmiEmp.StopDate is null or pmiEmp.StopDate > getdate()))      
   LEFT JOIN --sum the self lump sums      
 (      
  SELECT PolicyBusinessId, sum(Amount) as Amount      
  FROM PolicyManagement..TPolicyMoneyIn WITH (NOLOCK)      
  WHERE RefContributorTypeId = 1       
  AND RefContributionTypeId = 2       
AND StartDate <= getdate()      
  GROUP BY PolicyBusinessId      
 ) pmiSelfLump ON pmiSelfLump.PolicyBusinessId = pmi.PolicyBusinessId      
   LEFT JOIN -- sum the employer lump sums      
 (      
  SELECT PolicyBusinessId, sum(Amount) as Amount      
  FROM PolicyManagement..TPolicyMoneyIn WITH (NOLOCK)      
  WHERE RefContributorTypeId = 2       
  AND RefContributionTypeId = 2       
  AND StartDate <= getdate()      
  GROUP BY PolicyBusinessId      
 ) pmiEmpLump ON pmiEmpLump.PolicyBusinessId = pmi.PolicyBusinessId      
      
   GROUP BY pmi.PolicyBusinessId, pmiSelf.Amount, pmiEmp.Amount, pmiSelfLump.amount, pmiEmpLump.amount                
      
  ) cont ON cont.PolicyBusinessId = pd.PolicyBusinessId            
  WHERE (pts.section = 'Money Purchase Pension Schemes'  OR pts.section = 'Pension Plans' ) and
		(@policyBusinessId = 0 or @policyBusinessId = pd.PolicyBusinessId)          
		-- Exclude Topups
		AND PD.PolicyBusinessId IN (     
                   SELECT MIN(PolicyBusinessId)     
             FROM policymanagement..TPolicyBusiness A WITH(NOLOCK)
             WHERE A.PolicyDetailId = pd.PolicyDetailId    
             GROUP BY PolicyDetailId    
        )    
		
union

--ASSET
 SELECT         
 null   ,    
  A.AssetsId as id,
  NULL,
  null,  
null,
null,
a.concurrencyId,
null,
null,
null,
null,
cast(a.Amount as varchar) as amount,
null,

case 
	when a.CRMContactId is not null and a.CRMContactId2 is not null then 'Joint'
	when a.CRMContactId is not null and a.CRMContactId2 is null then 'Client 1'
	when a.CRMContactId is null and a.CRMContactId2 is not null then 'Client 2'
	else null
 end as FFOwner,
description,
0 AS RefPlanType2ProdSubTypeId,
case when CategoryName is not null then CategoryName
	when Type is not null then Type
else 'Unknown' end,
case when CategoryName is not null then CategoryName
	when Type is not null then Type
else 'Unknown' end,
case 
	when a.CRMContactId is not null and a.CRMContactId2 is not null then c1.Firstname + ' &amp; ' + c2.Firstname
	when a.CRMContactId is not null and a.CRMContactId2 is null then c1.Firstname
	when a.CRMContactId is null and a.CRMContactId2 is not null then c2.Firstname
	else null
 end as PensionOwner,
'asset' as type,
case when fp.InvestmentId is not null and fp.InvestmentType = 'asset' then 1 else 0 end as selected,
isnull(FinancialPlanningSelectedInvestmentsId,0) as FinancialPlanningSelectedInvestmentsId,
'0',
'0',
'0',
'0',
null,
null,
null,
null,
null,
null,
null,
null,
null,
0 as ReservedValue
 FROM             
  Tassets A  
left join TAssetCategory ac on ac.AssetCategoryId = a.AssetCategoryId
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
and @includeAssets = 1 and		
		(@policyBusinessId = 0 or @policyBusinessId = a.AssetsId)


--if this is a request for a single investment return the conributions and renewals
--This is currently only used for eValue so return the required basis and rate values


	--Contributions
	select	
	pd.policybusinessid,
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
					) as int)  as AnnualContributions
		 	from policymanagement..TPolicyMoneyIn mi
	inner join policymanagement..TRefFrequency rf on rf.reffrequencyid = mi.reffrequencyid
	left join policymanagement..TRefEscalationType re on re.RefEscalationTypeId = mi.RefEscalationTypeId
	inner join @PlanDescription pd on pd.policybusinessid = mi.PolicyBusinessId
	where	rf.reffrequencyid in (1,2,3,4,5,7,8) and
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
	select 
		pd.policybusinessid,
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
					) as int)  as FutureExpenditures
	from policymanagement..TPolicyMoneyOut mi
	inner join policymanagement..TRefFrequency rf on rf.reffrequencyid = mi.reffrequencyid
	left join policymanagement..TRefEscalationType re on re.RefEscalationTypeId = mi.RefEscalationTypeId
	inner join @PlanDescription pd on pd.policybusinessid = mi.PolicyBusinessId
	where	rf.reffrequencyid in (1,2,3,4,5,7,8) and
			paymentstartdate < getdate() and
			(paymentstopdate is null or paymentstopdate > getdate())					
	group by 	pd.policybusinessid,
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

GO
