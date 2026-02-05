Create Procedure SpNCustomPartySecurityManageClientShareKeys
	@TenantId int,
	@ClientShareId bigint
As

Declare @ClientPartyId bigint, @SharedToCRMContactId bigint, @IsShareActive bit
Declare @UserId bigint, @PartyRoleId tinyint, @EntityId tinyint, @RightMask tinyint, @Result int

Select @ClientPartyId = ClientPartyId, @SharedToCRMContactId=SharedToCRMContactId, @IsShareActive=IsShareActive
From TClientShare 
Where 1=1
And TenantId = @TenantId
And ClientShareId = @ClientShareId

Select @UserId = UserId 
from administration..TUser 
where 1=1
And IndigoClientId=@TenantId
And CRMContactId = @SharedToCRMContactId

Delete from TPartyKey
Where 1=1
And TenantId = @TenantId
And PartyId = @ClientPartyId
And IsDerived = 0
And UserId=@UserId

If @IsShareActive = 1
Begin
	exec @Result = SpNCustomPartySecurityGetIds @IsClient = 1, @PartyRoleId = @PartyRoleId output, @EntityId = @EntityId output
	If @Result <> 0 return @Result

	exec @Result = SpNCustomPartySecurityGetIdsDefaults @DefaultRightMask = @RightMask output
	If @Result <> 0 return @Result

	Insert Into TPartyKey
	(TenantId, UserId, PartyId, RightMask, PartyRoleId, IsDerived)
	Values(@TenantId, @UserId, @ClientPartyId, @RightMask, @PartyRoleId, 0)
End


