SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrievePlanPurposesForRefPlan2ProdSubTypeId] 
	@IndigoClientId bigint, 
	@RefPlan2ProdSubTypeId bigint
AS
SELECT NULL,
	(
	SELECT
		A.PlanPurposeId AS [id], 
		A.Descriptor AS [value]
	FROM 
		Policymanagement..TPlanPurpose A
		JOIN Policymanagement..TPlanTypePurpose B on B.PlanPurposeId = A.PlanPurposeId
	WHERE 
		A.IndigoClientId = @IndigoClientId 
		AND B.RefPlanType2ProdSubTypeId = @RefPlan2ProdSubTypeId
	ORDER BY A.Descriptor
	FOR XML RAW('PlanPurpose'), TYPE)
FOR XML PATH('PlanPurposes')
GO
