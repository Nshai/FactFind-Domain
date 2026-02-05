Create Procedure SpNioCustomUpdateExternalApplicationAccess
	@TenantId bigint,
	@StampUserId bigint,
	@IsClient bit = null,
	@IsLead bit = null,
	@UserId bigint = null,
	@SecurityPolicyId bigint = null,
	@PartyId bigint = null,
	@ProcessAllUsers bit = null,
	@BulkProcessing bit = null
As

----------------------------------------------------
-- Usage
----------------------------------------------------
-- @UserId=28000 is SuperUser & @UserId=28001 is not SuperUser
-- @PartyId=6180630 is client & @PartyId=6180648 is lead
-- select _OwnerId, * from crm..TCRMContact where RefCRMContactStatusId=2 and _OwnerId is not null
-- @SecurityPolicyId=8035 entity is client && @SecurityPolicyId=8047 entity is lead
-- Select b.Identifier, a.*, c.Identifier From administration..TPolicy a join administration..TEntity b on a.EntityId = b.EntityId join administration..TRole c on a.RoleId = c.RoleId Where b.Identifier = 'lead'

-- Security policy changed
-- exec crm.dbo.SpNioCustomUpdateExternalApplicationAccess @TenantId=10155, @StampUserId=28000, @SecurityPolicyId=8035, @IsClient=1
-- exec crm.dbo.SpNioCustomUpdateExternalApplicationAccess @TenantId=10155, @StampUserId=28000, @SecurityPolicyId=8047, @IsLead=1
-- User changed
-- exec crm.dbo.SpNioCustomUpdateExternalApplicationAccess @TenantId=10155, @StampUserId=28000, @UserId=28000, @IsClient=1
-- exec crm.dbo.SpNioCustomUpdateExternalApplicationAccess @TenantId=10155, @StampUserId=28000, @UserId=28001, @IsClient=1
-- exec crm.dbo.SpNioCustomUpdateExternalApplicationAccess @TenantId=10155, @StampUserId=28000, @UserId=28000, @IsLead=1
-- Client/lead changed
-- exec crm.dbo.SpNioCustomUpdateExternalApplicationAccess @TenantId=10155, @StampUserId=28000, @PartyId=6180630, @IsClient=1 --, @UserId=28000
-- Update all
-- exec crm.dbo.SpNioCustomUpdateExternalApplicationAccess @TenantId=10155, @StampUserId=28000, @IsClient=1, @ProcessAllUsers=1
-- exec crm.dbo.SpNioCustomUpdateExternalApplicationAccess @TenantId=10155, @StampUserId=28000, @IsLead=1, @ProcessAllUsers=1

/*
 exec crm.dbo.SpNioCustomUpdateExternalApplicationAccess @TenantId=10155, @StampUserId=28000, @IsClient=1, @ProcessAllUsers=1
 exec crm.dbo.SpNioCustomUpdateExternalApplicationAccess @TenantId=10155, @StampUserId=28000, @IsLead=1, @ProcessAllUsers=1

*/
----------------------------------------------------

-- We added this shortcircuit in becasue of performance issues in the DB
-- There is a job that runs a few times per day to update tenant data
If IsNull(@ProcessAllUsers, 0) = 1 And IsNull(@BulkProcessing, 0) = 1
Begin
	Select 0 As [Result]
	Return
End

-- Check inputs
If IsNull(@SecurityPolicyId,0) > 0 and IsNull(@UserId,0) > 0
Begin
	Raiserror('When SecurityPolicy is specified then User must be null',16,1)
	return
End 

If IsNull(@SecurityPolicyId,0) = 0 and IsNull(@PartyId,0) = 0 and IsNull(@UserId,0) = 0 And IsNull(@ProcessAllUsers,0) = 0
Begin
	Raiserror('SecurityPolicy, ProcessAllUsers, Party and User cannot all be null', 16,1)
	return
End 

If IsNull(@TenantId,0) = 0
Begin
	Raiserror('Tenant cannot be null',16,1)
	return
End

