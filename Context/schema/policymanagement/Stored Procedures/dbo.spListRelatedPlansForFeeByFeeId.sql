SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.spListRelatedPlansForFeeByFeeId 
    @FeeId INT,
    @TenantId INT
AS
    
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
    SELECT
        feeToPolicy.PolicyBusinessId,
        policyBusiness.PolicyNumber AS PolicyNumber,
        policyBusiness.SequentialRef AS PlanRef,
        planTypeProviderView.PlanType,
        planTypeProviderView.ProviderName,
        feeToPolicy.Fee2PolicyId as FeeToPlanId,
        planStatus.Name as PlanStatus,
        feeToPolicy.RebateCommission as IsRebateCommission
    FROM TFee2Policy feeToPolicy
    INNER JOIN TPolicyBusiness policyBusiness
        ON policyBusiness.PolicyBusinessId = feeToPolicy.PolicyBusinessId
    INNER JOIN VwPlanTypeAndProvider planTypeProviderView
        ON policyBusiness.PolicyBusinessId = planTypeProviderView.PolicyBusinessId
    INNER JOIN TStatusHistory statusHistory
        ON statusHistory.PolicyBusinessId = policyBusiness.PolicyBusinessId AND statusHistory.CurrentStatusFG = 1
    INNER JOIN TStatus planStatus
        ON planStatus.StatusId = statusHistory.StatusId
    WHERE 
        policyBusiness.IndigoClientId = @TenantId
        AND feeToPolicy.FeeId = @FeeId