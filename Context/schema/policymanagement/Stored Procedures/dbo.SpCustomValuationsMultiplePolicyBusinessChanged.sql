Create Procedure dbo.SpCustomValuationsMultiplePolicyBusinessChanged
	@PolicyBusinessIds dbo.PolicyBusinessIdListType READONLY
As

exec dbo.SpCustomValuationsPopulateValPotentialPlan @PolicyBusinessIds = @PolicyBusinessIds

exec dbo.SpCustomValuationsUpdateValEligibilityMask @PolicyBusinessIds = @PolicyBusinessIds

--exec dbo.SpCustomValuationsPopulateValScheduledPlan @PolicyBusinessIds = @PolicyBusinessIds
