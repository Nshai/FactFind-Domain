SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpPlansExistForUserByPlanIds2]
@UserId int,
@TenantId int,
@PlanSet tvp_int READONLY,
@PermissionType VARCHAR(50) = 'readwrite'
AS

BEGIN
	IF(@PermissionType NOT IN ('read','readwrite'))
	BEGIN
		SELECT 0
		RETURN 0
	END;

	DECLARE @PlanSet_Local tvp_int
    -- 'Optimize for unknown' for the TVP
    INSERT @PlanSet_Local
    SELECT * FROM @PlanSet
    SET NOCOUNT ON

	DECLARE @AllValid INT = 1
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
		-- NB. This will return ALL plans for this tenant
		SELECT TOP 1 @AllValid=0
        FROM @PlanSet_Local s
	    LEFT JOIN
		(
			TPolicyDetail	pd
			JOIN	TPolicyBusiness	pb ON pd.PolicyDetailId = pb.PolicyDetailId AND pb.IndigoClientId = @TenantId
			JOIN	TStatusHistory	sh ON pb.PolicyBusinessId = sh.PolicyBusinessId AND sh.CurrentStatusFG = 1
			JOIN	TStatus			st ON sh.StatusId = st.StatusId AND st.IntelligentOfficeStatusType <> 'Deleted'
		)
        ON s.VALUE = pb.PolicyBusinessId
        WHERE pb.PolicyBusinessId  IS NULL
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

        SELECT TOP 1 @AllValid=0
        FROM @PlanSet_Local s
	    LEFT JOIN (TPolicyBusiness pb
					JOIN TPolicyOwner po ON po.PolicyDetailId = pb.PolicyDetailId
					JOIN TPolicyDetail pd ON pd.PolicyDetailId = pb.PolicyDetailId
					JOIN TStatusHistory sh ON pb.PolicyBusinessId = sh.PolicyBusinessId
					JOIN TStatus st ON sh.StatusId = st.StatusId
					JOIN PlanUsers ow ON po.CRMContactId = ow.CRMContactId
						AND pb.IndigoClientId = @TenantId
						AND sh.CurrentStatusFG = 1
						AND st.IntelligentOfficeStatusType <> 'Deleted'
		)
		ON pb.PolicyBusinessId = s.VALUE
		WHERE pb.PolicyBusinessId IS NULL

		IF (@AllValid = 1 OR @PermissionType = 'readwrite')
		BEGIN
			SELECT @AllValid
			RETURN @AllValid
		END;

		DECLARE	@ClientId INT = (SELECT TOP 1 CRMContactId FROM administration..TUser Where @UserId = UserId)

		IF(@ClientId IS NULL)
		BEGIN
			SELECT @AllValid
			RETURN @AllValid
		END;

		/*reset*/
		SET @AllValid = 1;

		;WITH
		Relations(ClientId) AS
		(
			--Get all relationships client's permitted to view in pfp
			SELECT REL.CRMContactToId
			FROM CRM..TRelationship REL
			WHERE REL.CRMContactFromId = @ClientId AND REL.IncludeInPfp = 1 --Contact from id is the relationship viewing the private info (get all contacts where this clientId is contactfrom and includeinpfp is true
			UNION ALL
			SELECT @ClientId
		),
		--Identify all policies of related client ids
		ClientPolicyDetail(PolicyDetailId, hasClient) AS --Get policy detail ids those clients or I have access to, indicate which ones are mine with a 1, otherwise, 0
		(
			SELECT PO.PolicyDetailId, MAX(CASE WHEN PO.CRMContactId = @ClientId THEN 1 ELSE 0 END) as hasClient --Max seems to be handling inner join/group by issues
			FROM [policymanagement].[dbo].[TPolicyOwner] PO
				INNER JOIN Relations Rels ON Rels.ClientId = PO.CRMContactId
			GROUP BY PO.PolicyDetailId
		),
		--Limit policies ids to those that are not owned by non relations
		PolicyDetail(PolicyDetailId, PlanDescriptionId) AS
		(
			SELECT DISTINCT CPD.PolicyDetailId, PD.PlanDescriptionId --Get policy detail id and plan description id where the detail id is not in the 
			FROM ClientPolicyDetail CPD
				INNER JOIN [policymanagement].[dbo].[TPolicyDetail] PD ON CPD.PolicyDetailId = PD.PolicyDetailId
			WHERE CPD.PolicyDetailId NOT IN (
				--If a relation of a given client id has a plan that is also owned by a non relation, then that plan is filtered out with the "NOT IN" clause.
				--If a son is a relation of his mom, and his mome has a plan co-owned by a non relation of the son, then the plan is filtered out by the NOT IN clause.
				SELECT CPD.PolicyDetailId
				FROM ClientPolicyDetail CPD
					INNER JOIN [policymanagement].[dbo].[TPolicyOwner] PO ON PO.PolicyDetailId = CPD.PolicyDetailId
					LEFT JOIN Relations Rels ON Rels.ClientId = PO.CRMContactId
				WHERE CPD.hasClient = 0 AND Rels.ClientId IS NULL
			)
		)

		SELECT TOP 1 @AllValid=0
		FROM @PlanSet_Local AS PSL
		LEFT JOIN
		(
			TPolicyBusiness TPB
			JOIN PolicyDetail PD ON PD.PolicyDetailId = TPB.PolicyDetailId
			JOIN TStatusHistory sh ON TPB.PolicyBusinessId = sh.PolicyBusinessId
			JOIN TStatus st ON sh.StatusId = st.StatusId
				AND TPB.IndigoClientId = @TenantId
				AND sh.CurrentStatusFG = 1
				AND st.IntelligentOfficeStatusType <> 'Deleted'
		)
		ON TPB.PolicyBusinessId = PSL.VALUE
		WHERE TPB.PolicyBusinessId  IS NULL

	END

	SELECT @AllValid
	RETURN @AllValid
END

GO