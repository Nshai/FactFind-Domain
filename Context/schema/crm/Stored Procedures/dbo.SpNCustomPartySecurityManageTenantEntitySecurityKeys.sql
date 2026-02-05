Create Procedure SpNCustomPartySecurityManageTenantEntitySecurityKeys
	@TenantId bigint
As

----------------------------------------------
-- we either delete all records for tenant or apply all policies for tenant
----------------------------------------------

Declare @Status varchar(100), @Result int

Select @Status = status 
From administration..TIndigoClient
Where 1=1
And IndigoClientId = @TenantId

If @Status = 'active'
Begin

		exec @Result = SpNCustomPartySecurityManageEntitySecurityPolicyKeys @TenantId = @TenantId, @PolicyId = null
		If @Result > 0 return @Result

End
Else
Begin
	exec @Result = SpNCustomPartySecurityDeleteUserKeys @TenantId = @TenantId, @ForceDelete = 1
	If @Result > 0 return @Result
End

return 0

