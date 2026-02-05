Create Procedure SpNCustomPartySecurityGetCRMContactDetails
	@TenantId bigint,
	@PartyId bigint,
	@EntityId int output,
	@PartyRoleId int output,
	@CreatorUserId bigint output,
	@IsClient bit output,
	@IsLead bit output,
	@IsAccount bit output
As

Select @IsClient=0, @IsLead=0, @IsAccount=0
Declare @RefCRMContactStatusId int, @Result int

Select  @CreatorUserId = _OwnerId, @RefCRMContactStatusId = RefCRMContactStatusId 
From TCRMContact 
Where 1=1
And IndClientId=@TenantId 
And CRMContactId=@PartyId


If @RefCRMContactStatusId = 1
Begin
	Select @IsClient = 1
End
Else If @RefCRMContactStatusId = 2
Begin
	Select @IsLead = 1
End
Else
Begin
	If Exists( Select top 1 1 
				From TCRMContact c
				Join TAccount a on c.CRMContactId = a.CRMContactId
				Where 1=1
				And a.IndigoClientId=@TenantId 
				And c.IndClientId=@TenantId 
				and c.CRMContactId=@PartyId )
	Begin
		Select @IsAccount = 1
	End

End


If @IsClient=1 OR @IsLead=1 OR @IsAccount=1
Begin
	exec @Result = dbo.SpNCustomPartySecurityGetIds @IsClient=@IsClient, @IsLead=@IsLead, @IsAccount=@IsAccount, @PartyRoleId = @PartyRoleId output, @EntityId = @EntityId output
	If @Result <> 0 return @Result
End

return 0

