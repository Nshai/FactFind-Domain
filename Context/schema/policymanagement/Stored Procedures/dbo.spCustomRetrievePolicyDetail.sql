SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[spCustomRetrievePolicyDetail] @PolicyDetailId bigint
AS

/*
This is a custom stored procedure to improve performance.  Using the Data Accessor we would need
to relate across possibly 9 tables which gives us a huge overhead for a relatively simple operation
*/
BEGIN
    SELECT
	    1 AS Tag,
	    NULL AS Parent,
	    T3.PolicyNumber AS [Plan!1!PolicyBusinessNumberForFirstPolicyBusiness], 
	    T5.Name AS [Plan!1!Status], 
	    T8.PlanTypeName AS [Plan!1!PlanTypeName],  
	    T10.CorporateName AS [Plan!1!ProductProviderName], 
	    T3.PolicyBusinessId AS [Plan!1!PolicyBusinessId], 
	    T1.PolicyDetailId AS [Plan!1!PolicyDetailId],
	    isnull(T11.ProdSubTypeName,'') as [Plan!1!ProdSubTypeName]
	FROM TPolicyDetail T1 
	INNER JOIN TPolicyOwner T2 ON T1.PolicyDetailId = T2.PolicyDetailId 
	INNER JOIN TPolicyBusiness T3 ON T1.PolicyDetailId = T3.PolicyDetailId 
	INNER JOIN TStatusHistory T4 ON T3.PolicyBusinessId = T4.PolicyBusinessId 
	INNER JOIN TStatus T5 ON T4.StatusId = T5.StatusId 
	INNER JOIN TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId 
	INNER JOIN TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId 
	LEFT JOIN TProdSubType T11 ON T7.ProdSubTypeId=T11.ProdSubTypeId
	INNER JOIN TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId
	INNER JOIN TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId 
	INNER JOIN [CRM].[dbo].TCRMContact T10 ON  T9.CRMContactId = T10.CRMContactId
  
  	WHERE (T1.PolicyDetailId= @PolicyDetailId)

	FOR XML EXPLICIT
END







GO
