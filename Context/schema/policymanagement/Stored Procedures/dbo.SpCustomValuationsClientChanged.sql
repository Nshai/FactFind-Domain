Create Procedure SpCustomValuationsClientChanged
	@PartyId bigint
As

Declare @ErrorMessage varchar(max)
Declare @PolicyBusinessIds as dbo.PolicyBusinessIdListType

	Insert Into @PolicyBusinessIds
	( PolicyBusinessId )
	Select Distinct a.PolicyBusinessId
	From TPolicyBusiness a with(nolock)
	Join TPolicyOwner b with(nolock) on a.PolicyDetailId = b.PolicyDetailId
	Join crm..TCRMContact c with(nolock) on b.CRMContactId = c.CRMContactId
	Where 1=1
	And b.CRMContactId = @PartyId

	exec dbo.SpCustomValuationsMultiplePolicyBusinessChanged @PolicyBusinessIds = @PolicyBusinessIds
	
