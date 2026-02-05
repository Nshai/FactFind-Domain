SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.spListLegacyExpectationTotalAmountsForRelatedPlansByFeeIdQuery 
    @FeeId INT,
    @TenantId INT
AS
    
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
    SELECT
        policyBusiness.PolicyBusinessId as PlanId,
        SUM(legacyExpectation.TotalAmount) as TotalAmount
    FROM TFee2Policy feeToPolicy
    INNER JOIN TPolicyBusiness policyBusiness
        ON policyBusiness.PolicyBusinessId = feeToPolicy.PolicyBusinessId
    INNER JOIN TExpectations legacyExpectation
        ON legacyExpectation.FeeId = feeToPolicy.FeeId
    WHERE
        policyBusiness.IndigoClientId = @TenantId
        AND legacyExpectation.FeeId = @FeeId
    GROUP BY policyBusiness.PolicyBusinessId