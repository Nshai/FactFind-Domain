SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_spCustomRetrievePlansForPractitioner]
	(		
		@AdviserCRMContactId bigint	
	)

AS

SELECT
    T3.PolicyBusinessId AS [PlanId],
    T3.SequentialRef AS [SequentialRef],
    T3.PolicyNumber AS [Number], 
    T5.Name AS [Status], 
    T5.StatusId AS [StatusId], 
    T8.RefPlanTypeId as [RefPlanTypeId],
    
    --T8.PlanTypeName AS [Name],  
    Case  
		When (T11.ProdSubTypeName) Is Not Null 
		Then  T8.PlanTypeName + '  (' + ISNULL(T11.ProdSubTypeName, '')  + ')'  
		Else  T8.PlanTypeName   
	End As [Name],
	
    T10.CorporateName AS [Provider], 
    T3.PolicyBusinessId AS [PolicyBusinessId], 
    T1.PolicyDetailId AS [PolicyDetailId] ,
    Case When T3.PolicyBusinessId = TPB.PolicyBusinessId Then 0 Else 1 End AS [IsTopUp],
    ISNULL(T11.ProdSubTypeName,'') AS [ProdSubTypeName],
--    Convert(varchar(10),T4.ChangedToDate,103) AS [Plan!1!ChangedToDate],
    T4.ChangedToDate AS [ChangedToDate],
    T13.CRMContactId AS [CRMContactId],
    T14.CRMContactType AS [CRMContactType],
    CASE
		WHEN T14.CRMContactType = 1 THEN (T14.FirstName + ' ' + T14.LastName)
		WHEN T14.CRMContactType in (2,3,4) THEN (T14.CorporateName)
    END AS  [ClientName],
    ISNULL(T14.LastName, '') AS [ClientLastName], 
    ISNULL(T14.FirstName, '') AS [ClientFirstName], 
    ISNULL(T14.CorporateName, '') AS [CorporateName], 
    ISNULL(T14.AdvisorRef, '') AS [ClientRef]
  FROM TPolicyDetail T1 
  INNER JOIN (
                   Select Min(T1.PolicyOwnerId) as PolicyOwnerId, T1.PolicyDetailId From TPolicyOwner T1 
                   INNER JOIN TPolicyDetail T2 ON T1.PolicyDetailId = T2.PolicyDetailId 
                   INNER JOIN TPolicyBusiness T3 ON T3.PolicyDetailId = T2.PolicyDetailId
                   
                   INNER JOIN CRM.dbo.TPractitioner T4  ON T4.PractitionerId = T3.PractitionerId  
				   INNER JOIN CRM.dbo.TCRMContact T5 ON T5.CRMContactId = T4.CRMContactId  
                   
                   WHERE T4.CRMContactId = @AdviserCRMContactId --T3.PractitionerId= @PractitionerId             
                   
                   Group By T1.PolicyDetailId

  ) T2 ON T1.PolicyDetailId = T2.PolicyDetailId 
  INNER JOIN TPolicyOwner T13 ON T13.PolicyOwnerId = T2.PolicyOwnerId
  INNER JOIN [CRM].[dbo].[TCRMContact] T14 ON T14.CRMContactId = T13.CRMContactId
  
  INNER JOIN TPolicyBusiness T3 ON T1.PolicyDetailId = T3.PolicyDetailId --AND T3.PractitionerId = @PractitionerId
  
  -- By PJ
  INNER JOIN CRM.dbo.TPractitioner T3_1  ON T3_1.PractitionerId = T3.PractitionerId  
  INNER JOIN CRM.dbo.TCRMContact T3_2 ON T3_2.CRMContactId = T3_1.CRMContactId  AND T3_1.CRMContactId = @AdviserCRMContactId
  --end
  
  INNER JOIN TStatusHistory T4 ON T3.PolicyBusinessId = T4.PolicyBusinessId AND T4.CurrentStatusFG = 1
  INNER JOIN TStatus T5 ON T4.StatusId = T5.StatusId AND T5.IntelligentOfficeStatusType <> 'Deleted'
  INNER JOIN TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId 
  INNER JOIN TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId AND T7.IsArchived = 0
  LEFT JOIN TProdSubType T11 ON T7.ProdSubTypeId=T11.ProdSubTypeId
  INNER JOIN TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId 
  INNER JOIN TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId 
  INNER JOIN [CRM].[dbo].TCRMContact T10 ON  T9.CRMContactId = T10.CRMContactId
  INNER JOIN (SELECT PolicyDetailId,
	Min(PolicyBusinessId) AS PolicyBusinessId 
      	From TPolicyBusiness 
      	Group By PolicyDetailId) AS TPB 
   ON	TPB.PolicyDetailId = T1.PolicyDetailId
GO
