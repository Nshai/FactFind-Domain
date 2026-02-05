SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveMortgagePlanPurposes]
	@IndigoClientId bigint  
AS      
SELECT 
	B.[PlanPurposeId],  
	B.[Descriptor] AS [PlanPurpose]
FROM 
	TPlanTypePurpose A  
	JOIN TPlanPurpose B ON A.PlanPurposeId=B.PlanPurposeId
	JOIN TRefPlanType2ProdSubType C ON C.RefPlanType2ProdSubTypeId = A.RefPlanType2ProdSubTypeId
WHERE 
	B.IndigoClientId=@IndigoClientId
	AND C.RefPlanTypeId = 63 AND C.ProdSubTypeId IS NULL -- Mortgage	
ORDER BY 
	B.[Descriptor]
FOR XML RAW('MortgagePurpose')
GO
