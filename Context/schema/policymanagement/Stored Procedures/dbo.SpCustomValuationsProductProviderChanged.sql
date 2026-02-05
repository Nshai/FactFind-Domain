
Create Procedure dbo.SpCustomValuationsProductProviderChanged 
	@RefProdProviderId bigint, 
	@TenantId bigint = null
As

Declare @ErrorMessage varchar(max)

	Declare @PolicyBusinessIds as dbo.PolicyBusinessIdListType
	If IsNull(@TenantId,0) <= 0
		Set @TenantId = null

	Insert Into @PolicyBusinessIds
	( PolicyBusinessId )
	Select PolicyBusinessId
	From TPolicyBusiness a with(nolock)
	Join TPolicyDetail b with(nolock) on a.PolicyDetailId = b.PolicyDetailId
	Join TPlanDescription c with(nolock) on b.PlanDescriptionId = c.PlanDescriptionId
	Where c.RefProdProviderId = @RefProdProviderId
	And a.IndigoClientId = Coalesce(@TenantId, a.IndigoClientId)
	
	exec dbo.SpCustomValuationsMultiplePolicyBusinessChanged @PolicyBusinessIds = @PolicyBusinessIds
	
