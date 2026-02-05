CREATE PROCEDURE [dbo].[spListCommissionIdByPlanIdAndCommissionTypeQuery] 
			@CommissionTypeId INT,
			@PlanId INT,
			@TenantId INT
AS

SELECT commissions.PolicyExpectedCommissionId
FROM policymanagement..TPolicyExpectedCommission commissions
JOIN TPolicyBusiness plans
    ON commissions.PolicyBusinessId = plans.PolicyBusinessId
WHERE commissions.RefCommissionTypeId = @CommissionTypeId
    AND commissions.PolicyBusinessId = @PlanId
    AND plans.IndigoClientId = @TenantId