SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[SpCustomRetrieveEligibilityForAdhocRealTimeForPlan]
@PolicyBusinessId bigint,
@TenantId bigint,
@UserId bigint,
@Now datetime
as
set transaction isolation level read uncommitted
begin	

	declare @ineligibles table(policyBusinessId bigint, isEligible bit, eligibilityCode int)
	declare @isEligible bit = 1
	declare @eligibleCode int = 0
	declare @AdviserAccessDeniedFlag tinyint = 4
	declare @PlanNotDuplicateFlag INT = 128
	declare @PlanNotExcluded INT = 8

	--ineligible if not InForce/Paidup
	if(not exists(select 1 from TPolicyBusiness pb 
					join TStatusHistory sth on pb.PolicyBusinessId = sth.PolicyBusinessId
					join TStatus st on st.StatusId = sth.StatusId and pb.IndigoClientId = st.IndigoClientId
				  where pb.PolicyBusinessId = @PolicyBusinessId 
					and pb.IndigoClientId = @TenantId 
					and st.IntelligentOfficeStatusType in ('In force', 'Paid Up')))
	begin
		--select @isEligible = 0
		--select @eligibleCode = 2
		--select @PolicyBusinessId as PolicyBusinessId, @isEligible as IsEligible, @eligibleCode as EligibilityCode
		--return;
		insert into @ineligibles(policyBusinessId, isEligible, eligibilityCode)  
          (select @PolicyBusinessId as policyBusinessId, 0, 2)
	end	

	--inelligble if not in TvalPotentialPlan
	if(not exists(select 1 from TValPotentialPlan where PolicyBusinessId = @PolicyBusinessId and IndigoClientId = @TenantId))
	begin		
		insert into @ineligibles(policyBusinessId, isEligible, eligibilityCode)  
          (select @PolicyBusinessId as policyBusinessId, 0, 105)
	end
	
	;with 
	credentials(PolicyBusinessId, ValuationProviderId, SellingAdviserCertificate, ServicingAdviserCertificate,
	            LoggedInUserCertificate, SellingAdviserPortalSetup, ServicingAdviserPortalSetup, LoggedInUserPortalSetup) as 
	(
	   select pp.PolicyBusinessId, pp.ValuationProviderId, certf1.[Subject] as SellingAdviserCertificate, 
	          certf2.[Subject] as ServicingAdviserCertificate, certf3.[Subject] as LoggedInUserCertificate, 
			  portal1.UserName as SellingAdviserPortalSetup, portal2.UserName as ServicingAdviserPortalSetup, 
			  portal3.UserName as LoggedInUserPortalSetup
		from  TValPotentialPlan pp 
		join TValProviderConfig config on config.RefProdProviderId = pp.ValuationProviderId
		join Administration..TUser _user on _user.UserId = @UserId
		left join Administration..TCertificate certf1 on certf1.CRMContactId = pp.SellingAdviserCRMContactID and certf1.IsRevoked = 0 and certf1.HasExpired = 0 and (config.AuthenticationType = 1 or config.AuthenticationType = 2)
		left join Administration..TCertificate certf2 on certf2.CRMContactId = pp.ServicingAdviserCRMContactID and certf2.IsRevoked = 0 and certf2.HasExpired = 0 and (config.AuthenticationType = 1 or config.AuthenticationType = 2) 
		left join Administration..TCertificate certf3 on certf3.CRMContactId = _user.CRMContactId and certf3.IsRevoked = 0 and certf3.HasExpired = 0 and (config.AuthenticationType = 1 or config.AuthenticationType = 2)
		left join TValPortalSetup portal1 on portal1.CRMContactId = pp.SellingAdviserCRMContactID and portal1.RefProdProviderId = pp.ValuationProviderId and (config.AuthenticationType = 0 or config.AuthenticationType = 2) and portal1.Password2 is not null
		left join TValPortalSetup portal2 on portal2.CRMContactId = pp.ServicingAdviserCRMContactID and portal2.RefProdProviderId = pp.ValuationProviderId and (config.AuthenticationType = 0 or config.AuthenticationType = 2) and portal2.Password2 is not null
		left join TValPortalSetup portal3 on portal3.CRMContactId = _user.CRMContactId and portal3.RefProdProviderId = pp.ValuationProviderId and (config.AuthenticationType = 0 or config.AuthenticationType = 2) and portal3.Password2 is not null
		where pp.IndigoClientId = @TenantId and pp.PolicyBusinessId = @PolicyBusinessId
	),
	eligibility(PolicyBusinessId, isEligible, providerId, ppMask, ecMask) as
	(
		select pp.PolicyBusinessId, case when pp.EligibilityMask & ec.EligibilityMask = ec.EligibilityMask then 1
		else 0
		end, pp.ValuationProviderId, pp.EligibilityMask, ec.EligibilityMask
		from TValPotentialPlan PP   
		left join TValEligibilityCriteria ec on pp.ValuationProviderId = ec.ValuationProviderId
		where pp.IndigoClientId = @TenantId and pp.PolicyBusinessId = @PolicyBusinessId
	)
	insert into @ineligibles(policyBusinessId, isEligible, eligibilityCode)  
    (
		--ineligible if the provider is not in TValEligibilityCriteria
		select e.PolicyBusinessId as PolicyBusinessId, e.isEligible as IsEligible, 106 as EligibilityCode   
		from eligibility e  
		where e.ecMask is null

		union all
		
		--ineligible plans based on eligibility mask
		select e.PolicyBusinessId as PolicyBusinessId, e.isEligible as IsEligible, ef.EligibilityFlag as EligibilityCode 
		from eligibility e		
		cross apply TValRefEligibilityFlag EF with (nolock)
		where e.ppMask & ef.EligibilityFlag != ef.EligibilityFlag and e.ecMask & ef.EligibilityFlag = ef.EligibilityFlag
			and ef.EligibilityFlag not in ( @AdviserAccessDeniedFlag, @PlanNotDuplicateFlag, @PlanNotExcluded)
		    and ef.EligibilityLevel = 'Plan'
	
		union all

		--ineligible if planValuation exists for today 
		select distinct @PolicyBusinessId as PolicyBusinessId, 
			   0 as IsEligible, 
			   100 as EligibilityCode
		from TPlanValuation val 
		group by val.PolicyBusinessId, val.WhoUpdatedDateTime
		having val.PolicyBusinessId = @PolicyBusinessId 
		         and MAX(convert(date, val.WhoUpdatedDateTime)) = convert(date, @Now) 
		         and (MAX(val.RefPlanValueTypeId) = 2 or MAX(val.RefPlanValueTypeId) = 3 or MAX(val.RefPlanValueTypeId) = 5)
		

		union all

		--ineligible if it is not within the hours of operation 
		select pp.PolicyBusinessId as PolicyBusinessId, 
 			   0 as IsEligible, 
				101 as EligibilityCode 
		from TValPotentialPlan pp 
		cross apply TValProviderHoursOfOperation hoop 
		where  hoop.RefProdProviderId = pp.ValPotentialPlanId
			and pp.PolicyBusinessId = @PolicyBusinessId
			and hoop.AlwaysAvailableFg= 0 
			and DateDiff(ss, @now, convert(varchar(50), convert(varchar(50), DATEADD(n, hoop.StartMinute, DATEADD(hh, hoop.StartHour, convert(varchar(24), @now, 106))),113),113)/*starttime*/) >= 0
			and DateDiff(ss, @now, convert(varchar(50), convert(varchar(50), DATEADD(n, hoop.EndMinute, DATEADD(hh, hoop.EndHour, convert(varchar(24), @now, 106))),113),113)/*endtime*/) <= 0 			
		    and pp.IndigoClientId = @TenantId

		union all

		--ineligible if there is no Certificate nor PortalSetup configured for this provider
		select cred.PolicyBusinessId as PolicyBusinessId, 
		       0 as IsEligible, 
			   102 as EligibilityCode
		from credentials cred 
		where cred.PolicyBusinessId = @PolicyBusinessId
		       and cred.LoggedInUserCertificate is null and cred.SellingAdviserCertificate is null and cred.ServicingAdviserCertificate is null
			   and cred.LoggedInUserPortalSetup is null and cred.SellingAdviserPortalSetup is null and cred.ServicingAdviserPortalSetup is null

		union all

		--ineligible if provider is not configured for Electronic request
		select  @PolicyBusinessId as PolicyBusinessId, 
	       0 as IsEligible, 
		   103 as EligibilityCode
		from TValPotentialPlan pp 
		join TValProviderConfig c  on c.RefProdProviderId = pp.ValuationProviderId
		cross apply TRefPlanValueType  r
		where pp.PolicyBusinessId = @PolicyBusinessId
		    and c.SupportedService & r.ServiceType <> r.ServiceType 
			and r.ServiceType = 4
			and pp.IndigoClientId = @TenantId	
	)

if (exists(select 1 from @ineligibles))
   select * from @ineligibles
   else 
   select @PolicyBusinessId as PolicyBusinessId, @isEligible as IsEligible, @eligibleCode as EligibilityCode 


end



GO
