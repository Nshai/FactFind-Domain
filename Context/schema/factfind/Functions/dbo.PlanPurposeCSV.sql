SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[PlanPurposeCSV](@PolicyBusinessId BIGINT)

RETURNS VARCHAR(1000) AS  
BEGIN 

DECLARE @PlanPurposes varchar(1000)
SET @PlanPurposes = ''

-- Get a comma delimited lisit of plan puposes for the PolicyBusinessId supplied
SELECT @PlanPurposes = @PlanPurposes + pp.Descriptor + ', '
FROM PolicyManagement..TPolicyBusinessPurpose pbp
INNER JOIN PolicyManagement..TPlanPurpose pp ON pbp.PlanPurposeId = pp.PlanPurposeId
WHERE policybusinessid = @PolicyBusinessId

-- Remove any trailing commas
DECLARE @strLen BIGINT
SET @strLen = LEN(@planPurposes)

IF @strLen > 0 BEGIN
	SET @planPurposes = LEFT(@planPurposes, @strLen - 1)
END

RETURN @planPurposes

END


GO
