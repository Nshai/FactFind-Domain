SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
	
CREATE PROCEDURE [dbo].[SpNCustomRetrievePlanTypesForExistingProvision]
	@IndigoClientId bigint = null,
	@RegionCode varchar(2) = 'GB'
AS 
   DECLARE @RegulatedPlanType VARCHAR(100) = 'Mortgage'
   DECLARE @NonRegulatedPlanType VARCHAR(100) = 'Mortgage - Non-Regulated'
   DECLARE @ConveyancingServicingPlanPlanType VARCHAR(100) = 'Conveyancing Servicing Plan'
   DECLARE @LoanPlanType VARCHAR(20) = 'Loan'

   SELECT 1 AS TAG,  
		  NULL AS Parent,  
		  P2P.RefPlanType2ProdSubTypeId  AS [MortgagePlanType!1! MortgagePlanTypeId],  
		   CASE WHEN PST.ProdSubTypeId in (33,1046,1073,1003,1076,1077,1078,1090,1002,1177) 
			   THEN 
			   CASE WHEN RPT.PlanTypeName = @RegulatedPlanType
					THEN PST.ProdSubTypeName + ' (Regulated)'
					ELSE PST.ProdSubTypeName + ' (Non-Regulated)'
			   END
			   WHEN RPT.PlanTypeName = @ConveyancingServicingPlanPlanType
			   THEN RPT.PlanTypeName
			   ELSE PST.ProdSubTypeName
		  END AS [MortgagePlanType!1!MortgagePlanTypeName] 
   FROM policymanagement..TRefPlanType2ProdSubType as P2P		
		 LEFT JOIN policymanagement..TProdSubType as PST
			ON P2P.ProdSubTypeId = PST.ProdSubTypeId
		 INNER JOIN policymanagement..TRefPlanType as RPT
			ON P2P.RefPlanTypeId = RPT.RefPlanTypeId
   WHERE 
   RPT.PlanTypeName IN (@RegulatedPlanType,@NonRegulatedPlanType,@ConveyancingServicingPlanPlanType, @LoanPlanType)
				AND P2P.IsArchived = 0
				AND P2P.RegionCode = @RegionCode
   ORDER BY [MortgagePlanType!1!MortgagePlanTypeName]  
  
FOR XML EXPLICIT
GO