If IsNull(@PartyId,0) > 0 and IsNull(@UserId,0) = 0
Begin
	Select @UserId = _OwnerId From crm..TCRMContact with(nolock) Where CRMContactId = @PartyId
End 

If IsNull(@PartyId,0) > 0 and  IsNull(@UserId,0) = 0
Begin
	-- the owner has not been set yet
	--Raiserror('When a party is specified then User cannot be null',16,1)
	return
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

----------------------------------------------------
-- Ignore tenants where the status is not active
If Not Exists(Select 1 From administration..TIndigoClient Where status = 'active' And IndigoClientId = @TenantId)
Begin
	Return
End


----------------------------------------------------
if OBJECT_ID('tempdb..#TempUsers') is not null
	Drop table #TempUsers
Create Table #TempUsers (LicensedUserId bigint, AccessibleUserId bigint, ForDelete bit default(0) )

Declare  @RoleId bigint,  @Sql nvarchar(max), @EntityId bigint, @EntityIdentifier varchar(25)

Select @EntityIdentifier = Case When IsNull(@IsClient, 0) = 1 Then 'CRMContact' When IsNull(@IsLead,0) = 1 Then 'Lead' Else 'not set' End
Select @EntityId = EntityId From administration..TEntity 
Where Descriptor = @EntityIdentifier

-- Select * From administration..TEntity 

If IsNull(@EntityId,0) = 0
Begin
	Raiserror('EntityId must be set',16,1)
	return
End

----------------------------------------------------
-- Security policy basis
If @SecurityPolicyId is not null
Begin
	Declare @EntityIdTemp bigint

	Select @EntityIdTemp = EntityId, @RoleId = RoleId 
	From administration..TPolicy with(nolock)
	Where PolicyId = @SecurityPolicyId

	If @EntityIdTemp <> @EntityId
	Begin
		return
	End
End

----------------------------------------------------
--  which users do implicict sync users have access to
Select @Sql = '

-- Entity security (user level) e.g. TCrmContactKey or TLeadKey
Insert Into #TempUsers (LicensedUserId, AccessibleUserId, ForDelete) 
Select distinct a.UserId, a.CreatorId , 0 ' 
	+ 'From ' + Db + '..T' + Descriptor + 'Key a with(nolock) ' 
	+ ' Join administration..TUser b with(nolock) on a.UserId = b.UserId '
	+ ' Where EntityId Is Null '
	+ ' And b.IndigoClientId = @TenantId '
	+ ' And b.RefUserTypeId = 1 '
	+ Case When IsNull(@ProcessAllUsers,0) = 0 And @UserId Is Not Null And @PartyId Is Null Then ' And a.UserId = @UserId ' Else '' End
	+ Case When IsNull(@ProcessAllUsers,0) = 0 And @UserId Is Not Null And @PartyId Is Not Null Then ' And a.CreatorId = @UserId ' Else '' End
	+ Case When IsNull(@ProcessAllUsers,0) = 0 And @RoleId Is Not Null Then ' And a.RoleId = @RoleId ' Else '' End
	-- + Case When @ProcessAllUsers Is Not Null Then
	--	' And A.UserId in (Select UserId From Administration..TUser Where IndigoClientId = @TenantId and SuperUser = 0) '
	--	Else '' End
	+ '
	
-- All users can see client''s/lead''s where they are the servicing adviser
Insert Into #TempUsers (LicensedUserId, AccessibleUserId, ForDelete) 
Select distinct a._OwnerId, a._OwnerId, 0 ' 
	+ 'From crm..TCRMContact a with(nolock) ' 
	+ ' Join administration..TUser b with(nolock) on a._OwnerId = b.UserId '
	+ ' Where 1=1 '
	+ ' And a.IndClientId = @TenantId '
	+ ' And b.IndigoClientId = @TenantId '
	+ ' And b.RefUserTypeId = 1 '
	+ ' And b.IsOutLookExtensionUser = 1 '
	+ Case When @UserId Is Not Null Then ' And B.UserId = @UserId ' Else '' End
	+ Case When @EntityIdentifier = 'CRMContact' Then ' and a._OwnerId is not null and a.RefCRMContactStatusId = 1  ' 
		   When @EntityIdentifier = 'Lead' Then ' and a.RefCRMContactStatusId = 2  ' Else '' End
	+ '

