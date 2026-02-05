SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dbo].[nio_FileCheck_spCustomRetrievePolicyBusinessForTQCRecent]        
   @TnCCoachPartyId bigint ,@TenantId bigint       
AS      
  
DECLARE @TnCCoachId bigint  
  
SET @TnCCoachId=(SELECT B.TnCCoachId FROM Administration..TUser A JOIN Compliance..TTnCCoach B ON A.UserId=B.UserId WHERE A.CRMContactId=@TnCCoachPartyId)  
    
SELECT
	 TPB.PolicyBusinessId,    
	 TPB.PolicyNumber,  
	 TPB.SequentialRef,  
	 TPB.BaseCurrency,  
	 TPB.TotalLumpSum,  
	 TPB.TotalRegularPremium,  
	 @TnCCoachPartyId AS TnCCoachCRMContactId,        
	 TP.CRMContactId AS AdviserCRMContactId,   
	 TPO2.CRMContactId AS PolicyOwnerCRMContactId,  
	 TCC2.CorporateName AS ProviderName,           
	 convert(varchar(10),TSH.ChangedToDate,103) AS SubmittedToProviderDate,   
	 TPDS.RefPlanType2ProdSubTypeId AS RefPlanType2ProdSubTypeId,  
	 TPB.IndigoClientId,  
	 TS.[Name] AS CurrentStatus,  
	 CASE TPO1.MaxPolicyBusinessId-TPO1.PolicyBusinessId  
		  WHEN 0 THEN 0  
		  ELSE 1  
	 END AS IsTopUp,
	 AT.[Description] AS AdviceTypeName  
FROM          
	TPolicyBusiness TPB  
	JOIN         
	(
	SELECT 
		MIN(TPO.PolicyOwnerId) AS PolicyOwnerId,        
		TPO.PolicyDetailId,        
		MIN(TPB1.MinPolicyBusinessId) AS PolicyBusinessId ,  
		MIN(TPB1.MaxPolicyBusinessId) AS MaxPolicyBusinessId       
	FROM 
		TPolicyOwner TPO
		JOIN 
		(
			SELECT 
				PolicyDetailId,        
				MIN(PolicyBusinessId) AS MinPolicyBusinessId,
				MAX(PolicyBusinessId) AS MaxPolicyBusinessId        
			FROM 
				TPolicyBusiness         
			WHERE 
				TnCCoachId= @TnCCoachId        
			GROUP BY 
				PolicyDetailId        
		 ) TPB1 ON TPB1.PolicyDetailId = TPO.PolicyDetailId        
	GROUP BY 
		TPO.PolicyDetailId 
	) TPO1 ON TPO1.PolicyDetailId =  TPB.PolicyDetailId        
	--CRM Contact        
	JOIN TPolicyOwner TPO2 ON TPO2.PolicyOwnerId = TPO1.PolicyOwnerId        
	JOIN TPolicyDetail TPD ON TPD.PolicyDetailId = TPO1.PolicyDetailId               
	JOIN [CRM].[dbo].TPractitioner TP ON TP.PractitionerId = TPB.PractitionerId  
	JOIN TStatusHistory TSH ON TSH.PolicyBusinessId = TPB.PolicyBusinessId AND TSH.CurrentStatusFg = 1       
	JOIN TStatus TS ON TS.StatusId = TSH.StatusId AND TS.PostComplianceCheck = 1
	-- BAU-1317: Only cases that have been through the pre-compliance status should be included
	JOIN TStatusHistory PreComplianceStatusHistory ON PreComplianceStatusHistory.PolicyBusinessId = TPB.PolicyBusinessId
	JOIN TStatus PreComplianceStatus ON PreComplianceStatus.StatusId = PreComplianceStatusHistory.StatusId 
		AND PreComplianceStatus.PreComplianceCheck = 1
	JOIN TPlanDescription TPDS ON TPDS.PlanDescriptionId = TPD.PlanDescriptionId           
	JOIN TRefProdProvider TRPP ON TRPP.RefProdProviderId = TPDS.RefProdProviderId           
	JOIN [CRM].[dbo]. TCRMContact TCC2 ON  TCC2.CRMContactId = TRPP.CRMContactId
	JOIN policymanagement..TAdviceType AT ON AT.AdviceTypeId = TPB.AdviceTypeId          
	LEFT JOIN    
	(    
		SELECT 
			PolicyBusinessId,
			A.FileCheckMiniId    
		FROM 
			Compliance..TFileCheckMini A WITH(NOLOCK)    
			LEFT JOIN  
			(  
				SELECT 
					A.FileCheckMiniId,
					B.FileCheckCaseStatusId,
					B.StatusName  
				FROM 
					Compliance..TFileCheckCaseStatusHistory A WITH(NOLOCK)  
					JOIN Compliance..TFileCheckCaseStatus B WITH(NOLOCK) ON A.FileCheckCaseStatusId=B.FileCheckCaseStatusId AND A.IsCurrent=1  
			) HIST ON A.FileCheckMiniId=Hist.FileCheckMiniId
		WHERE 
			A.IsPreSale=1    
			AND A.IsArchived=1    
			AND ISNULL(Hist.StatusName,'Not Checked')='Not Checked'    
	) FCM ON TPb.PolicyBusinessId=FCM.PolicyBusinessId    
WHERE 
	TPB.TnCCoachId=@TnCCoachId     
	AND TPB.IndigoClientId=@TenantId        
	AND ISNULL(FCM.FileCheckMiniId,0)=0    
ORDER BY 
	TSH.DateOfChange desc          
GO
