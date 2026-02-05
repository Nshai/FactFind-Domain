SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNioCustomPolicyBusinessDetailsById]    
 @PolicyBusinessId BIGINT,    
 @TenantId BIGINT     
AS    
BEGIN      
  SET NOCOUNT ON;      

Declare @PolicyDetailId bigint, @OriginalPolicyBusinessId bigint, @WrapProviderId bigint, @PortalReference varchar(255)  
Declare @WrapPolicyBusinessId bigint, @WrapPolicyNumber varchar(255), @OriginalPolicyNumber varchar(255)      
Declare @QuoteResultId bigint, @QuoteReference varchar(255)
Declare @IsATop bit
Declare @TenantGroupName varchar(255)
Declare @QuoteExpiry datetime, @QuoteProductTypeId bigint
Declare @FundIncome varchar(50)
  
Select @PolicyDetailId = PolicyDetailId From TPolicyBusiness Where PolicyBusinessId = @PolicyBusinessId And IndigoClientId = @TenantId      
Select @OriginalPolicyBusinessId = Min(PolicyBusinessId) From TPolicyBusiness Where PolicyDetailId = @PolicyDetailId And IndigoClientId = @TenantId      


Select
	@IsATop = CASE WHEN @PolicyBusinessId != MIN(PB.PolicyBusinessId) THEN 1 ELSE 0 END
From   
	PolicyManagement.dbo.TPolicyDetail PD
	JOIN PolicyManagement.dbo.TPolicyBusiness PB ON PB.PolicyDetailId = PD.PolicyDetailId
Where  
	PD.PolicyDetailId = @PolicyDetailId
Group By
	PD.PolicyDetailId

      
Select @WrapPolicyBusinessId = Wrap.ParentPolicyBusinessId , @WrapPolicyNumber = WP.PolicyNumber,     
@OriginalPolicyNumber = WP2.PolicyNumber, @WrapProviderId = WPD.RefProdProviderId    
From TPolicyBusiness WP2      
Left Join TWrapperPolicyBusiness Wrap On Wp2.PolicyBusinessId = Wrap.PolicyBusinessId       
Left JOIN TPolicyBusiness WP ON Wrap.ParentPolicyBusinessId = WP.PolicyBusinessId      
LEFT JOIN TPolicyDetail WD ON WP.PolicyDetailId = WD.PolicyDetailId      
LEFT JOIN TPlanDescription WPD ON WD.PlanDescriptionId = WPD.PlanDescriptionId      
Where  WP2.PolicyBusinessId = @OriginalPolicyBusinessId   
  
Select @PortalReference = PortalReference, @QuoteResultId = QuoteResultId, @FundIncome = FundIncome
From TPolicyBusinessExt Where PolicyBusinessId = @PolicyBusinessId  


Select @TenantGroupName = TenantGroupName
From Administration..TRefTenantGroup a
Inner Join Administration..TTenant2RefTenantGroup b on a.RefTenantGroupId = b.RefTenantGroupId
Where b.TenantId = @TenantId

  
Select @QuoteReference = r.QuoteReference, @QuoteResultId = ISNULL(@QuoteResultId,  r.QuoteResultId),
	   @QuoteExpiry = r.ExpiryDate, @QuoteProductTypeId = q.RefProductTypeId
From TQuote q
Join TQuoteResult r on q.QuoteId = r.QuoteId
Where PolicyBusinessId   = @PolicyBusinessId    
      
