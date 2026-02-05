SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[SpNioCustomPensionDetailsById]    
 @PolicyBusinessId BIGINT,    
 @TenantId BIGINT     
AS    

BEGIN    
  
  SET NOCOUNT ON;      
      
            
       Declare @ClientTotalLumpSum decimal(10,2)
       Declare @ClientRegularPremium decimal(10,2)
       Declare @ClientPremiumFrequencyType varchar(100)
       Declare @ClientTotalTransferAmount decimal(10,2)
       
       Declare @EmployerTotalLumpSum decimal(10,2)
       Declare @EmployerRegularPremium decimal(10,2)
       Declare @EmployerPremiumFrequencyType varchar(100)
       
     


Declare @Regular bigint = 1
Declare @LumpSum bigint = 2
Declare @Transfer bigint = 3

Declare @Self bigint = 1
Declare @Employer bigint = 2
       
       --Client Lump Sum
       Select @ClientTotalLumpSum = SUM(Amount) from TPolicyMoneyIn A
       Where A.PolicyBusinessId = @PolicyBusinessId
       And A.RefContributorTypeId = @Self
       And A.RefContributionTypeId = @LumpSum
       
       --Client Regular
       Select Top 1 
			@ClientRegularPremium = Amount, 
			@ClientPremiumFrequencyType = B.FrequencyName
	   from TPolicyMoneyIn A
       Inner join TRefFrequency B ON A.RefFrequencyId = B.RefFrequencyId
       Where A.PolicyBusinessId = @PolicyBusinessId
       And A.RefContributorTypeId = @Self
       And A.RefContributionTypeId = @Regular
       
       --Client Transfer
       Select @ClientTotalTransferAmount = SUM(Amount) from TPolicyMoneyIn A
       Where A.PolicyBusinessId = @PolicyBusinessId
       And A.RefContributorTypeId = @Self
       And A.RefContributionTypeId = @Transfer
       
       --Employer Lump Sum
       Select @EmployerTotalLumpSum = SUM(Amount) from TPolicyMoneyIn A
       Where A.PolicyBusinessId = @PolicyBusinessId
       And A.RefContributorTypeId = @Employer
       And A.RefContributionTypeId = @LumpSum
       
       
       --Employer Regular
       Select Top 1 
			@EmployerRegularPremium = Amount, 
			@EmployerPremiumFrequencyType = B.FrequencyName
	   from TPolicyMoneyIn A
       Inner join TRefFrequency B ON A.RefFrequencyId = B.RefFrequencyId
       Where A.PolicyBusinessId = @PolicyBusinessId
       And A.RefContributorTypeId = @Employer
       And A.RefContributionTypeId = @Regular
       
     
	     
	      
	SELECT       
		P.PolicyBusinessId,      
		P.SequentialRef,      
		P.IndigoClientId,      
		PractC.CRMContactId AS SellingAdviserPartyId,    

		CASE    
		WHEN PractC.PersonId IS NOT NULL THEN PractC.FirstName + ' ' + PractC.LastName    
		ELSE PractC.CorporateName    
		END AS SellingAdviser,    
		    
		CASE      
		WHEN O1C.TrustId IS NOT NULL THEN 1       
		ELSE 0    
		END AS IsPrimaryOwnerTrust,    

		T1Type.TrustTypeName AS  TrustType,    
		po.CRMContactId AS  PrimaryOwnerPartyId,       

		CASE      
		WHEN O1C.PersonId IS NOT NULL THEN O1C.FirstName + ' ' + O1C.LastName        
		ELSE O1C.CorporateName      
		END AS PrimaryOwnerName,      

		CASE      
		WHEN O1C.PersonId IS NOT NULL THEN O1C.DOB       
		ELSE NULL    
		END AS PrimaryOwnerDoB,    

		po2.CRMContactId AS  SecondaryOwnerPartyId,      

		CASE      
		WHEN O2C.PersonId IS NOT NULL THEN O2C.FirstName + ' ' + O2C.LastName        
		ELSE O2C.CorporateName      
		END AS SecondaryOwnerName,      

		CASE      
		WHEN O2C.PersonId IS NOT NULL THEN O2C.DOB       
		ELSE NULL    
		END AS SecondaryOwnerDoB,    

		PR.Name AS ProviderName,      
		PR.RefProdProviderId AS ProviderId,      
		PSB.RefPlanType2ProdSubTypeId AS ProductTypeId,      
		PT.PlanTypeName AS PlanTypeName,      
		ST.ProdSubTypeName AS ProductSubTypeName,      
		P.PolicyNumber AS PolicyNumber,      
		S.Name AS [Status],      
	 
	 
		@ClientTotalLumpSum as ClientTotalLumpSum,
		@ClientRegularPremium as ClientRegularPremium,
		@ClientPremiumFrequencyType  as ClientPremiumFrequencyType,
		@ClientTotalTransferAmount  as ClientTotalTransferAmount,

		@EmployerTotalLumpSum  as EmployerTotalLumpSum,
		@EmployerRegularPremium as EmployerRegularPremium,
		@EmployerPremiumFrequencyType as EmployerPremiumFrequencyType 	 
	      
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
		A.PolicyDetailId      
		FROM policymanagement..tpolicyowner    A
		Inner join TPolicyBusiness B ON A.PolicyDetailId = B.PolicyDetailId     
		Where B.PolicyBusinessId = @PolicyBusinessId      
		GROUP BY A.PolicyDetailId        
	) Owners ON Owners.PolicyDetailId = D.PolicyDetailId      
	          
	JOIN policymanagement..tpolicyowner po ON po.PolicyOwnerId = Owners.PolicyOwnerId1      
	JOIN CRM..TCRMContact O1C ON O1C.CRMContactId = po.CRMContactId      
	LEFT JOIN CRM..TTrust T1 ON T1.TrustId = O1C.TrustId    
	LEFT JOIN CRM..TRefTrustType T1Type ON T1Type.RefTrustTypeId = T1.RefTrustTypeId    
	LEFT JOIN policymanagement..tpolicyowner po2 ON po2.PolicyOwnerId = Owners.PolicyOwnerId2      
	AND (Owners.PolicyOwnerId2 != Owners.PolicyOwnerId1)      
	LEFT JOIN CRM..TCRMContact O2C ON O2C.CRMContactId = po2.CRMContactId      
	JOIN CRM..TPractitioner Pract ON Pract.PractitionerId = p.PractitionerId    
	JOIN CRM..TCRMContact PractC ON PractC.CRMContactId = Pract.CRMContactId    
	        
	WHERE P.PolicyBusinessId = @PolicyBusinessId       
	   AND P.IndigoClientId = @TenantId      
	   AND S.IntelligentOfficeStatusType <> 'Deleted'      
	   And Sh.CurrentStatusFG = 1    
END      


GO
