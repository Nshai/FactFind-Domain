SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomRetrieveMultiTiedPlanTypesByCategoryAndLicenseType]
	@TenantId bigint,
	@PlanCategoryId bigint, 
	@MultiTieConfigId bigint,
	@UserId bigint,
	@RegionCode varchar(2) = 'GB'
WITH RECOMPILE
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

----------------------------------------------------------------
-- Find the license types for the Adviser that we are Gating.
----------------------------------------------------------------
CREATE TABLE #LicenseTypes (Id int)
INSERT INTO #LicenseTypes
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
	PTC.PlanCategoryId,
	NULL AS [PlanCategoryName],
	PTC.IndigoClientId,
	PTC.RefPlanType2ProdSubtypeCategoryId,
	PTC.RefPlanType2ProdSubtypeId,
	PT.PlanTypeName + ISNULL(' (' + pst.ProdSubtypeName + ')', '') AS PlanTypeName
FROM 
	TRefPlanType2ProdSubTypeCategory PTC 
	JOIN TRefPlanType2ProdSubType P2P ON P2P.RefPlanType2ProdSubTypeId = PTC.RefPlanType2ProdSubTypeId
	JOIN TMultiTie MT ON MT.RefPlanType2ProdSubtypeId = P2P.RefPlanType2ProdSubtypeId AND MT.MultiTieConfigId = @MultiTieConfigId  
	JOIN TRefLicenseTypeToRefPlanType2ProdSubType LP2P ON LP2P.RefPlanType2ProdSubtypeId = P2P.RefPlanType2ProdSubtypeId  
	JOIN #LicenseTypes LT ON LT.Id = LP2P.RefLicenseTypeId
	JOIN TRefPlanType PT ON PT.RefPlanTypeId = P2P.RefPlanTypeId
	LEFT JOIN TProdSubtype pst ON pst.ProdSubTypeId = P2P.ProdSubtypeId
WHERE 
	PTC.PlanCategoryId = @PlanCategoryId
	AND PTC.IndigoClientId = @TenantId
	AND P2P.IsArchived = 0
	AND PT.RetireFg = 0
	AND P2P.RegionCode = @RegionCode
GO
