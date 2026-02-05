SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomDashboardRetrieveMyClientsPlans]
	@UserId bigint,
	@TenantId bigint
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT trpc.Identifier as Category, count(pb.PolicyBusinessId) as NumberOfPlans
FROM TPolicyBusiness pb with(nolock) 
INNER JOIN TPolicyDetail pd  with(nolock) ON pd.PolicyDetailid = pb.PolicyDetailId
INNER JOIN TPlanDescription pds  with(nolock) ON pds.PlanDescriptionId = pd.PlanDescriptionId
INNER JOIN TRefPlanType2ProdSubType pt2pst  with(nolock) ON pt2pst.RefPlanType2ProdSubTypeId = pds.RefPlanType2ProdSubTypeId
INNER JOIN Reporter..TPlanSetting tps On tps.RefPlanType2ProdSubTypeId = pt2pst.RefPlanType2ProdSubTypeId
INNER JOIN Reporter..TRefPlanCategory trpc ON trpc.RefPlanCategoryId = tps.RefPlanCategoryId
INNER JOIN TStatusHistory sh  with(nolock) ON pb.PolicyBusinessId = sh.POlicyBusinessId
INNER JOIN TStatus s  with(nolock) ON s.StatusId = sh.StatusId
INNER JOIN crm..TPractitioner p  with(nolock) ON p.PractitionerId = pb.PractitionerId
INNER JOIN administration..TUser u  with(nolock) ON u.CRMContactId = p.CRMContactId
WHERE u.UserId = @UserId
AND tps.TenantId = @TenantId
AND sh.CurrentStatusFG = 1
AND s.IntelligentOfficeStatusType IN ('In Force', 'Paid Up')
GROUP BY trpc.Identifier


GO
