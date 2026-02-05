SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  [dbo].[FnCustomRetrievePlanPurposes](@PolicyBusinessId int)
RETURNS VARCHAR(255)
AS
BEGIN
	DECLARE @PlanPurposes VARCHAR(255)
	
	SELECT 
		@PlanPurposes = ISNULL(@PlanPurposes + ', ', '') + TP.Descriptor
	FROM	
		PolicyManagement..TPolicyBusinessPurpose TPBP
		JOIN PolicyManagement..TPlanPurpose TP ON TP.PlanPurposeId = TPBP.PlanPurposeId 
	WHERE 
		TPBP.PolicyBusinessId = @PolicyBusinessId
	
	RETURN (@PlanPurposes)
END
GO
