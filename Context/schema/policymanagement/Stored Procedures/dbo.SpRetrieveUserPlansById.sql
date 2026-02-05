SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================
-- Description: Returns a list of plans for a user.
-- Params:		@UserId				 Int
-- Params:		@TenantId			 Int
-- Params:		@Top				 Int (default 100)
-- Params:		@Skip				 Int (default   0)
-- Params:		@HasAccessToAll		 Int (default   0)
-- Params:		@TotalPlans (output) Int
-- Created:		10/03/2022 by Toby Tranter
-- Updated:		25/07/2022 by Toby Tranter (Added HasAccessToAll Param)
-- Updated:		10/08/2022 by Toby Tranter (Use same logic as crm.SpExistsClientByClientIdAndReach)
-- Updated:		28/11/2022 by Toby Tranter (CTE uses Union rather than Left Join & table variable is now a temp table)
-- Updated:		16/07/2025 by Nick Fairway - Performance improvement

-- ===============================================
CREATE PROCEDURE dbo.SpRetrieveUserPlansById
	@UserId			INT,
	@TenantId		INT,
	@Top			INT = 100,
	@Skip			INT = 0,
	@HasAccessToAll BIT = 0,
	@TotalPlans		INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON
	SET ANSI_WARNINGS OFF
 
	SET @TotalPlans = 0

	DECLARE @SuperUser		BIT
	DECLARE @SuperViewer	BIT
	DECLARE @UserIdentifier VARCHAR(64)

	CREATE TABLE #PlanUsers (CrmContactId INT NOT NULL)
	CREATE TABLE #UserPlansAll (PlanId INT )
	CREATE TABLE #UserPlans (PlanId INT)
	CREATE TABLE #AllStatus (PlanId INT, CurrentStatusFG bit)


	-- Get the user
	SELECT	@SuperUser = SuperUser, 
			@SuperViewer = SuperViewer,
			@UserIdentifier = Identifier
	FROM	administration..TUser 
	WHERE	UserId = @UserId AND IndigoClientId = @TenantId 

	-- Check user exists
	IF (@UserIdentifier IS NULL)
		RETURN -1

	-- If user is super user/viewer and HasAccessToAll is True
	-- NB. This will NOT return any data and assumes access to all plans for this tenant
	IF (@HasAccessToAll = 1 AND (@SuperUser = 1 OR @SuperViewer = 1))
		RETURN -2

	IF (@HasAccessToAll = 0 AND (@SuperUser = 1 OR @SuperViewer = 1)) 
	BEGIN
		-- If user is super user/viewer and HasAccessToAll is False
		-- NB. This will return ALL plans for this tenant and is the default
		INSERT  #UserPlansAll
		SELECT	DISTINCT pb.PolicyBusinessId AS PlanId
		FROM	TPolicyDetail	pd
		JOIN	TPolicyBusiness	pb ON pd.PolicyDetailId = pb.PolicyDetailId
		WHERE	pd.IndigoClientId = @TenantId
	END ELSE
	BEGIN
		-- If user is NOT super user/viewer

		WITH FindParty AS (SELECT CRMContactId, _OwnerId FROM crm..TCRMContact WHERE IndClientId= @TenantId),
			PlanUsers AS
		(
			-- User is the client
			SELECT findParty.CRMContactId as CRMContactId
			FROM   findParty
            JOIN   administration..TUser findUser ON findParty.CRMContactId = findUser.CRMContactId
			WHERE  findUser.UserId = @UserId
			UNION
			-- User is the client owner (adviser)
			SELECT findParty.CRMContactId as CRMContactId
			FROM   findParty
			WHERE  findParty._OwnerId = @UserId
			UNION
            -- Users linked to the client by the creator
			SELECT findParty.CRMContactId as CRMContactId
			FROM   findParty
            JOIN   crm..VwCRMContactKeyByCreatorId TCKey ON TCKey.UserId = @UserId AND TCKey.CreatorId = findParty._OwnerId --TCRMContactKey
			WHERE  TCKey.CreatorId IS NOT NULL
			UNION
			-- Users linked to the client by entity security
			SELECT findParty.CRMContactId as CRMContactId
			FROM   findParty
            JOIN   crm..VwCRMContactKeyByEntityId TEKey ON TEKey.UserId = @UserId AND TEKey.EntityId = findParty.CRMContactId
			WHERE  TEKey.EntityId IS NOT NULL
		)
		INSERT #PlanUsers SELECT CRMContactId FROM PlanUsers
		
		-- Add the user plans to temp table
		INSERT  #UserPlansAll
		SELECT	DISTINCT pb.PolicyBusinessId AS PlanId
		FROM	#PlanUsers		ow
		JOIN    TPolicyOwner	po ON po.CRMContactId = ow.CRMContactId
		JOIN	TPolicyBusiness	pb ON po.PolicyDetailId = pb.PolicyDetailId
		WHERE	pb.IndigoClientId = @TenantId
		OPTION (MAXDOP 8)
	END;
	
	WITH AllStatus  as (
		SELECT PlanId, sh.CurrentStatusFG 
		FROM #UserPlansAll pb
		JOIN	dbo.TStatusHistory	sh ON pb.PlanId = sh.PolicyBusinessId
		JOIN	dbo.TStatus			st ON sh.StatusId = st.StatusId AND st.IntelligentOfficeStatusType <> 'Deleted'
	)
	INSERT #AllStatus 
	SELECT * FROM AllStatus
	OPTION (MAXDOP 8)

	INSERT #UserPlans
	SELECT PlanId FROM #AllStatus
	WHERE CurrentStatusFG = 1

	-- Set total user plans
	SET @TotalPlans = @@Rowcount;

	-- Return paginated user plans
	SELECT PlanId FROM #UserPlans ORDER BY PlanId
	OFFSET @Skip ROWS 
	FETCH NEXT @Top ROWS ONLY 
END
GO


