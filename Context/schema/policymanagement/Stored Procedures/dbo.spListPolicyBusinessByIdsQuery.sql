SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.spListPolicyBusinessByIdsQuery 
@PolicyBusinessIds VARCHAR(max),
@TenantId INT
AS

SELECT source.[value] AS [PolicyBusinessId]
INTO #policyBusinessIds
FROM STRING_SPLIT(@PolicyBusinessIds,';') source

SELECT
    policyBusiness.PolicyBusinessId,
    policyBusiness.PolicyNumber,
    policyBusiness.SequentialRef AS PlanRef,
    planTypeProviderView.PlanType,
    planTypeProviderView.ProviderName,
    stat.Name AS PlanStatus
FROM TPolicyBusiness policyBusiness
INNER JOIN VwPlanTypeAndProvider planTypeProviderView
    ON policyBusiness.PolicyBusinessId = planTypeProviderView.PolicyBusinessId
INNER JOIN TStatusHistory history
	ON history.PolicyBusinessId = policyBusiness.PolicyBusinessId AND CurrentStatusFG = 1
INNER JOIN TStatus stat
    ON stat.StatusId = history.StatusId
WHERE policyBusiness.IndigoClientId = @TenantId
    AND policyBusiness.PolicyBusinessId IN (SELECT PolicyBusinessId FROM #policyBusinessIds)

DROP TABLE #policyBusinessIds