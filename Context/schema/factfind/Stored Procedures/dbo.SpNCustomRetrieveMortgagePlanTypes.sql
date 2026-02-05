SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
	
CREATE PROCEDURE [dbo].[SpNCustomRetrieveMortgagePlanTypes]
	@IndigoClientId BIGINT = NULL,
	@TenantRegionCode VARCHAR(2) = 'GB'
AS 
   DECLARE @RegulatedOpportunityType VARCHAR(100) = 'Mortgage',
		   @NonRegulatedOpportunityType VARCHAR(100) = 'Mortgage(Non-Regulated)',
		   @StandardPlanTypeName VARCHAR(100) = 'Standard residential';			   

   SELECT 1 AS TAG,  
		  NULL AS Parent,  
		  O2P.RefOpportunityType2ProdSubTypeId  AS [RefMortgagePlanType!1! RefMortgagePlanTypeId],  
		  CASE WHEN PST.ProdSubTypeId = 33 
			   THEN 
			   CASE WHEN OT.OpportunityTypeName = @RegulatedOpportunityType
					THEN PST.ProdSubTypeName + ' (Regulated)'
					ELSE PST.ProdSubTypeName + ' (Non-Regulated)'
			   END
			   ELSE PST.ProdSubTypeName
		  END AS [RefMortgagePlanType!1!MortgagePlanType] 
   FROM  crm..TRefOpportunityType2ProdSubType as O2P		
		 INNER JOIN policymanagement..TProdSubType as PST
			ON O2P.ProdSubTypeId = PST.ProdSubTypeId
		 INNER JOIN crm..TOpportunityType as OT
			ON O2P.OpportunityTypeId = OT.OpportunityTypeId
   WHERE OT.OpportunityTypeName IN (@RegulatedOpportunityType,@NonRegulatedOpportunityType) 
		 AND  OT.IndigoClientId = @IndigoClientId
		 AND PST.ProdSubTypeName IS NOT NULL
		 AND O2P.IsArchived = 0
		 AND (@TenantRegionCode = 'GB' 
			OR (@TenantRegionCode = 'AU' AND PST.ProdSubTypeName = @StandardPlanTypeName))
   ORDER BY [RefMortgagePlanType!1!MortgagePlanType]  
  
FOR XML EXPLICIT
GO
