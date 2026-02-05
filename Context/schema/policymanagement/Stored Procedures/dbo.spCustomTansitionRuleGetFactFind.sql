SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spCustomTansitionRuleGetFactFind] 
	@Owner1Id bigint, @Owner2Id bigint = null, @FactFindId bigint OUTPUT, @FactFindPrimaryOwnerId bigint OUTPUT
AS


If @Owner2Id IS NULL
Begin

	Select top 1 @FactFindId = factFindId, @FactFindPrimaryOwnerId = CRMcontactId1 
	from factfind..TFactFind
	Where CRMContactId1 = @Owner1Id
	
	-- See if owner is the second partner in a fact find
	if @FactFindId IS NULL
	Begin
	
		Select top 1 @FactFindId = factFindId, @FactFindPrimaryOwnerId = CRMcontactId1 
		from factfind..TFactFind
		Where CRMContactId2 = @Owner1Id
	
	End

End


if @Owner2Id IS NOT NULL
Begin

	Select top 1 @FactFindId = factFindId, @FactFindPrimaryOwnerId = CRMcontactId1 
	from factfind..TFactFind
	Where CRMContactId1 = @Owner1Id
	And CRMContactId2 = @Owner2Id

	-- try switch the owners if still null
	if @FactFindId IS NULL
	Begin
	
		Select top 1 @FactFindId = factFindId, @FactFindPrimaryOwnerId = CRMcontactId1 
		from factfind..TFactFind
		Where CRMContactId1 = @Owner2Id
		And CRMContactId2 = @Owner1Id
	
	End

End

--select @FactFindId, @FactFindPrimaryOwnerId
GO
