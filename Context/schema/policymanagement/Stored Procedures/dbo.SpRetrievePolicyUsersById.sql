SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================
-- Description: Returns a list of plan users.
-- Params:		@PlanId				 Int
-- Params:		@TenantId			 Int
-- Params:		@Top  (default 100)	 Int
-- Params:		@Skip (default   0)	 Int
-- Params:		@TotalUsers (output) Int
-- Created:		02/03/2022 by Toby Tranter
-- Updated:		10/08/2022 by Toby Tranter (Include client owner and user)
-- ==========================================
CREATE PROCEDURE [dbo].[SpRetrievePolicyUsersById]
	@PlanId		INT,
	@TenantId	INT,
	@Top		INT = 100,
	@Skip		INT = 0,
	@TotalUsers	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON
	SET ANSI_WARNINGS OFF

	SET @TotalUsers = 0

	-- Validate the plan exists for this tenant
	IF NOT EXISTS (SELECT 1 FROM TPolicyBusiness WITH(NOLOCK) WHERE PolicyBusinessId = @PlanId AND IndigoClientId = @TenantId)
	BEGIN
		RETURN -1
	END

	DROP TABLE IF EXISTS #PlanUsers

	;WITH PlanOwners 
	AS
	(
		SELECT	ct.CRMContactId
		FROM	TPolicyOwner		po
		JOIN	TPolicyDetail		pd ON pd.PolicyDetailId = po.PolicyDetailId
		JOIN	TPolicyBusiness		pb ON pb.PolicyDetailId = pd.PolicyDetailId
		JOIN	crm..TCRMContact	ct ON ct.CRMContactId = po.CRMContactId
		WHERE	pb.PolicyBusinessId = @PlanId
		AND		pb.IndigoClientId = @TenantId
		AND		ct.IsDeleted = 0 AND  ISNULL(ct.ArchiveFg, 0) = 0
	)

	-- Add plan users to temp table
	SELECT DISTINCT users.UserId
	INTO   #PlanUsers FROM 
	(
		SELECT	u.UserId
		FROM	administration..TUser u
		WHERE	u.IndigoClientId = @TenantId
		AND		(u.SuperUser = 1 OR u.SuperViewer = 1)

 		UNION ALL

		-- Add the users for the client owner
		SELECT	TCKey.UserId as UserId
		FROM	crm..TCRMContact findParty
		JOIN	crm..VwCRMContactKeyByCreatorId TCKey ON TCKey.CreatorId = findParty._OwnerId
		JOIN	PlanOwners owners ON owners.CRMContactId = findParty.CRMContactId
		WHERE	findParty.IndClientId = @TenantId
 
		UNION ALL
 
		-- Add the users for the client entity
		SELECT	TEKey.UserId as UserId      
		FROM	crm..TCRMContact findParty
		JOIN	crm..VwCRMContactKeyByEntityId TEKey ON TEKey.EntityId = findParty.CRMContactId
		JOIN	PlanOwners owners ON owners.CRMContactId = findParty.CRMContactId
		WHERE	findParty.IndClientId = @TenantId

		UNION ALL

		-- Add the client owner
		SELECT	findParty._OwnerId as UserId
		FROM	crm..TCRMContact findParty
		JOIN	PlanOwners owners ON owners.CRMContactId = findParty.CRMContactId
		WHERE	findParty.IndClientId = @TenantId
		
		UNION ALL

		-- Add the client user
		SELECT	users.UserId as UserId
		FROM	crm..TCRMContact findParty
		JOIN	PlanOwners owners ON owners.CRMContactId = findParty.CRMContactId
		JOIN	administration..TUser users ON users.CRMContactId = findParty.CRMContactId
		WHERE	findParty.IndClientId = @TenantId
	) as users
	WHERE users.UserId IS NOT NULL

	-- Set total plan users
	SET @TotalUsers = (SELECT COUNT(1) FROM #PlanUsers)

	-- Return paginated plan users
	SELECT UserId FROM #PlanUsers ORDER BY UserId
	OFFSET @Skip ROWS 
	FETCH NEXT @Top ROWS ONLY 
END