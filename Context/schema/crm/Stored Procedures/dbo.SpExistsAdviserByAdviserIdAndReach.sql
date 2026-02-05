CREATE PROCEDURE [dbo].[SpExistsAdviserByAdviserIdAndReach]
    @AdviserId int,
    @CallerUserId int = null,
    @CallerTenantId int = null,
    @Reach varchar(255) = ''
AS

-- if CallerTenantId id is null, and CallerUserId is present, fetch CallerTenantId from aller user
IF ISNULL(@CallerUserId,0) > 0 and ISNULL(@CallerTenantId,0) = 0
       SELECT @CallerTenantId = IndigoClientId FROM administration..tuser WHERE UserId = @CallerUserId

IF(@Reach = 'system')
BEGIN
    SELECT TOP 1 
        findPractitioner.CRMContactId AS partyId, 
        findPractitioner.PractitionerId AS adviserId
    FROM TPractitioner findPractitioner
    WHERE findPractitioner.PractitionerId = @AdviserId -- match target adviser
END

IF(@Reach = 'tenant')
BEGIN
    SELECT TOP 1 
        findPractitioner.CRMContactId AS partyId, 
        findPractitioner.PractitionerId AS adviserId
    FROM TPractitioner findPractitioner
        INNER JOIN TCRMContact findParty ON findParty.CRMContactId = findPractitioner.CRMContactId
    WHERE findPractitioner.PractitionerId = @AdviserId -- match target adviser
        AND @CallerTenantId = findParty.IndClientId
END

IF(@Reach NOT IN ('system','tenant'))
BEGIN
    SELECT TOP 1 
        findPractitioner.CRMContactId AS partyId, 
        findPractitioner.PractitionerId AS adviserId
    FROM TPractitioner findPractitioner
        INNER JOIN administration..TUser findUser ON findUser.CRMContactId = findPractitioner.CRMContactId 
        INNER JOIN TCRMContact findParty ON findParty.CRMContactId = findPractitioner.CRMContactId
        LEFT JOIN administration..TUser callingUser ON callingUser.UserId = @CallerUserId
        -- Secure clause 
        LEFT JOIN VwPractitionerKeyByCreatorId TCKey ON TCKey.UserId = @CallerUserId AND TCKey.CreatorId = findPractitioner._OwnerId
        LEFT JOIN VwPractitionerKeyByEntityId TEKey ON TEKey.UserId = @CallerUserId AND TEKey.EntityId = findParty.CRMContactId 
    WHERE findPractitioner.PractitionerId = @AdviserId -- match target adviser
    AND @CallerTenantId = findParty.IndClientId 
    AND (
		-- super user.
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
