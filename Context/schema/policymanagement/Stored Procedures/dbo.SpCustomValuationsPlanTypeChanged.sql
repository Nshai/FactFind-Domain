Create Procedure dbo.SpCustomValuationsPlanTypeChanged
	@ProdProviderId bigint, 
	@PlanTypeId bigint,
	@ProdSubTypeId bigint
As

Declare @ErrorMessage varchar(max)
Declare @PolicyBusinessIds as dbo.PolicyBusinessIdListType


	Insert Into @PolicyBusinessIds
	( PolicyBusinessId )
	Select Distinct a.PolicyBusinessId
	From TPolicyBusiness a with(nolock)
	Join TPolicyDetail b with(nolock) on a.PolicyDetailId = b.PolicyDetailId
	Join TPlanDescription C with(nolock) on b.PlanDescriptionId = c.PlanDescriptionId
	Join TRefPlanType2ProdSubType D with(nolock) on c.RefPlanType2ProdSubTypeId = d.RefPlanType2ProdSubTypeId
	Join Administration..TIndigoClient E with(nolock) on b.IndigoClientId = e.IndigoClientId
	Where 1=1
	And C.RefProdProviderId = @ProdProviderId
	And D.RefPlanTypeId = @PlanTypeId
	And d.ProdSubTypeId = @ProdSubTypeId
	And e.Status = 'active'

	exec dbo.SpCustomValuationsMultiplePolicyBusinessChanged @PolicyBusinessIds = @PolicyBusinessIds
	

