
Create Procedure dbo.SpCustomValuationsUserChanged 
	@UserPartyId bigint,
	@RefProdProviderId bigint
As

Declare @ErrorMessage varchar(max)


	Declare @PolicyBusinessIds as dbo.PolicyBusinessIdListType

	-- selling adviser
	Insert Into @PolicyBusinessIds
	( PolicyBusinessId )
	Select PolicyBusinessId
	From TPolicyBusiness a with(nolock)
	Join crm..TPractitioner b with(nolock) on a.PractitionerId = b.PractitionerId
	Join TPolicyDetail c with(nolock) on a.PolicyDetailId = c.PolicyDetailId
	Join TPlanDescription d with(nolock) on c.PlanDescriptionId = d.PlanDescriptionId
	Where 1=1
	And b.CRMContactId = @UserPartyId
	And d.RefProdProviderId = coalesce(@RefProdProviderId, d.RefProdProviderId)
	
	-- servicing adviser
	Insert Into @PolicyBusinessIds
	( PolicyBusinessId )
	Select Distinct a.PolicyBusinessId
	From TPolicyBusiness a with(nolock)
	Left Join @PolicyBusinessIds d on a.PolicyBusinessId = d.PolicyBusinessId
	Join TPolicyOwner b with(nolock) on a.PolicyDetailId = b.PolicyDetailId
	Join crm..TCRMContact c with(nolock) on b.CRMContactId = c.CRMContactId
	Join TPolicyDetail e with(nolock) on a.PolicyDetailId = e.PolicyDetailId
	Join TPlanDescription f with(nolock) on e.PlanDescriptionId = f.PlanDescriptionId
	Where 1=1
	And CurrentAdviserCRMId = @UserPartyId
	And d.PolicyBusinessId Is Null
	And f.RefProdProviderId = coalesce(@RefProdProviderId, f.RefProdProviderId)

	exec dbo.SpCustomValuationsMultiplePolicyBusinessChanged @PolicyBusinessIds = @PolicyBusinessIds
	

