Create Procedure SpNCustomPartySecurityGetIdsForEntityId
	@EntityId int,
	@IsClient bit output,
	@IsLead bit output,
	@IsAdviser bit output,
	@IsAccount bit output,
	@PartyRoleId tinyint output
As


Declare @CRMContactEntityId int = 2, @PractitionerEntityId int = 5, @LeadEntityId int =7, @AccountEntityId int =8
Declare @ClientPartyRoleId int = 1, @LeadPartyRoleId int = 2, @AdviserPartyRoleId int = 3, 
	@AccountPartyRoleId int = 4, @GroupPartyRoleId int = 5, @UserPartyRoleId int = 6

Select @IsClient = 0, @IsLead = 0, @IsAdviser = 0, @IsAccount = 0
If @EntityId = @CRMContactEntityId
Begin
	Select @PartyRoleId = @ClientPartyRoleId
	Select @IsClient = 1
End
Else If @EntityId = @PractitionerEntityId
Begin
	Select @PartyRoleId = @AdviserPartyRoleId
	Select @IsAdviser = 1
End
Else If @EntityId = @LeadEntityId
Begin
	Select @PartyRoleId = @LeadPartyRoleId
	Select @IsLead = 1
End
Else If @EntityId = @AccountEntityId
Begin
	Select @PartyRoleId = @AccountPartyRoleId
	Select @IsAccount = 1
End
Else
Begin
	Raiserror('@EntityId not found', 16, 1)
	return 1
End

return 0

