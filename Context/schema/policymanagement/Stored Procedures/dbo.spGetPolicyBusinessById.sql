CREATE PROCEDURE dbo.spGetPolicyBusinessById 
@PolicyBusinessId INT,
@TenantId INT
AS

DECLARE
    @DeletedStatus VARCHAR(30) = 'Deleted'

SELECT
    policyBusiness.PolicyBusinessId,
    policyBusiness.PolicyNumber,
    policyBusiness.SequentialRef AS PlanRef,
    planTypeProviderView.PlanType,
    planTypeProviderView.ProviderName,
    stat.Name AS PlanStatus,
    CASE
        WHEN policyBusiness.TopupMasterPolicyBusinessId IS NOT NULL
        THEN 1
        ELSE 0
    END AS IsTopUp,
    CASE
        WHEN EXISTS (SELECT policyBusinessTemp.PolicyBusinessId FROM TPolicyBusiness policyBusinessTemp
                     INNER JOIN TStatusHistory statusHistorytemp
                        ON policyBusinessTemp.PolicyBusinessId = statusHistorytemp.PolicyBusinessId
                           AND statusHistorytemp.CurrentStatusFG = 1
                     INNER JOIN TStatus statusTemp
                        ON statusHistorytemp.StatusId = statusTemp.StatusId
                           AND statusTemp.IntelligentOfficeStatusType != @DeletedStatus
                     WHERE TopupMasterPolicyBusinessId = policyBusiness.PolicyBusinessId)
        THEN 1
        ELSE 0
    END AS HasTopUps
FROM TPolicyBusiness policyBusiness
INNER JOIN VwPlanTypeAndProvider planTypeProviderView
    ON policyBusiness.PolicyBusinessId = planTypeProviderView.PolicyBusinessId
INNER JOIN TStatusHistory statusHistory
    ON statusHistory.PolicyBusinessId = policyBusiness.PolicyBusinessId
       AND statusHistory.CurrentStatusFG = 1
INNER JOIN TStatus stat
    ON stat.StatusId = statusHistory.StatusId
WHERE policyBusiness.IndigoClientId = @TenantId
    AND policyBusiness.PolicyBusinessId = @PolicyBusinessId