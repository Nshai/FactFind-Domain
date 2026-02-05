SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrievePlanPurposesForRefOpportunityType2ProdSubTypeId] 
	@IndigoClientId bigint, 
	@RefOpportunityType2ProdSubTypeId bigint
AS
DECLARE @OpportunityTypeName varchar(255), @ProdSubTypeId int
DECLARE @RefPlanTypeId varchar(255), @RefPlanType2ProdSubTypeId int
-------------------------------------------------------
-- Find Opportunity and Product Sub Type details.
-------------------------------------------------------
SELECT 
	@OpportunityTypeName = T.OpportunityTypeName,
	@ProdSubTypeId = A.ProdSubTypeId
FROM 
	CRM..TRefOpportunityType2ProdSubType A
	JOIN CRM..TOpportunityType T ON T.OpportunityTypeId = A.OpportunityTypeId
WHERE 
	RefOpportunityType2ProdSubTypeId = @RefOpportunityType2ProdSubTypeId
	AND T.IndigoClientId = @IndigoClientId

SET @RefPlanTypeId = CASE @OpportunityTypeName 
	WHEN 'Mortgage' THEN 63
	WHEN 'Mortgage(Non-Regulated)' THEN 1039
END

SELECT @RefPlanType2ProdSubTypeId = RefPlanType2ProdSubTypeId
FROM PolicyManagement..TRefPlanType2ProdSubType
WHERE RefPlanTypeId = @RefPlanTypeId AND ProdSubTypeId = @ProdSubTypeId

IF @RefPlanType2ProdSubTypeId IS NULL
	RETURN NULL

SELECT NULL,
	(
	SELECT
		A.Descriptor AS [id], 
		A.Descriptor AS [value]
	FROM 
		Policymanagement..TPlanPurpose A
		JOIN Policymanagement..TPlanTypePurpose B on B.PlanPurposeId = A.PlanPurposeId
	WHERE 
		A.IndigoClientId = @IndigoClientId 
		AND B.RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId
	ORDER BY A.Descriptor
	FOR XML RAW('PlanPurpose'), TYPE)
FOR XML PATH('PlanPurposes')

