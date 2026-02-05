
Create Procedure SpNioCustomResetExternalApplicationCategories
	@TenantId bigint,
	@UserId bigint,
	@IsLead bit = null,
	@IsClient bit = null
As

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

Select @Sql = 'Insert Into TExternalApplication' + @EntityIdentifier + 'Audit
(TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, IsForUpdateSync, IsForDeleteSync, IsDeleted,
	ExternalApplication' + @EntityIdentifier + 'Id, StampAction, StampDateTime, StampUser) 
Select TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, IsForUpdateSync, IsForDeleteSync, IsDeleted,
	A.ExternalApplication' + @EntityIdentifier + 'Id, ''U'', GetDate(), @UserId
From TExternalApplication' + @EntityIdentifier + ' A
Where 1=1
	And a.TenantId = @TenantId
	And a.UserId = @UserId
	And IsDeleted = 0

Update TExternalApplication' + @EntityIdentifier + '
Set IsForNewSync = 1, IsForUpdateSync = 0, IsForDeleteSync = 0
Where 1=1
	And TenantId = @TenantId
	And UserId = @UserId
	And IsDeleted = 0
'

exec sp_executesql @Sql, N'@TenantId bigint, @UserId bigint', @TenantId, @UserId


select 1
