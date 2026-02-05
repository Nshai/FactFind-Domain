SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[SpCustomRetrieveEligibilityForScheduledRealTime]
@ValScheduleId bigint,
@Now datetime
as
set transaction isolation level read uncommitted
SET XACT_ABORT ON

begin

declare @policyBusinessIdList table(PolicyId bigint)
declare @policyBusinessIdListUnique table(PolicyId bigint)
declare @existingWrapperPolicyBusinessIdList table(PolicyId bigint)
declare @existingNonWrapNonSubPolicyBusinessIdList table(PolicyId bigint)
declare @existingLonelySubPolicyBusinessIdList table(PolicyId bigint)
declare @ineligibles table(policyBusinessId bigint, isEligible bit, eligibilityCode int)
declare @eligibles table(policyBusinessId bigint)
declare @TenantId bigint, @isEligible bit = 1, @eligibleCode int = 0
declare @RefProdProviderId bigint = 0
declare @MappedRefProdProviderId bigint = 0
declare @IsProviderAllowedForBatch bit = 0
declare @ScheduledServiceType int = 8 --this value is taken from TRefPlanValueType

insert into @policyBusinessIdList
    select PolicyBusinessId from TValScheduledPlan
	where ValScheduleId = @valScheduleId

	if not exists (select * from @policyBusinessIdList)
		return(0)

insert into @existingWrapperPolicyBusinessIdList
     select distinct a.PolicyId
	 from @policyBusinessIdList a
	 join TWrapperPolicyBusiness wrapper on wrapper.ParentPolicyBusinessId = a.PolicyId

insert into @existingNonWrapNonSubPolicyBusinessIdList
     select distinct PolicyId
	 from @policyBusinessIdList a		 
	 where PolicyId not in (select PolicyBusinessId from TWrapperPolicyBusiness w where a.PolicyId = w.PolicyBusinessId)
	   and PolicyId not in (select ParentPolicyBusinessId from TWrapperPolicyBusiness w where a.PolicyId = w.ParentPolicyBusinessId)

insert into @existingLonelySubPolicyBusinessIdList
     select distinct a.PolicyId
	 from @policyBusinessIdList a
	 join TWrapperPolicyBusiness w on w.PolicyBusinessId = a.PolicyId
	 where w.ParentPolicyBusinessId not in (select PolicyId from @existingWrapperPolicyBusinessIdList)

insert into @policyBusinessIdListUnique
     --choose wrap plans from the list 
     select PolicyId
	 from @existingWrapperPolicyBusinessIdList	 

	 union 
	 --choose non wrap plans from the list
	 select PolicyId
	 from @existingNonWrapNonSubPolicyBusinessIdList

	 union 
	 --choose lonely sub plans from the list
	 select PolicyId
	 from @existingLonelySubPolicyBusinessIdList

	 --ValSchedule could refer to refProdProviderId or valuationProviderId
select @TenantId = IndigoClientId, @RefProdProviderId = RefProdProviderId from TValSchedule where ValScheduleId = @ValScheduleId
select @MappedRefProdProviderId = MappedRefProdProviderId from TValLookUp where RefProdProviderId = @RefProdProviderId

    --but providerConfig only refers to valuationProviderId
    select @IsProviderAllowedForBatch = case when count(*) > 0 then 1 else 0 end 
    from TValProviderConfig 
    where (RefProdProviderId = @RefProdProviderId or RefProdProviderId = @MappedRefProdProviderId)
         and SupportedService & @ScheduledServiceType = @ScheduledServiceType
  
  --ineligible if provider is not configured for Electronic Scheduled request
  if(@IsProviderAllowedForBatch = 0)
  begin
	  select @isEligible = 0
	  select @eligibleCode = 103
	  select p.PolicyId as PolicyBusinessId, @isEligible as IsEligible, @eligibleCode as EligibilityCode from @policyBusinessIdListUnique p
	  return;
  end

insert into @ineligibles(policyBusinessId, isEligible, eligibilityCode)  
(   
	--ineligible if planValuation exists for today 
	select val.PolicyBusinessId as PolicyBusinessId, 
	       0 as IsEligible, 
		   100 as EligibilityCode
	from @policyBusinessIdListUnique m
	join TPlanValuation val on val.PolicyBusinessId = m.PolicyId	
	group by val.PolicyBusinessId, val.WhoUpdatedDateTime
	having MAX(convert(date, val.WhoUpdatedDateTime)) = convert(date, @Now) 
	                 and (MAX(val.RefPlanValueTypeId) = 2 or MAX(val.RefPlanValueTypeId) = 3 or MAX(val.RefPlanValueTypeId) = 5)

    union all

	--ineligible if scheduled incorrectly
	select m.PolicyId as PolicyBusinessId, 
	       0 as IsEligible, 
		   104 as EligibilityCode
	from @policyBusinessIdListUnique m
	join TValScheduledPlan sp on sp.PolicyBusinessId = m.PolicyId and sp.ValScheduleId = @ValScheduleId
	where sp.[Status] <> 1

)

insert into @eligibles(policyBusinessId)
    select PolicyId from @policyBusinessIdListUnique
    except
    select policyBusinessId from @ineligibles


select distinct * from @ineligibles
union all
select distinct policyBusinessId as PolicyBusinessId, @isEligible as IsEligible, @eligibleCode as EligibilityCode 
         from @eligibles 

set transaction isolation level read committed
end



GO