-- List users that SuperUsers/SuperViewer can see
Insert Into #TempUsers (LicensedUserId, AccessibleUserId, ForDelete) 
Select distinct a.UserId, b.UserId, Case When IsNull(a.IsOutLookExtensionUser,0) = 1 Then 0 Else 1 End
	From administration..TUser a with(nolock)
	cross join administration..TUser b with(nolock)
	Where 1=1
		And a.IndigoClientId = @TenantId And b.IndigoClientId = @TenantId And a.IndigoClientId = b.IndigoClientId
		And a.IsOutLookExtensionUser = 1
		And (a.SuperUser = 1 Or a.SuperViewer = 1)
		And a.RefUserTypeId = 1 And b.RefUserTypeId = 1 
		And a.UserId <> b.UserId '
	+ Case When IsNull(@ProcessAllUsers,0) = 0 And IsNull(@UserId,0) > 0 And IsNull(@PartyId,0) = 0 Then ' And a.UserId = @UserId ' Else '' End
From administration..TEntity 
Where EntityId = @EntityId

--select @Sql, @RoleId as 'role', @UserId as 'user', @TenantId as 'tenant'
exec sp_executesql @Sql, N'@RoleId bigint, @UserId bigint, @TenantId bigint', @RoleId, @UserId, @TenantId