SELECT       
 P.PolicyBusinessId,      
 P.SequentialRef,      
 P.IndigoClientId,      
 PractC.CRMContactId AS SellingAdviserPartyId,    
   
 CASE    
 WHEN PractC.PersonId IS NOT NULL THEN PractC.FirstName+' '+PractC.LastName    
 ELSE PractC.CorporateName    
 END AS SellingAdviser,    
        
 CASE      
 WHEN O1C.TrustId IS NOT NULL       
 THEN 1       
 ELSE 0    
 END AS IsPrimaryOwnerTrust,    
  
 T1Type.TrustTypeName AS  TrustType,    
 po.CRMContactId AS  PrimaryOwnerPartyId,       
 
 CASE      
 WHEN O1C.PersonId IS NOT NULL       
 THEN P1.Title
 ELSE NULL     
 END AS PrimaryOwnerTitle,

 CASE      
 WHEN O1C.PersonId IS NOT NULL       
 THEN O1C.FirstName+' '+O1C.LastName        
 ELSE O1C.CorporateName      
 END AS PrimaryOwnerName,      
   
 CASE      
 WHEN O1C.PersonId IS NOT NULL       
 THEN O1C.DOB       
 ELSE NULL    
 END AS PrimaryOwnerDoB,    
  
 CASE      
 WHEN O1C.PersonId IS NOT NULL       
 THEN P1.GenderType     
 ELSE NULL    
 END AS PrimaryOwnerGender,   

 CASE      
 WHEN O1C.PersonId IS NOT NULL       
 THEN P1.NINumber
 ELSE NULL     
 END AS PrimaryOwnerNINumber,

 CASE      
 WHEN O1C.CRMContactId IS NOT NULL       
 THEN (SELECT TOP 1 c.Value FROM crm..TContact c
  WHERE c.CRMContactId = O1C.CrmContactId and c.DefaultFg = 1 and c.RefContactType in ('Telephone', 'Mobile')
  ORDER BY c.RefContactType desc)
 ELSE NULL     
 END AS PrimaryOwnerPhoneNumber,

 po2.CRMContactId AS  SecondaryOwnerPartyId,      
 
 CASE      
 WHEN O2C.PersonId IS NOT NULL       
 THEN P2.Title
 ELSE NULL     
 END AS SecondaryOwnerTitle,

 CASE      
 WHEN O2C.PersonId IS NOT NULL       
 THEN O2C.FirstName+' '+O2C.LastName        
 ELSE O2C.CorporateName      
 END AS SecondaryOwnerName,      
   
 CASE      
 WHEN O2C.PersonId IS NOT NULL       
 THEN O2C.DOB       
 ELSE NULL    
 END AS SecondaryOwnerDoB,    
 
 CASE      
 WHEN O2C.PersonId IS NOT NULL       
 THEN P2.GenderType     
 ELSE NULL    
 END AS SecondaryOwnerGender,   

 CASE      
 WHEN O2C.PersonId IS NOT NULL       
 THEN P2.NINumber
 ELSE NULL     
 END AS SecondaryOwnerNINumber,

 CASE      
 WHEN O2C.CRMContactId IS NOT NULL       
 THEN (SELECT TOP 1 c.Value FROM crm..TContact c
  WHERE c.CRMContactId = O2C.CrmContactId and c.DefaultFg = 1 and c.RefContactType in ('Telephone', 'Mobile')
  ORDER BY c.RefContactType desc)
 ELSE NULL     
 END AS SecondaryOwnerPhoneNumber,

 PR.Name AS ProviderName,      
 PR.RefProdProviderId AS ProviderId,      
 PSB.RefPlanType2ProdSubTypeId AS ProductTypeId,      
 PT.PlanTypeName AS PlanTypeName,      
 ST.ProdSubTypeName AS ProductSubTypeName,      
 P.PolicyNumber AS PolicyNumber,      
 S.Name AS [Status],      
 @WrapPolicyBusinessId AS WrapId,      
 @WrapPolicyNumber AS WrapNumber,      
 @WrapProviderId AS WrapProviderId,    
 @OriginalPolicyBusinessId AS OriginalPolicyId,      
 @OriginalPolicyNumber AS OriginalPolicyNumber,    
 P.TotalLumpSum,      
 P.TotalRegularPremium,      
 P.PremiumType,  
 @PortalReference AS PortalReference,  
  
 CASE  
 WHEN IsNull(P.SwitchFG,0) = 1  
 THEN 1  
 ELSE 0  
 END AS IsSwitched,  
 @QuoteResultId As QuoteResultId,
 @IsATop As IsATopUp,
 @QuoteReference As QuoteReference,
 IsNull(@TenantGroupName,'') As TenantGroupName,
 @PolicyDetailId As PolicyDetailId,
 @QuoteExpiry as QuoteExpiry,
 @QuoteProductTypeId as QuoteProductTypeId,
 @FundIncome as FundIncome
FROM TPolicyBusiness P      
JOIN TPolicyDetail D ON P.PolicyDetailId = D.PolicyDetailId      
JOIN TPlanDescription PD ON D.PlanDescriptionId = PD.PlanDescriptionId      
LEFT JOIN VProvider PR ON PD.RefProdProviderId = PR.RefProdProviderId      
LEFT JOIN TRefPlanType2ProdSubType PSB ON PD.RefPlanType2ProdSubTypeId = PSB.RefPlanType2ProdSubTypeId      
JOIN TRefPlanType PT ON PSB.RefPlanTypeId = PT.RefPlanTypeId      
LEFT JOIN TProdSubType ST ON PSB.ProdSubTypeId = ST.ProdSubTypeId      
JOIN TStatusHistory SH ON P.PolicyBusinessId = SH.PolicyBusinessId      
JOIN TStatus S ON SH.StatusId = S.StatusId      
JOIN      
    (      
    SELECT      
   MIN(PolicyOwnerId) AS PolicyOwnerId1,   
   MAX(PolicyOwnerId) AS PolicyOwnerId2,      
   PolicyDetailId      
    FROM policymanagement..tpolicyowner         
    Where PolicyDetailId = @PolicyDetailId      
    GROUP BY PolicyDetailId      
    ) Owners ON Owners.PolicyDetailId = D.PolicyDetailId      
          
JOIN policymanagement..tpolicyowner po ON po.PolicyOwnerId = Owners.PolicyOwnerId1      
JOIN CRM..TCRMContact O1C ON O1C.CRMContactId = po.CRMContactId 
LEFT JOIN CRM..TPerson P1 ON P1.PersonId = O1C.PersonId         
LEFT JOIN CRM..TTrust T1 ON T1.TrustId = O1C.TrustId    
LEFT JOIN CRM..TRefTrustType T1Type ON T1Type.RefTrustTypeId = T1.RefTrustTypeId    
LEFT JOIN policymanagement..tpolicyowner po2 ON po2.PolicyOwnerId = Owners.PolicyOwnerId2      
AND (Owners.PolicyOwnerId2 != Owners.PolicyOwnerId1)      
LEFT JOIN CRM..TCRMContact O2C ON O2C.CRMContactId = po2.CRMContactId      
LEFT JOIN CRM..TPerson P2 ON P2.PersonId = O2C.PersonId  
JOIN CRM..TPractitioner Pract ON Pract.PractitionerId = p.PractitionerId    
JOIN CRM..TCRMContact PractC ON PractC.CRMContactId = Pract.CRMContactId    

WHERE P.PolicyBusinessId = @PolicyBusinessId       
   AND P.IndigoClientId = @TenantId      
   AND S.IntelligentOfficeStatusType <> 'Deleted'      
   And Sh.CurrentStatusFG = 1    

END      

GO

