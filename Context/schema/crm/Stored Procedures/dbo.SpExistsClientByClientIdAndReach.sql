CREATE PROCEDURE [dbo].[SpExistsClientByClientIdAndReach]
	@ClientId INT,
	@CallerUserId INT = NULL,
	@CallerTenantId INT = NULL,
	@Reach VARCHAR(255) = ''
AS

-- if CallerTenantId id is null, and CallerUserId is present, fetch CallerTenantId from aller user
IF ISNULL(@CallerUserId,0) > 0 AND ISNULL(@CallerTenantId,0) = 0
       SELECT @CallerTenantId = IndigoClientId FROM administration..tuser WHERE UserId = @CallerUserId


IF(@Reach = 'system')
BEGIN
	SELECT TOP 1
		findParty.CRMContactId as clientId
	FROM TCRMContact findParty
	WHERE findParty.CRMContactId = @ClientId -- match target party
END

IF(@Reach = 'tenant')
BEGIN
	SELECT TOP 1
		findParty.CRMContactId as clientId
	FROM TCRMContact findParty
		LEFT JOIN administration..TUser findUser ON findParty.CRMContactId = findUser.CRMContactId
		LEFT JOIN administration..TUser callingUser ON callingUser.UserId = @CallerUserId
	WHERE findParty.CRMContactId = @ClientId -- match target party
		AND findParty.IndClientId = @CallerTenantId
END

IF(@Reach NOT IN ('system','tenant'))
BEGIN
	SELECT TOP 1
		findParty.CRMContactId as clientId
	FROM TCRMContact findParty
		LEFT JOIN administration..TUser findUser ON findParty.CRMContactId = findUser.CRMContactId
		LEFT JOIN administration..TUser callingUser ON callingUser.UserId = @CallerUserId
	-- Secure clause
	LEFT JOIN VwCRMContactKeyByCreatorId TCKey ON TCKey.UserId = @CallerUserId AND TCKey.CreatorId = findParty._OwnerId 
	LEFT JOIN VwCRMContactKeyByEntityId TEKey ON TEKey.UserId = @CallerUserId AND TEKey.EntityId = findParty.CRMContactId 


	WHERE findParty.CRMContactId = @ClientId -- match target party
		AND @CallerTenantId = findParty.IndClientId 
		AND (
				-- either reach is tenant or super user.
				callingUser.SuperUser = 1 
				OR callingUser.SuperViewer = 1 
				-- or target party is the caller user 
				OR findUser.UserId=@CallerUserId 
				-- or target party owner is the caller user
				OR findParty._OwnerId=@CallerUserId 
			
				-- apply entity security
				-- or creator ID is not null 
				OR TCKey.CreatorId IS NOT NULL 
				-- or entity id is not null
				OR TEKey.EntityId IS NOT NULL
			)   
END
GO