if(IsNull(@ProcessAllUsers,0) > 0 or IsNull(@SecurityPolicyId,0) > 0)
Begin
	-- Get a list of user who might have had access

	-- The index on #TempUsers.LicensedUserId costs more to create that it saves when procesing a SecurityPolicy change for the 99 tenant
	--CREATE NONCLUSTERED INDEX [ix_tempUsers_LicensedUserId] ON [dbo].[#TempUsers] ([LicensedUserId])
	
	Insert Into #TempUsers 
	(LicensedUserId, AccessibleUserId, ForDelete) 
	Select a.UserId, a.UserId, 1
	From administration..TUser a
	Left Join #TempUsers b on a.UserId = b.LicensedUserId
	Where 1=1
	And IndigoClientId = @TenantId
	and b.LicensedUserId is null
End


---------------------------------------------------------------------------------------------------
-- mark user as deleted for users whose status is denied, archived or retired 
--		we should still be able to see items where the creator's status is one of the above

Update A
Set ForDelete = 1
From #TempUsers A
Join administration..TUser B On a.LicensedUserId = b.UserId And b.IndigoClientId = @TenantId
Where ForDelete = 0 And (Status Not Like 'Access Granted%' Or IsNull(IsOutLookExtensionUser,0) = 0)

Select @sql = '
Insert Into TExternalApplication' + @EntityIdentifier + 'Audit
(TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, 
	IsForUpdateSync, IsForDeleteSync, IsDeleted, ExternalApplication' + @EntityIdentifier + 'Id, StampAction, StampDateTime, StampUser)
Select distinct TenantId, A.UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, 
	IsForUpdateSync, IsForDeleteSync, IsDeleted, a.ExternalApplication' + @EntityIdentifier + 'Id, ''U'',GETDATE(), @StampUserId
From TExternalApplication' + @EntityIdentifier + ' a
Join #TempUsers b on a.UserId = b.LicensedUserId
Where b.ForDelete = 1 And A.IsDeleted <> 1 And a.TenantId = @TenantId

Update A
Set A.IsDeleted = 1, 
	A.LastUpdatedDateTime = Getdate(), 
	A.IsForDeleteSync = case when ValueSentToClient /* LastSynchronisedDateTime */ is null then 0 else 1 End,
	A.IsForNewSync = 0, 
	A.IsForUpdateSync = 0
From TExternalApplication' + @EntityIdentifier + ' a
Join #TempUsers b on a.UserId = b.LicensedUserId 
Where b.ForDelete = 1 And A.IsDeleted <> 1 And a.TenantId = @TenantId'

exec sp_executesql @Sql, N'@StampUserId bigint, @TenantId int', @StampUserId, @TenantId

if OBJECT_ID('tempdb..#TempUsers2') is not null
	Drop table #TempUsers2

select * into #TempUsers2 From #TempUsers where ForDelete = 0
Truncate table #TempUsers
Insert Into #TempUsers Select * From #TempUsers2

---------------------------------------------------------------------------------------------------
-- Client additions updates

if OBJECT_ID('tempdb..#TempParties') is not null
	Drop table #TempParties
Create Table #TempParties (PartyId bigint, LicensedUserId bigint, CreatedDate Datetime, LastStampDateTime datetime)

Select @Sql = '
-- Owners are other users who the user has access to via entity security
Insert Into #TempParties (PartyId, LicensedUserId, CreatedDate)
select distinct b.CRMContactId, a.LicensedUserId, b.CreatedDate
from #TempUsers a
join crm..TCRMContact b with(nolock) on a.AccessibleUserId = b._OwnerId
Where b.IndClientId = @TenantId And ArchiveFg = 0 ' 
+ Case	When @EntityIdentifier = 'CRMContact' Then ' and _OwnerId is not null and b.RefCRMContactStatusId = 1  ' 
		When @EntityIdentifier = 'Lead' Then ' and b.RefCRMContactStatusId = 2  ' Else '' End
+ Case	When @PartyId Is Not Null Then ' And b.CRMContactId = @PartyId ' Else '' End + '

-- Owners always have access to their clients
Insert Into #TempParties (PartyId, LicensedUserId, CreatedDate)
Select distinct b.CRMContactId, a.LicensedUserId, b.CreatedDate
from #TempUsers a
join crm..TCRMContact b with(nolock) on a.AccessibleUserId = b._OwnerId
Left Join #TempParties c on b.CRMContactId = c.PartyId And a.LicensedUserId = c.LicensedUserId
Where b.IndClientId = @TenantId And ArchiveFg = 0 ' 
+ ' And C.PartyId Is Null '
+ Case	When @EntityIdentifier = 'CRMContact' Then ' and _OwnerId is not null and b.RefCRMContactStatusId = 1  ' 
		When @EntityIdentifier = 'Lead' Then ' and b.RefCRMContactStatusId = 2  ' Else '' End
+ Case	When @PartyId Is Not Null Then ' And b.CRMContactId = @PartyId ' Else '' End

/*
select distinct b.CRMContactId, a.LicensedUserId
from #TempUsers a
join crm..TCRMContact b with(nolock) on a.AccessibleUserId = b._OwnerId
Left Join #TempParties c on b.CRMContactId = c.PartyId And a.AccessibleUserId = c.LicensedUserId
Where b.IndClientId = @TenantId And ArchiveFg = 0  ' 
+ ' And C.PartyId Is Null '
+ Case	When @EntityIdentifier = 'CRMContact' Then ' and _OwnerId is not null and b.RefCRMContactStatusId = 1  ' 
		When @EntityIdentifier = 'Lead' Then ' and b.RefCRMContactStatusId = 2  ' Else '' End
+ Case	When @PartyId Is Not Null Then ' And b.CRMContactId = @PartyId ' Else '' End*/

--select @Sql
exec sp_executesql @Sql, N'@PartyId bigint, @TenantId bigint', @PartyId, @TenantId
--select * From #TempParties order by PartyId
---------------------------------------------------------------------------------------------------

-- Check if a user has entity rights to a specific user
If @PartyId Is not Null
Begin
	Select @Sql = '
	Insert Into #TempParties (PartyId, LicensedUserId)
	Select K.EntityId, K.UserId 
	From ' + Db + '..T' + Descriptor + 'Key K with(nolock) 
	WHERE K.EntityId Is Not Null and k.UserId is not null 
		And k.EntityId = @PartyId

	Insert Into #TempParties (PartyId, LicensedUserId)
	Select K.EntityId, K.UserId 
	From ' + Db + '..T' + Descriptor + 'Key K with(nolock) 
	Join administration..TMembership M ON M.RoleId = K.RoleId
	WHERE K.EntityId IS NOT NULL and k.RoleId is not null
		And k.EntityId = @PartyId '
	From administration..TEntity 
	Where EntityId = @EntityId
	
	exec sp_executesql @Sql, N'@PartyId bigint', @PartyId
End

----------------------------------------------------------------------------------------------------------------------------------------------
-- Determine the last datetime when FirstName/LastName/ExternalReference was changed
----------------------------------------------------------------------------------------------------------------------------------------------
-- Print 'Update create date'
Update a
Set a.CreatedDate = b.CreatedDate
From #TempParties a
Join TCRMContact b on a.PartyId = b.CRMContactId
Where 1=1
And IndClientId=@TenantId
And a.CreatedDate is null

if OBJECT_ID('tempdb..#TempPartiesAudit1') is not null
	Drop table #TempPartiesAudit1
Create table #TempPartiesAudit1(Id int identity(1,1) , PartyId int, [Text] varchar(1000), StampDateTime datetime)

print 'From Audit table'
Insert Into #TempPartiesAudit1 (PartyId, StampDateTime, [Text] )
Select a.CRMContactId, a.StampDateTime, CASE WHEN a.CorporateId IS NOT NULL THEN IsNull(a.CorporateName, '') + '|' + IsNull(a.ExternalReference,'')
ELSE IsNull(a.FirstName,'') + '|' + IsNull(a.LastName,'') + '|' + IsNull(a.ExternalReference,'') END
From TCRMContactAudit a with(nolock)
Join #TempParties b with(nolock) on a.CRMContactId = b.PartyId
Where IndClientId=@TenantId --  and RefCRMContactStatusId = 1 
and a.StampDateTime > DATEADD(week, -1, getdate())
Order by AuditId

print 'From Main table'
Insert Into #TempPartiesAudit1 (PartyId, StampDateTime, [Text])
Select a.CRMContactId , GETDATE(), CASE WHEN a.CorporateId IS NOT NULL THEN IsNull(a.CorporateName, '') + '|' + IsNull(a.ExternalReference,'')
ELSE IsNull(a.FirstName,'') + '|' + IsNull(a.LastName,'') + '|' + IsNull(a.ExternalReference,'') END
From TCRMContact a
Join #TempParties b on a.CRMContactId = b.PartyId
Join #TempPartiesAudit1 c on b.PartyId = c.PartyId
Where  1=1 --and RefCRMContactStatusId = 1 
And a.IndClientId = @TenantId

if OBJECT_ID('tempdb..#TempPartiesAudit2') is not null
	Drop table #TempPartiesAudit2
Create table #TempPartiesAudit2(Id int identity(1,1) , PartyId int, [Text] varchar(1000), StampDateTime datetime)

 Print 'Order data from Main + Audit table'
Insert Into #TempPartiesAudit2 (PartyId, [Text], StampDateTime)
Select PartyId, [Text], StampDateTime
From #TempPartiesAudit1
Order by PartyId, Id

-- Print 'Update LastStampDateTime'
Update a
Set LastStampDateTime = case when b.PartyId is null then a.CreatedDate else b.StampDateTime End
From #TempParties a
Left Join 
(
	Select a.PartyId, Max(a.StampDateTime) as StampDateTime
	From #TempPartiesAudit2 a
	Join #TempPartiesAudit2 b on a.PartyId=b.PartyId and a.Id = b.Id -1 and a.[text] <> b.[text]
	Group by a.PartyId
) as b on a.PartyId = b.PartyId

if OBJECT_ID('tempdb..#Ids') is not null
	Drop table #Ids

Create Table #Ids (ExternalApplicationClientOrLeadId bigint)

---------------------------------------------------------------------------------------------------
-- Add new ones
Select @Sql = 'Insert Into TExternalApplication' + @EntityIdentifier + '
(TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, IsForNewSync)
output inserted.ExternalApplication' + @EntityIdentifier + 'Id Into #Ids
Select @TenantId, a.LicensedUserId, a.PartyId, getdate(), GETDATE(), null, 1
from #TempParties a
Left Join TExternalApplication' + @EntityIdentifier + ' c on a.LicensedUserId = c.UserId and a.PartyId = c.PartyId And TenantId = @TenantId
Where c.ExternalApplication' + @EntityIdentifier + 'Id is null

Insert Into TExternalApplication' + @EntityIdentifier + 'Audit
(TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, 
	IsForUpdateSync, IsForDeleteSync, IsDeleted, ExternalApplication' + @EntityIdentifier + 'Id, StampAction, StampDateTime, StampUser)
Select TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, 
	IsForUpdateSync, IsForDeleteSync, IsDeleted, a.ExternalApplication' + @EntityIdentifier + 'Id, ''C'',GETDATE(), @StampUserId
From TExternalApplication' + @EntityIdentifier + ' a
Join #Ids b on a.ExternalApplication' + @EntityIdentifier + 'Id = b.ExternalApplicationClientOrLeadId And a.TenantId = @TenantId'


exec sp_executesql @Sql, N'@StampUserId bigint, @TenantId int', @StampUserId, @TenantId


truncate table #Ids


---------------------------------------------------------------------------------------------------
-- Undelete existing ones
Select @sql = '
Insert Into #Ids
(ExternalApplicationClientOrLeadId)
Select ExternalApplication' + @EntityIdentifier + 'Id
From TExternalApplication' + @EntityIdentifier + ' a
Join #TempParties c on a.UserId = c.LicensedUserId and a.PartyId = c.PartyId 
Where IsDeleted = 1 And TenantId = @TenantId

Insert Into TExternalApplication' + @EntityIdentifier + 'Audit
(TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, 
	IsForUpdateSync, IsForDeleteSync, IsDeleted, ExternalApplication' + @EntityIdentifier + 'Id, StampAction, StampDateTime, StampUser)
Select TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, 
	IsForUpdateSync, IsForDeleteSync, IsDeleted, a.ExternalApplication' + @EntityIdentifier + 'Id, ''U'',GETDATE(), @StampUserId
From TExternalApplication' + @EntityIdentifier + ' a
Join #Ids b on a.ExternalApplication' + @EntityIdentifier + 'Id = b.ExternalApplicationClientOrLeadId
Where TenantId = @TenantId

Update A
Set IsDeleted = 0, LastUpdatedDateTime = Getdate(), LastSynchronisedDateTime = null, 
	IsForDeleteSync = 0, IsForNewSync = 1, IsForUpdateSync = 0
From TExternalApplication' + @EntityIdentifier + ' A
Join #Ids B On A.ExternalApplication' + @EntityIdentifier + 'Id = b.ExternalApplicationClientOrLeadId 
Where TenantId = @TenantId

'

exec sp_executesql @Sql, N'@StampUserId bigint, @TenantId int', @StampUserId, @TenantId

truncate table #Ids

---------------------------------------------------------------------------------------------------
-- Update existing ones
Select @sql = '
Insert Into #Ids
(ExternalApplicationClientOrLeadId)
Select ExternalApplication' + @EntityIdentifier + 'Id
From TExternalApplication' + @EntityIdentifier + ' a
Join #TempParties c on a.UserId = c.LicensedUserId and a.PartyId = c.PartyId 
Where 1=1
	And IsForNewSync = 0 And IsForUpdateSync = 0 And IsDeleted = 0
	And c.LastStampDateTime > a.LastUpdatedDateTime
	And TenantId = @TenantId

Insert Into TExternalApplication' + @EntityIdentifier + 'Audit
(TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, 
	IsForUpdateSync, IsForDeleteSync, IsDeleted, ExternalApplication' + @EntityIdentifier + 'Id, StampAction, StampDateTime, StampUser)
Select TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, 
	IsForUpdateSync, IsForDeleteSync, IsDeleted, a.ExternalApplication' + @EntityIdentifier + 'Id, ''U'',GETDATE(), @StampUserId
From TExternalApplication' + @EntityIdentifier + ' a
Join #Ids b on a.ExternalApplication' + @EntityIdentifier + 'Id = b.ExternalApplicationClientOrLeadId
Where TenantId = @TenantId

Update A
Set IsDeleted = 0, LastUpdatedDateTime = Getdate(), LastSynchronisedDateTime = null, 
	IsForDeleteSync = 0, IsForNewSync = 0, IsForUpdateSync = 1
From TExternalApplication' + @EntityIdentifier + ' A
Join #Ids B On A.ExternalApplication' + @EntityIdentifier + 'Id = b.ExternalApplicationClientOrLeadId 
Where TenantId = @TenantId

'

exec sp_executesql @Sql, N'@StampUserId bigint, @TenantId int', @StampUserId, @TenantId


truncate table #Ids
---------------------------------------------------------------------------------------------------
-- Update new records where they have been updated before they were synced
Select @sql = '
Insert Into #Ids
(ExternalApplicationClientOrLeadId)
Select ExternalApplication' + @EntityIdentifier + 'Id
From TExternalApplication' + @EntityIdentifier + ' a
Join #TempParties c on a.UserId = c.LicensedUserId and a.PartyId = c.PartyId 
Where 1=1
	And IsForNewSync = 1 And IsForUpdateSync = 0 And IsDeleted = 0
	And c.LastStampDateTime > a.LastUpdatedDateTime
	And a.ValueSentToClient Is Null
	And TenantId = @TenantId

Insert Into TExternalApplication' + @EntityIdentifier + 'Audit
(TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, 
	IsForUpdateSync, IsForDeleteSync, IsDeleted, ExternalApplication' + @EntityIdentifier + 'Id, StampAction, StampDateTime, StampUser)
Select TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, 
	IsForUpdateSync, IsForDeleteSync, IsDeleted, a.ExternalApplication' + @EntityIdentifier + 'Id, ''U'',GETDATE(), @StampUserId
From TExternalApplication' + @EntityIdentifier + ' a
Join #Ids b on a.ExternalApplication' + @EntityIdentifier + 'Id = b.ExternalApplicationClientOrLeadId
Where TenantId = @TenantId

Update A
Set LastUpdatedDateTime = GetDate()
From TExternalApplication' + @EntityIdentifier + ' A
Join #Ids B On A.ExternalApplication' + @EntityIdentifier + 'Id = b.ExternalApplicationClientOrLeadId 
Where TenantId = @TenantId

'

exec sp_executesql @Sql, N'@StampUserId bigint, @TenantId int', @StampUserId, @TenantId

truncate table #Ids

---------------------------------------------------------------------------------------------------
-- delete previous ones
Select @Sql = 'Insert Into #Ids
(ExternalApplicationClientOrLeadId)
Select ExternalApplication' + @EntityIdentifier + 'Id
From TExternalApplication' + @EntityIdentifier + ' a
Join #TempParties c on a.UserId = c.LicensedUserId 
Where IsDeleted = 0 and c.PartyId is null And TenantId = @TenantId

Insert Into #Ids
(ExternalApplicationClientOrLeadId)
Select ExternalApplication' + @EntityIdentifier + 'Id
From TExternalApplication' + @EntityIdentifier + ' a
Join #TempParties c on a.PartyId = c.LicensedUserId 
Where IsDeleted = 0 and c.LicensedUserId is null And TenantId = @TenantId

If @PartyId is not null and not exists(Select top 1 1 from #TempParties)
Begin
	Insert Into #Ids
	(ExternalApplicationClientOrLeadId)
	Select ExternalApplication' + @EntityIdentifier + 'Id
	From TExternalApplication' + @EntityIdentifier + ' a
	Where IsDeleted = 0 and a.PartyId = @PartyId And TenantId = @TenantId
End

If @UserId is not Null And Not Exists(Select top 1 1 From #TempParties)
Begin
	Insert Into #Ids
	(ExternalApplicationClientOrLeadId)
	Select ExternalApplication' + @EntityIdentifier + 'Id
	From TExternalApplication' + @EntityIdentifier + ' a
	Where a.UserId = @UserId and IsDeleted = 0 And TenantId = @TenantId
End

Insert Into TExternalApplication' + @EntityIdentifier + 'Audit
(TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, 
	IsForUpdateSync, IsForDeleteSync, IsDeleted, ExternalApplication' + @EntityIdentifier + 'Id, StampAction, StampDateTime, StampUser)
Select TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, 
	IsForUpdateSync, IsForDeleteSync, IsDeleted, a.ExternalApplication' + @EntityIdentifier + 'Id, ''U'',GETDATE(), @StampUserId
From TExternalApplication' + @EntityIdentifier + ' a
Join #Ids b on a.ExternalApplication' + @EntityIdentifier + 'Id = b.ExternalApplicationClientOrLeadId
Where TenantId = @TenantId

Update A
Set IsDeleted = 1, 
	LastUpdatedDateTime = Getdate(), 
	IsForDeleteSync = case when ValueSentToClient /* LastSynchronisedDateTime */ is null then 0 else 1 End,
	IsForNewSync = 0, 
	IsForUpdateSync = 0
From TExternalApplication' + @EntityIdentifier + ' a
Join #Ids b on a.ExternalApplication' + @EntityIdentifier + 'Id = b.ExternalApplicationClientOrLeadId 
Where TenantId = @TenantId

'

exec sp_executesql @Sql, N'@StampUserId bigint, @PartyId bigint, @UserId bigint, @TenantId int', @StampUserId, @PartyId, @UserId, @TenantId


---------------------------------------------------------------------------------------------------
-- delete archived ones
-- I'm not sure what the above sql is up to but I'm too scared to change it, the
-- following statement makes sure that any archived items are marked for deletion.
truncate table #Ids

Select @Sql = 'Insert Into #Ids (ExternalApplicationClientOrLeadId)
Select ExternalApplication' + @EntityIdentifier + 'Id
From 
	TExternalApplication' + @EntityIdentifier + ' A
	Join TCRMContact C ON C.CRMContactId = A.PartyId
WHERE 
	A.TenantId = @TenantId AND C.IndClientId = @TenantId 
	AND A.IsDeleted = 0 AND C.ArchiveFg = 1

Insert Into TExternalApplication' + @EntityIdentifier + 'Audit (
	TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, 
	IsForUpdateSync, IsForDeleteSync, IsDeleted, ExternalApplication' + @EntityIdentifier + 'Id, StampAction, StampDateTime, StampUser)
Select 
	TenantId, UserId, PartyId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime, ValueSentToClient, IsForNewSync, 
	IsForUpdateSync, IsForDeleteSync, IsDeleted, a.ExternalApplication' + @EntityIdentifier + 'Id, ''U'',GETDATE(), @StampUserId
From TExternalApplication' + @EntityIdentifier + ' a
Join #Ids b on a.ExternalApplication' + @EntityIdentifier + 'Id = b.ExternalApplicationClientOrLeadId
Where TenantId = @TenantId

Update A
Set IsDeleted = 1, 
	LastUpdatedDateTime = Getdate(), 
	IsForDeleteSync = case when ValueSentToClient /* LastSynchronisedDateTime */ is null then 0 else 1 End,
	IsForNewSync = 0, 
	IsForUpdateSync = 0
From TExternalApplication' + @EntityIdentifier + ' a
Join #Ids b on a.ExternalApplication' + @EntityIdentifier + 'Id = b.ExternalApplicationClientOrLeadId 
Where TenantId = @TenantId
'

exec sp_executesql @Sql, N'@StampUserId bigint, @TenantId int', @StampUserId, @TenantId

-- the nhibernate code needs something to be returned
if IsNull(@UserId,0) > 0
Begin
	Select @Sql = 'select count(1) As [Result] From TExternalApplication' + @EntityIdentifier + ' where UserId = @UserId And TenantId = @TenantId'
	exec sp_executesql @Sql, N'@UserId bigint, @TenantId int', @UserId, @TenantId
End
Else
Begin
	Select 0 As [Result]
End
