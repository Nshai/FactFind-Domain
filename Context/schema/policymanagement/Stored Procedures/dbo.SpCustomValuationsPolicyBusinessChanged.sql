Create Procedure SpCustomValuationsPolicyBusinessChanged
	@PolicyBusinessId bigint
As


Declare @PolicyBusinessIds as dbo.PolicyBusinessIdListType

Insert Into @PolicyBusinessIds
( PolicyBusinessId )
Values(@PolicyBusinessId)

if exists(
			select 1 
			from twrapperpolicybusiness wpb with (nolock) 
					join TValPotentialPlan pp with (nolock) on wpb.PolicyBusinessId = pp.PolicyBusinessId
					 left join @PolicyBusinessIds inalready on wpb.PolicyBusinessId = inalready.PolicyBusinessId
			where ParentPolicyBusinessId = @PolicyBusinessId and inalready.PolicyBusinessId is null
		 )
begin
	insert into @PolicyBusinessIds
		select distinct wpb.PolicyBusinessId
			from twrapperpolicybusiness wpb with (nolock) 
					join TValPotentialPlan pp with (nolock) on wpb.PolicyBusinessId = pp.PolicyBusinessId
					 left join @PolicyBusinessIds inalready on wpb.PolicyBusinessId = inalready.PolicyBusinessId
			where ParentPolicyBusinessId = @PolicyBusinessId and inalready.PolicyBusinessId is null
end

if exists(
			select 1
			from twrapperpolicybusiness wpb with (nolock) left join @PolicyBusinessIds inalready on wpb.PolicyBusinessId = inalready.PolicyBusinessId
			where ParentPolicyBusinessId = @PolicyBusinessId and inalready.PolicyBusinessId is null
		 )
begin
	insert into @PolicyBusinessIds
		select distinct wpb.PolicyBusinessId
			from twrapperpolicybusiness wpb with (nolock) left join @PolicyBusinessIds inalready on wpb.PolicyBusinessId = inalready.PolicyBusinessId
			where ParentPolicyBusinessId = @PolicyBusinessId and inalready.PolicyBusinessId is null
end

exec dbo.SpCustomValuationsMultiplePolicyBusinessChanged @PolicyBusinessIds = @PolicyBusinessIds

