SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_Tenant_UserLicenceCounts]
	@TenantId bigint
AS
SELECT
	ISNULL(SUM(CAST(ISNULL(FinancialPlanningAccess, 0) AS int)), 0) AS FinancialPlanning,
	ISNULL(SUM(CAST(ISNULL(IsMortgageBenchEnabled, 0) AS int)), 0) AS MortgageBench,
	ISNULL(SUM(CAST(ISNULL(AdvisaCentaCoreAccess, 0) AS int)), 0) AS AdvisaCentaCore,
	ISNULL(SUM(CAST(ISNULL(AdvisaCentaCorePlusAccess, 0) AS int)), 0) AS AdvisaCentaCorePlus,
	ISNULL(SUM(CAST(ISNULL(AdvisaCentaFullAccess, 0) AS int)), 0) AS AdvisaCentaFull,
	ISNULL(SUM(CAST(ISNULL(AdvisaCentaFullAccessPlusLifetimePlanner, 0) AS int)), 0) AS AdvisaCentaFullPlus,
	ISNULL(SUM(CAST(ISNULL(PensionFreedomPlanner, 0) AS int)), 0) AS PensionFreedomPlannerUsers,
	ISNULL(SUM(CAST(ISNULL(IsVoyantUser, 0) AS int)), 0) AS VoyantUsers,
	ISNULL(SUM(CAST(ISNULL(SolutionBuilderAccess, 0) AS int)), 0) AS SolutionBuilderUsers
FROM
	Administration..TUser
WHERE 
	IndigoClientId = @TenantId
	AND RefUserTypeId NOT IN (5, 6) -- don't include the system/support user.
GO
