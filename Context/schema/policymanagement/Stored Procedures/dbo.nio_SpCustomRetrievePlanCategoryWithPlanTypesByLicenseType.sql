SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomRetrievePlanCategoryWithPlanTypesByLicenseType]
	@TenantId int,
	@PlanCategoryId int,
	@UserId int,
	@RegionCode varchar(2) = 'GB'
AS
----------------------------------------------------------------
-- Find the license types for the Adviser that we are Gating.
----------------------------------------------------------------
DECLARE @LicenseTypes TABLE (Id int)
INSERT INTO @LicenseTypes
SELECT DISTINCT R.RefLicenseTypeId
FROM
	Administration..TMembership M
	JOIN Administration..TRole R ON R.RoleId = M.RoleId
WHERE
	M.UserId = @UserId

----------------------------------------------------------------
-- Retrieve Plan Types on the basis of the user's license types
----------------------------------------------------------------
SELECT DISTINCT
	PTC.PlanCategoryId AS [PlanCategoryId],
	NULL AS [PlanCategoryName],
	PTC.IndigoClientId AS [IndigoClientId],
	PTC.RefPlanType2ProdSubTypeCategoryId,
	PTC.RefPlanType2ProdSubTypeId,
	PT.PlanTypeName + ISNULL(' (' + PST.ProdSubTypeName + ')','') AS PlanTypeName
FROM 
	TRefPlanType2ProdSubTypeCategory PTC
	JOIN TRefPlanType2ProdSubType P2P ON P2P.RefPlanType2ProdSubTypeId = PTC.RefPlanType2ProdSubTypeId
	JOIN TRefLicenseTypeToRefPlanType2ProdSubType LP2P ON LP2P.RefPlanType2ProdSubtypeId = P2P.RefPlanType2ProdSubtypeId
	JOIN TRefPlanType PT ON PT.RefPlanTypeId = P2P.RefPlanTypeId
	LEFT JOIN TProdSubType PST ON PST.ProdSubTypeId = P2P.ProdSubTypeId
WHERE 
	PTC.IndigoClientId = @TenantId
	AND PTC.PlanCategoryId = @PlanCategoryId
	AND P2P.IsArchived = 0
	AND PT.RetireFg = 0
	AND LP2P.RefLicenseTypeId IN (SELECT Id FROM @LicenseTypes)
	AND P2P.RegionCode = @RegionCode
GO
