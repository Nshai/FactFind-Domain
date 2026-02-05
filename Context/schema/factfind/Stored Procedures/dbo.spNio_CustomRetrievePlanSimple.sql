SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure [dbo].[spNio_CustomRetrievePlanSimple]        
        
@PolicybusinessIds varchar(max)        
        
as        

Declare @ParsedValues Table ( Id int, ParsedValue varchar(200) )  
Insert Into @ParsedValues(Id, ParsedValue)
Exec Administration.dbo.SpCustomParseCsvStringToStringList @CommaSeperatedList = @PolicybusinessIds

                     
SELECT distinct         
	Pb.PolicyBusinessId,                    
	PlanToProd.RefPlanType2ProdSubTypeId  ,        
	PlanToProd.RefPlanTypeId ,
	Pd.PolicyDetailId,                   
	POWN2.CRMContactId,         
	own1.firstname + ' ' + own1.lastname as owner1name,          
	POWN2.CRMContactId2,        
	own2.firstname + ' ' + own2.lastname as owner2name,    
	CASE                     
		WHEN LEN(ISNULL(Pst.ProdSubTypeName, '')) > 0 THEN  PType.PlanTypeName + ' - ' + Pst.ProdSubTypeName      
		ELSE PType.PlanTypeName                    
	END as PlanType,                        
	RppC.CorporateName as Provider,                    
	Pb.PolicyNumber,              
	CASE                    
		WHEN ISNULL(Fund.FundValue, 0) != 0 THEN round(Fund.FundValue,2)      
		WHEN Val.PlanValue IS NOT NULL THEN round(Val.PlanValue,2)           
		ELSE ISNULL(Pb.TotalLumpSum, 0)                    
	END as CurrentValue,                 
	CASE                    
		WHEN ISNULL(Fund.FundValue, 0) != 0 THEN 'Fund Values'                    
		WHEN Val.PlanValue IS NOT NULL THEN 'Plan Valuation'        
		ELSE 'Lumpsum'                    
	END as ValuationSource,                 
	pb.ProductName,
	pb.SequentialRef,      
	case when   pts.section in ('Final Salary Schemes','Money Purchase Pension Schemes') 
		then 'pension' 
		else 'investment' 
	end as agreementType,      
	isnull(reservedvalue,0) as reservedvalue,      
	(isnull(ext.annualcharges,0) ) as AnnualCharge,      
	(isnull(ext.WrapperCharge,0) ) as WrapperCharge,      
	(isnull(ext.InitialAdviceCharge,0)) as InitialCharge,      
	(isnull(ext.OngoingAdviceCharge,0)) as OngoingCharge 
   
FROM PolicyManagement..TPolicyDetail Pd         
JOIN PolicyManagement..TPolicyBusiness Pb WITH(NOLOCK)  ON Pb.PolicyDetailId = Pd.PolicyDetailId                    
JOIN PolicyManagement..TStatusHistory Sh WITH(NOLOCK) On Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1                    
JOIN PolicyManagement..TStatus Status WITH(NOLOCK) ON Status.StatusId = Sh.StatusId --AND Status.IntelligentOfficeStatusType = 'In Force'                    
JOIN PolicyManagement..TPlanDescription PDesc WITH(NOLOCK) ON PDesc.PlanDescriptionId = Pd.PlanDescriptionId                     
JOIN PolicyManagement..TRefPlanType2ProdSubType PlanToProd WITH(NOLOCK) ON PlanToProd.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId                     
LEFT JOIN PolicyManagement..TProdSubType Pst WITH(NOLOCK) ON Pst.ProdSubTypeId = PlanToProd.ProdSubTypeId                    
JOIN PolicyManagement..TRefPlanType PType WITH(NOLOCK) ON PType.RefPlanTypeId = PlanToProd.RefPlanTypeId                    
JOIN PolicyManagement..TRefProdProvider Rpp WITH(NOLOCK) ON Rpp.RefProdProviderId = PDesc.RefProdProviderId                     
JOIN [CRM]..TCRMContact RppC WITH(NOLOCK) ON RppC.CRMContactId = Rpp.CRMContactId                 
inner join TRefPlanTypeToSection pts on pts.RefPlanType2ProdSubTypeId = PlanToProd.RefPlanType2ProdSubTypeId           
left join policymanagement..TPolicyBusinessExt ext on ext.PolicyBusinessId = Pb.PolicyBusinessId      
--Owners           
join (SELECT PolicyDetailId,MIN(CRMCOntactId) as CRMContactId,                    
CASE MAX(CRMCOntactId)                    
WHEN MIN(CRMCOntactId) THEN NULL                    
ELSE MAX(CRMCOntactId)                    
END AS CRMCOntactId2                    
FROM PolicyManagement..TPolicyOwner                    
GROUP BY PolicyDetailId)POWN2 ON pd.PolicyDetailId=POWN2.PolicyDetailId          
join [CRM]..TCRMContact own1 WITH(NOLOCK) ON own1.CRMContactId = POWN2.CRMContactId                    
left join [CRM]..TCRMContact own2 WITH(NOLOCK) ON own2.CRMContactId = POWN2.CRMContactId2                    
-- Latest valuation                    
LEFT JOIN (                    
SELECT          
PolicyBusinessId, Max(PlanValuationId) AS PlanValuationId                    
FROM                     
PolicyManagement..TPlanValuation                    
GROUP BY                     
PolicyBusinessId                    
) AS LastVal ON LastVal.PolicyBusinessId = Pb.PolicyBusinessId                      
LEFT JOIN PolicyManagement..TPlanValuation Val ON Val.PlanValuationId = LastVal.PlanValuationId                    
-- Fund Price                    
LEFT JOIN (                    
SELECT                       
PolicyBusinessId,                    
SUM(ISNULL(CurrentPrice, 0) * ISNULL(CurrentUnitQuantity, 0)) AS FundValue                    
FROM                    
PolicyManagement..TPolicyBusinessFund WITH(NOLOCK)                     
GROUP BY PolicyBusinessId                    
) AS Fund ON Fund.PolicyBusinessId = Pb.PolicyBusinessId                    
-- Look for single contribution                    
LEFT JOIN (                    
SELECT           
PolicyBusinessId,                    
COUNT(*) AS Number                    
FROM                  
PolicyManagement..TPolicyMoneyIn WITH(NOLOCK)                        
GROUP BY                    
PolicyBusinessId                    
) AS Contributions ON Contributions.PolicyBusinessId = Pb.PolicyBusinessId          
where pb.policybusinessid in (Select ParsedValue From @ParsedValues)
GO
