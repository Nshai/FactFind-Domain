SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


Create Procedure [dbo].[SpNioCustomUpdateExternalApplicationForPartyChangesNoSelect1]
	@TenantId bigint,
	@StampUserId bigint,
	@PartyId bigint,
	@IsClient bit = null,
	@IsLead bit = null
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

Select @EntityIdentifier = Case When IsNull(@IsClient, 0) = 1 Then 'CRMContact' When IsNull(@IsLead,0) = 1 Then 'Lead' Else '_not_set' End


Select @Sql = 'Insert Into TExternalApplication' + @EntityIdentifier + 'Audit
(TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, 
	IsForUpdateSync, IsForDeleteSync, IsDeleted, ExternalApplication' + @EntityIdentifier + 'Id, StampAction, StampDateTime, StampUser)
Select TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, 
	IsForUpdateSync, IsForDeleteSync, IsDeleted, a.ExternalApplication' + @EntityIdentifier + 'Id, ''U'',GETDATE(), @StampUserId
From TExternalApplication' + @EntityIdentifier + ' a
Where TenantId = @TenantId and PartyId = @PartyId and IsDeleted = 0 and IsForNewSync = 0 And IsForUpdateSync = 0


Update TExternalApplication' + @EntityIdentifier + '
Set LastUpdatedDateTime = GETDATE(), IsForUpdateSync = 1
Where TenantId = @TenantId and PartyId = @PartyId and IsDeleted = 0 and IsForNewSync = 0 And IsForUpdateSync = 0 '

exec sp_executesql @sql, N'@TenantId int, @PartyId bigint, @StampUserId bigint', @TenantId, @PartyId, @StampUserId


GO
