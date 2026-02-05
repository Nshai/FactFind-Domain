Create Procedure SpNCustomPartySecurityRouting
	@ChangeLogId bigint
As

return 

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
-------------- 
-- This is called by transform engine (Stage2) and decidies which sp(s) to call to hanndle the event
--------------

--set nocount on 
Declare @TenantId int, @PKValue int , @TableName varchar(1000), @Result int, @ExtraData varchar(1000)

Select @PKValue = PKValue, @TenantId = TenantId, @TableName = TableName, @ExtraData = ExtraData
From sdb..TChangeLogStage2
Where 1=1
And Applied Is Null
And ChangeLogId = @ChangeLogId


If @@ROWCOUNT = 0
Begin
	return 0
End

If @TableName = 'EntitySecurityPolicyChanged'
Begin
	Exec @Result = dbo.SpNCustomPartySecurityManageEntitySecurityPolicyKeys @TenantId = @TenantId, @PolicyId = @PKValue
End
Else If @TableName = 'ClientServicingAdviserChanged' OR @TableName = 'LeadServicingAdviserChanged' OR @TableName = 'AccountOwnerChanged'
Begin
	Exec @Result = dbo.SpNCustomPartySecurityManageCRMContactOwnerKeys @TenantId = @TenantId, @PartyId = @PKValue
End
Else If @TableName = 'AdviserAdded'
Begin
	Exec @Result = dbo.SpNCustomPartySecurityManageAdviserKeys @TenantId = @TenantId, @AdviserId = @PKValue
End
Else If @TableName = 'UserChanged' Or @TableName = 'UserMembershipChanged'
Begin
	Exec @Result = dbo.SpNCustomPartySecurityDeleteUserKeys @TenantId = 10155, @UserId = @PKValue
	Exec @Result = dbo.SpNCustomPartySecurityManageNonAdviserUserKeys @TenantId = @TenantId, @UserId = @PKValue, @ExtraData = @ExtraData
	Exec @Result = dbo.SpNCustomPartySecurityManageUserEntityKeys @TenantId = @TenantId, @UserId = @PKValue, @ExtraData = @ExtraData
End
Else If @TableName = 'ClientShareChanged'
Begin
	Exec @Result = dbo.SpNCustomPartySecurityManageClientShareKeys @TenantId = @TenantId, @ClientShareId = @PKValue
End
Else If @TableName = 'TenantStatusChanged' Or  @TableName = 'GroupHierarchyChanged'
Begin
	Exec @Result = dbo.SpNCustomPartySecurityDeleteUserKeys @TenantId = @TenantId, @ForceDelete=1
	Exec @Result = dbo.SpNCustomPartySecurityManageNonAdviserUserKeys @TenantId = @TenantId
	Exec @Result = dbo.SpNCustomPartySecurityManageGroupKeys @TenantId = @TenantId
	Exec @Result = dbo.SpNCustomPartySecurityManageTenantEntitySecurityKeys @TenantId = @TenantId
End
Else
Begin
	Declare @Message varchar(100) = 'TableName not found: ' + @TableName
	Raiserror(@Message, 16, 1)
	return 1
End

return @Result


