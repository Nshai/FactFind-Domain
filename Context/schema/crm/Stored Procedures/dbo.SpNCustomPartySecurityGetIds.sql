Create Procedure SpNCustomPartySecurityGetIds
	@IsClient bit = 0,
	@IsLead bit = 0,
	@IsAdviser bit = 0,
	@IsAccount bit = 0,
	@IsGroup bit = 0,
	@IsUser bit = 0,
	@PartyRoleId tinyint output,
	@EntityId tinyint output
As


Declare @CRMContactEntityId int = 2, @PractitionerEntityId int = 5, @LeadEntityId int =7, @AccountEntityId int =8
Declare @ClientPartyRoleId int = 1, @LeadPartyRoleId int = 2, @AdviserPartyRoleId int = 3, 
	@AccountPartyRoleId int = 4, @GroupPartyRoleId int = 5, @UserPartyRoleId int = 6

If @IsClient = 1
Begin
	Select @PartyRoleId = @ClientPartyRoleId
	Select @EntityId = @CRMContactEntityId
End
Else If @IsAdviser = 1
Begin
	Select @PartyRoleId = @AdviserPartyRoleId
	Select @EntityId = @PractitionerEntityId
End
Else If @IsLead = 1
Begin
	Select @PartyRoleId = @LeadPartyRoleId
	Select @EntityId = @LeadEntityId
End
Else If @IsAccount = 1
Begin
	Select @PartyRoleId = @AccountPartyRoleId
	Select @EntityId = @AccountEntityId
End
Else If @IsGroup = 1
Begin
	Select @PartyRoleId = @GroupPartyRoleId
	Select @EntityId = null
End
Else If @IsUser = 1
Begin
	Select @PartyRoleId = @UserPartyRoleId
	Select @EntityId = null
End
Else
Begin
	Raiserror('@EntityId not found', 16, 1)
	return 1
End

return 0


