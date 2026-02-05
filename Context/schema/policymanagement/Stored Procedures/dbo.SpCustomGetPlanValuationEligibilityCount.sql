SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCustomGetPlanValuationEligibilityCount]
	@TenantId bigint, 
	@LoggedInUserId bigint, 
	@ProviderGroupList ProviderGroupListType READONLY
AS
BEGIN

		Declare @EligiblePlanCount bigint, @EligiblePlanCountServicing bigint
		Declare @PlanEligibilityCriteria table (ValuationProviderId bigint, EligibilityMask bigint NULL)

		set transaction isolation level read uncommitted
		set nocount on
		
		if @LoggedInUserId is null   
			begin

				insert into @PlanEligibilityCriteria (ValuationProviderId, EligibilityMask)
				select ValuationProviderId, sum(ef.EligibilityFlag)
					from TValEligibilityCriteria EC cross apply TValRefEligibilityFlag EF 
							join @ProviderGroupList plist on plist.RefProdProviderId = ec.ValuationProviderId
					where ec.EligibilityMask & ef.EligibilityFlag =  ef.EligibilityFlag  and ef.EligibilityLevel = 'plan' 
							and EligibilityDescription not in ('Adviser allowed', 'Plan type allowed')
					group by ValuationProviderId


				--Return the firm count
				select @EligiblePlanCount = count(1) 
				from TValPotentialPlan pp
					join administration..TUser U  on PP.SellingAdviserCRMContactID = U.CRMContactId  --Group is always decided by selling adviser and not servicing adviser-It is by requirement (may have to re-visit later)
					join administration..TGroup G  on G.GroupId = U.GroupId
					join @ProviderGroupList pg on pp.ValuationProviderId = pg.RefProdProviderId
					join @PlanEligibilityCriteria ec on pp.ValuationProviderId = ec.ValuationProviderId
						where  1=1
								and pp.IndigoClientId = @TenantId 
								and pp.EligibilityMask & ec.EligibilityMask = ec.EligibilityMask
								and
								(
									(G.ParentId IS NULL) --it is an organizational level schedule 
									OR
									(G.GroupId = PG.RefGroupId)
								)
						
			end
		else						 
			begin

				insert into @PlanEligibilityCriteria (ValuationProviderId, EligibilityMask)
				select ValuationProviderId, sum(ef.EligibilityFlag)
					from TValEligibilityCriteria EC cross apply TValRefEligibilityFlag EF 
							join @ProviderGroupList plist on plist.RefProdProviderId = ec.ValuationProviderId
					where ec.EligibilityMask & ef.EligibilityFlag =  ef.EligibilityFlag  and ef.EligibilityLevel = 'plan' 
					group by ValuationProviderId

				--Return the adviser count
				Declare @AdviserCrmContactId BIGINT
				select  @AdviserCrmContactId = CRMContactId from Administration..TUser where UserId = @LoggedInUserId

				-- get count where our user is the selling adviser of the plan
				select @EligiblePlanCount = count(1) 
				from TValPotentialPlan pp
					join @ProviderGroupList pg on pp.ValuationProviderId = pg.RefProdProviderId
					join @PlanEligibilityCriteria ec on pp.ValuationProviderId = ec.ValuationProviderId
				where 
					pp.IndigoClientId = @TenantId 
					and pp.EligibilityMask & ec.EligibilityMask = ec.EligibilityMask
                    and 
                    (
                        (
							(PP.SellingAdviserCRMContactID = @AdviserCrmContactId and pp.SellingAdviserStatus = 'Access Granted') 
							OR 
							(pp.SellingAdviserStatus != 'Access Granted'  AND PP.ServicingAdviserCRMContactID = @AdviserCrmContactId AND pp.ServicingAdviserStatus = 'Access Granted')
						)
                    )
			end

select ISNULL(@EligiblePlanCount, 0) + ISNULL(@EligiblePlanCountServicing, 0)

Return (0)

END
GO
