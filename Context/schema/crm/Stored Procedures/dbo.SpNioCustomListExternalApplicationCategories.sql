Create Procedure SpNioCustomListExternalApplicationCategories
	@TenantId bigint,
	@UserId bigint,
	@TopNRecords int,
	@NewItems bit,
	@UpdatedItems bit,
	@DeletedItems bit,
	@IsLead bit = null,
	@IsClient bit = null
As

If IsNull(@TenantId,0) = 0
Begin
	Raiserror('TenantId null', 16,1)
	Return
End

If IsNull(@UserId,0) = 0
Begin
	Raiserror('UserId null', 16,1)
	Return
End

If IsNull(@TopNRecords,0) = 0
Begin
	Raiserror('TopNRecords null', 16,1)
	Return
End


If IsNull(@IsClient,0) = 0 And IsNull(@IsLead,0) = 0
Begin
	Raiserror('IsClient And IsLead cannot both be null',16,1)
	return
End

If IsNull(@IsClient,0) = 1 And IsNull(@IsLead,0) = 1
Begin
	Raiserror('IsClient And IsLead cannot both be set',16,1)
	return
End

Declare @Sql nvarchar(max), @EntityIdentifier varchar(25)

Select @EntityIdentifier = Case When IsNull(@IsClient, 0) = 1 Then 'CRMContact' When IsNull(@IsLead,0) = 1 Then 'Lead' Else 'not set' End



-- select * From TExternalApplicationClient
-- Update TExternalApplicationClient set IsForNewSync=1
-- exec SpNioCustomListClientCategories @TenantId = 10155, @UserId = 28000, @TopNRecords = 3, @NewItems = 1
-- exec SpNioCustomListClientCategories @TenantId = 10155, @UserId = 28003, @TopNRecords = 2, @NewItems = 1



Declare @LastSynchronisedDateTime datetime = getdate()

if OBJECT_ID('tempdb..#Ids') is not null
	Drop table #Ids
Create Table #Ids (Id bigint, OldValueSentToClient varchar(150), Deleting bit Default 0)

Declare @IsForNewSync bit, @IsForUpdateSync bit, @IsForDeleteSync bit

SET ROWCOUNT @TopNRecords

If @NewItems = 1
Begin
	Select @Sql = 'Insert Into #Ids
	(Id, OldValueSentToClient)
	Select ExternalApplication' + @EntityIdentifier + 'Id, ValueSentToClient
	From TExternalApplication' + @EntityIdentifier + '
	Where 1=1
		And TenantId = @TenantId 
		And UserId = @UserId
		-- And CreatedDateTime = LastUpdatedDateTime
		And IsForNewSync = 1
		-- And LastSynchronisedDateTime Is Null
		And IsDeleted = 0 '
	Exec sp_executesql @Sql, N'@TenantId int, @UserId bigint', @TenantId, @UserId

	Select @IsForNewSync = 0, @IsForUpdateSync = 0, @IsForDeleteSync = null
End
Else If @UpdatedItems = 1
Begin
	Select @Sql = 'Insert Into #Ids
	(Id, OldValueSentToClient)
	Select ExternalApplication' + @EntityIdentifier + 'Id, ValueSentToClient
	From TExternalApplication' + @EntityIdentifier + '
	Where 1=1
		And TenantId = @TenantId 
		And UserId = @UserId
		And IsForUpdateSync = 1
		And IsForNewSync = 0
		And IsDeleted = 0 '
	Exec sp_executesql @Sql, N'@TenantId int, @UserId bigint', @TenantId, @UserId

	Select @IsForNewSync = 0, @IsForUpdateSync = 0, @IsForDeleteSync = null
End
Else If @DeletedItems = 1
Begin
	Select @Sql = 'Insert Into #Ids
	(Id, OldValueSentToClient, Deleting)
	Select ExternalApplication' + @EntityIdentifier + 'Id, ValueSentToClient, 1
	From TExternalApplication' + @EntityIdentifier + '
	Where 1=1
		And TenantId = @TenantId 
		And UserId = @UserId
		And IsForDeleteSync = 1
		And IsDeleted = 1 '
	Exec sp_executesql @Sql, N'@TenantId int, @UserId bigint', @TenantId, @UserId

	Select @IsForNewSync = 0, @IsForUpdateSync = 0, @IsForDeleteSync = 0
End
Else
Begin
	Raiserror('New, updated or deleted items must be specified', 16, 1)
	Return
End


SET ROWCOUNT 0


Select @Sql = '
Insert Into TExternalApplication' + @EntityIdentifier + 'Audit
(TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, IsForUpdateSync, IsForDeleteSync, IsDeleted,
	ExternalApplication' + @EntityIdentifier + 'Id, StampAction, StampDateTime, StampUser) 
Select TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, IsForUpdateSync, IsForDeleteSync, A.IsDeleted,
	A.ExternalApplication' + @EntityIdentifier + 'Id, ''U'', GetDate(), @UserId
From TExternalApplication' + @EntityIdentifier + ' A
Join #Ids B On A.ExternalApplication' + @EntityIdentifier + 'Id = b.Id
Join TCRMContact d on a.PartyId = d.CRMContactId 
Where TenantId = @TenantId

Update A
Set LastSynchronisedDateTime = @LastSynchronisedDateTime, 
	IsForNewSync = Case When @IsForNewSync is null Then IsForNewSync Else @IsForNewSync End, 
	IsForUpdateSync = Case When @IsForUpdateSync is null Then IsForUpdateSync Else @IsForUpdateSync End,
	IsForDeleteSync = Case When @IsForDeleteSync is null Then IsForDeleteSync Else @IsForDeleteSync End,
	ValueSentToClient = Case When B.Deleting = 1 Then ValueSentToClient 
							When B.Deleting = 0 And d.PersonId Is Null 
								Then Left(LTrim(RTrim(IsNull(CorporateName,''''))), 50) 
									+ '' ('' + LTrim(RTrim(IsNull(ExternalReference,''''))) + '') ['' + CONVERT(varchar(50), d.CrmContactId) + '']'' 
								Else Left(LTrim(RTrim(IsNull(FirstName,''''))), 50) + '' '' 
									+ Left(LTrim(RTrim(IsNull(LastName,''''))), 50) 
									+ '' ('' + LTrim(RTrim(IsNull(ExternalReference,''''))) + '') ['' + CONVERT(varchar(50), d.CrmContactId) + '']'' End
From TExternalApplication' + @EntityIdentifier + ' A
Join #Ids B On A.ExternalApplication' + @EntityIdentifier + 'Id = b.Id
Join TCRMContact d on a.PartyId = d.CRMContactId 
Where TenantId = @TenantId

Select ValueSentToClient, OldValueSentToClient
From TExternalApplication' + @EntityIdentifier + ' a
Join #Ids c on a.ExternalApplication' + @EntityIdentifier + 'Id = c.Id
Where 1=1
	And TenantId = @TenantId 
	And UserId = @UserId
	And LastSynchronisedDateTime = @LastSynchronisedDateTime '

Exec sp_executesql @Sql, 
		N'@TenantId int, @UserId bigint, @LastSynchronisedDateTime datetime, @IsForNewSync bit, @IsForUpdateSync bit, @IsForDeleteSync bit',
		@TenantId, @UserId, @LastSynchronisedDateTime, @IsForNewSync, @IsForUpdateSync, @IsForDeleteSync


