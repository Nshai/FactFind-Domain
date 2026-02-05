SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomSearchForNewSellingAdviser]
	@TenantId bigint, 
	@UserId bigint,
	@IsSuperUserOrSuperViewer bit,	
	@PolicyBusinessId bigint = null, 
	@FirstName varchar(64) = null, 
	@LastName varchar(64) = null, 
	@GroupId bigint = null,
	@_TopN int = null
AS
---------------------------------------------------------------------------------------------------------------------
-- Things to bear in mind when selecting a new adviser: OffPanel, MultiTie, Gating, Pre-Existing
---------------------------------------------------------------------------------------------------------------------
DECLARE @RefPlanType2ProdSubTypeId bigint, @PreExisting bit, @LegalEntityId bigint, 
	@RefProdProviderId bigint, @CurrentAdviserId bigint, @IsSecureSearch bit = 0

-- Get current details about this plan
SELECT
	@PreExisting = CASE AT.IntelligentOfficeAdviceType WHEN 'Pre-Existing' THEN 1 ELSE 0 END,
	@RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId,
	@RefProdProviderId = PDesc.RefProdProviderId,
	@CurrentAdviserId = PB.PractitionerId
FROM
	TPolicyBusiness PB
	JOIN TAdviceType AT ON AT.AdviceTypeId = PB.AdviceTypeId
	JOIN TPolicyDetail PD ON PD.PolicyDetailId = PB.PolicyDetailId
	JOIN TPlanDescription PDesc ON PDesc.PlanDescriptionId = PD.PlanDescriptionId
WHERE
	PB.PolicyBusinessId = @PolicyBusinessId

-- Get Legal Entity for the current adviser
SELECT @LegalEntityId = CRM.dbo.FnGetLegalEntityIdForAdviser(@CurrentAdviserId)

-- See if we need to secure the search.    
IF @IsSuperUserOrSuperViewer = 0
	SET @IsSecureSearch = [Administration].[dbo].[FnIsAdviserSearchSecured](@TenantId)

-- Return all advisers that should be able to see this plan type
SELECT DISTINCT -- added due to plan types / advisers having more than one Multi Tie causes Dulicates IP-20640
	A.PractitionerId,
	C.CRMContactId,
	C.LastName, 
	C.FirstName,
	C.FirstName + ' ' + C.LastName AS AdviserName,
	U.Reference,
	Gp.Identifier
FROM
	CRM..TPractitioner A
	JOIN CRM..TCRMContact C ON C.CRMContactId = A.CRMContactId AND C.IndClientId = A.IndClientId
	JOIN Administration..TUser U ON U.CRMContactId = C.CRMContactId
	JOIN Administration..TGroup Gp ON Gp.GroupId = U.GroupId
	-- Make sure user is in the same legal entity
	JOIN Administration.dbo.FnCustomGetUsersByLegalEntityId(@TenantId, @LegalEntityId) AS LE ON LE.UserId = U.UserId
	LEFT JOIN Compliance..TGating G ON G.PractitionerId = A.PractitionerId AND G.RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId
	LEFT JOIN TMultiTie MT ON MT.IndigoClientId = A.IndClientId AND MT.RefProdProviderId = @RefProdProviderId AND MT.RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId		
	-- For secure searches.
	LEFT JOIN CRM.dbo.TPractitionerKey K WITH(NOLOCK) ON K.CreatorId = A._OwnerId AND K.UserId = @UserId AND @IsSecureSearch = 1
WHERE
	A.IndClientId = @TenantId
	AND A.AuthorisedFG = 1
	AND A.PractitionerId != @CurrentAdviserId
	-- Check search params
	AND (C.FirstName LIKE @FirstName + '%' OR @FirstName IS NULL)
	AND (C.LastName LIKE @LastName + '%' OR @LastName IS NULL)
	AND (U.GroupId = @GroupId OR @GroupId IS NULL)
	-- Can the advisers sell this plan type?
	AND 
	(
		-- All advisers can sell pre-existing
		@PreExisting = 1		
		OR
		-- Off panel advisers can sell all plans
		A.OffPanelFg = 1
		OR
		-- otherwise check that the adviser is gated and their multi-tie setting
		(	
			G.PractitionerId IS NOT NULL	
			AND NOT (A.MultiTieFg = 1 AND MT.IndigoClientId IS NULL)
		)
	)
	-- If we're securing the search then don't return an adviser if they are
	-- not owned by the User AND the User does not have a revelant security key.
	AND NOT (@IsSecureSearch = 1 AND A._OwnerId != @UserId AND K.UserId IS NULL)
ORDER BY
	C.LastName, C.FirstName
GO
