SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpPlansExistForUserByPlanIds1]
@UserId int,
@TenantId int
AS

BEGIN

	DECLARE @AllValid INT = 0
	DECLARE @TotalPlans INT = 0
	DECLARE @UserPlans TABLE (PlanId INT PRIMARY KEY)
	DECLARE @SuperUser BIT
	DECLARE @SuperViewer BIT
	
			
		-- Get the user
	SELECT	@SuperUser = SuperUser,
			  @SuperViewer = SuperViewer
	FROM	administration..TUser
	WHERE	UserId = @UserId AND IndigoClientId = @TenantId

	IF (@SuperUser = 1 OR @SuperViewer = 1)
	BEGIN
		-- If user is super user/viewer
		-- NB. This will return ALL plans for this tenant and is the default

		UPDATE P
		set PlanIDStatus = 1
		FROM #PlanSet  p inner join TPolicyBusiness pb
		on p.PlanID = pb.PolicyBusinessId inner join TPolicyDetail	pd
		ON pd.PolicyDetailId = pb.PolicyDetailId
		JOIN	TStatusHistory	sh ON pb.PolicyBusinessId = sh.PolicyBusinessId
		JOIN	TStatus			st ON sh.StatusId = st.StatusId
		WHERE	pb.IndigoClientId = @TenantId
		AND		sh.CurrentStatusFG = 1
		AND		st.IntelligentOfficeStatusType <> 'Deleted'


	END ELSE
	BEGIN
	-- If user is NOT super user/viewer
	;WITH PlanUsers AS
		 (
			 SELECT findParty.CRMContactId as CRMContactId
			 FROM crm..TCRMContact findParty
					  INNER JOIN administration..TUser findUser ON findParty.CRMContactId = findUser.CRMContactId
			 WHERE @TenantId = findParty.IndClientId
			   AND (
				 -- target party is the caller user
					 findUser.UserId = @UserId
				 )
			 UNION
			 SELECT findParty.CRMContactId as CRMContactId
			 FROM crm..TCRMContact findParty
			 WHERE @TenantId = findParty.IndClientId
			   AND (
				 findParty._OwnerId = @UserId
				 )
			 UNION
			 SELECT findParty.CRMContactId as CRMContactId
			 FROM crm..TCRMContact findParty
					  INNER JOIN crm..VwCRMContactKeyByCreatorId TCKey
								 ON TCKey.UserId = @UserId AND TCKey.CreatorId = findParty._OwnerId WHERE @TenantId = findParty.IndClientId
									 AND (
										-- apply entity security
										-- or creator ID is not null
										TCKey.CreatorId IS NOT NULL
										)
			 UNION
			 SELECT findParty.CRMContactId as CRMContactId
			 FROM crm..TCRMContact findParty
					  INNER JOIN crm..VwCRMContactKeyByEntityId TEKey
								 ON TEKey.UserId = @UserId AND TEKey.EntityId = findParty.CRMContactId
			 WHERE @TenantId = findParty.IndClientId
			   AND (
				 -- or entity id is not null
				 TEKey.EntityId IS NOT NULL
				 )
		 )
	-- Add the user plans to temp table
	UPDATE P
	set PlanIDStatus = 1
	FROM #PlanSet  p inner join TPolicyBusiness pb
	on p.PlanID = pb.PolicyBusinessId 
	JOIN TPolicyOwner po ON po.PolicyDetailId = pb.PolicyDetailId
	JOIN TPolicyDetail pd ON pd.PolicyDetailId = pb.PolicyDetailId
	JOIN TStatusHistory sh ON pb.PolicyBusinessId = sh.PolicyBusinessId
	JOIN TStatus st ON sh.StatusId = st.StatusId
	JOIN PlanUsers ow ON po.CRMContactId = ow.CRMContactId
	WHERE pb.IndigoClientId = @TenantId
	  AND sh.CurrentStatusFG = 1
	  AND st.IntelligentOfficeStatusType <> 'Deleted'

	END


	IF NOT EXISTS (SELECT 1 FROM #PlanSet where PlanIDStatus = 0 )
	  SET @AllValid = 1

	SELECT @AllValid

END
RETURN (0)




GO
