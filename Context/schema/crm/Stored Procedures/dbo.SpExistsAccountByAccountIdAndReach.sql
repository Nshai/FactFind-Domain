USE [crm]
GO

/****** Object:  StoredProcedure [dbo].[SpExistsAccountByAccountIdAndReach]    Script Date: 23/07/2018 17:09:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create procedure [dbo].[SpExistsAccountByAccountIdAndReach]
@AccountId int,
@CallerUserId int = null,
@CallerTenantId int = null,
@Reach varchar(255) = ''
as

-- if CallerTenantId id is null, and CallerUserId is present, fetch CallerTenantId from aller user
If IsNull(@CallerUserId,0) > 0 and IsNull(@CallerTenantId,0) =0
       Select @CallerTenantId = IndigoClientId from administration..tuser where UserId = @CallerUserId

select top 1 findAccount.CRMContactId as partyId, findAccount.AccountId as accountId

from TAccount findAccount
Left Join administration..TUser findUser On findUser.CRMContactId = findAccount.CRMContactId 
left join administration..TUser callingUser on callingUser.UserId = @CallerUserId
left join TCRMContact findParty on findParty.CRMContactId = findAccount.CRMContactId

-- Secure clause 
LEFT JOIN VwAccountKeyByCreatorId TCKey ON TCKey.UserId = @CallerUserId AND TCKey.CreatorId = findParty._OwnerId 
LEFT JOIN VwAccountKeyByEntityId TEKey ON TEKey.UserId = @CallerUserId AND TEKey.EntityId = findParty.CRMContactId 


WHERE findAccount.AccountId = @AccountId -- match target lead
and ( -- one of severl reach cases:

	-- allow anything for `system`
	(@reach = 'system' )
	Or
	-- for any othe reaach, assert that caller tenant id is same as target party tenant id
	-- add extra check for reach != system. More info: https://blogs.msdn.microsoft.com/bartd/2011/03/03/dont-depend-on-expression-short-circuiting-in-t-sql-not-even-with-case/
	( @Reach <> 'system' AND @CallerTenantId = findParty.IndClientId AND
		(
			-- either reach is tenant or super user.
			@reach = 'tenant'  or callingUser.SuperUser = 1 OR callingUser.SuperViewer = 1 
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
	)
)

GO


