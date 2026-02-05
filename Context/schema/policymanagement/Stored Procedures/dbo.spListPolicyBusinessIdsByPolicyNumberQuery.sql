SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.spListPolicyBusinessIdsByPolicyNumberQuery 
@PolicyNumber VARCHAR(50),
@TenantId INT
AS

SELECT
    policyBusiness.PolicyBusinessId
FROM TPolicyBusiness policyBusiness
WHERE policyBusiness.IndigoClientId = @TenantId
    AND policyBusiness.PolicyNumber = @PolicyNumber
