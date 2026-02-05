SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomRetrievePlanTopUpsContributions]

@policybusinessid bigint ,
@policyDetailId bigint = 0

as

-- Get the TopUps on this plan as we will need the contributions from that too 
SELECT 
	PB.PolicyBusinessId
INTO #tempTopupPolicies	
FROM
	 policymanagement..TPolicyBusiness PB WITH (NOLOCK)
	JOIN  policymanagement..TStatusHistory SH WITH (NOLOCK) ON SH.PolicyBusinessId = PB.PolicyBusinessId AND CurrentStatusFg = 1
	JOIN  policymanagement..TStatus S WITH (NOLOCK) ON S.StatusId = SH.StatusId AND S.IntelligentOfficeStatusType = 'In force'
WHERE
	Pb.PolicyDetailId = @policyDetailId
	-- make sure that supplied plan is the main policy record.
	AND PB.PolicyBusinessId != @policybusinessid

	select	
			mi.policybusinessid,
			case
			when EscalationType is null then 'NONE'
			when EscalationType = 'Fixed %' then 'NONE'
			when EscalationType = 'RPI' then 'RPI'
			when EscalationType = 'Level' then 'NONE'
			when EscalationType = 'NAEI' then 'NAEI'
			else 'NONE'
												end as Basis,
			case
			when EscalationType is null then '0'
			when EscalationType = 'Fixed %' then isnull(EscalationPercentage,0)
			when EscalationType = 'RPI' then '0'
			when EscalationType = 'Level' then '0'
			when EscalationType = 'NAEI' then '0'
			else '0'
												end as Rate,
				cast(sum(CASE         
					when  rf.RefFrequencyId=1 then amount * 52              
					when  rf.RefFrequencyId=2 then amount * 26              
					when  rf.RefFrequencyId=3 then amount*13      
					when  rf.RefFrequencyId=4 then amount * 12 
					when  rf.RefFrequencyId=5 then amount * 4           
					when  rf.RefFrequencyId=7 then amount * 2   
					when  rf.RefFrequencyId=8 then amount
					else 0 END
					) as int)  as AnnualContributionsFromTopups,
					
			cont.RefContributorTypeName AS Contributor
			
	from #tempTopupPolicies XX
	INNER JOIN 	policymanagement..TPolicyMoneyIn mi WITH (NOLOCK) ON mi.PolicyBusinessId = XX.PolicyBusinessId
	inner join policymanagement..TRefFrequency rf WITH (NOLOCK) on rf.reffrequencyid = mi.reffrequencyid
	left join policymanagement..TRefEscalationType re WITH (NOLOCK) on re.RefEscalationTypeId = mi.RefEscalationTypeId
	left join policymanagement..TRefContributorType cont WITH (NOLOCK) ON cont.RefContributorTypeId = mi.RefContributorTypeId
		
	where	rf.reffrequencyid in (1,2,3,4,5,7,8) and
			mi.startdate < getdate() and
			(mi.stopdate is null or mi.stopdate > getdate())
	group by mi.policybusinessid,
			case
			when EscalationType is null then 'NONE'
			when EscalationType = 'Fixed %' then 'NONE'
			when EscalationType = 'RPI' then 'RPI'
			when EscalationType = 'Level' then 'NONE'
			when EscalationType = 'NAEI' then 'NAEI'
			else 'NONE'
												end ,
			case
			when EscalationType is null then '0'
			when EscalationType = 'Fixed %' then isnull(EscalationPercentage,0)
			when EscalationType = 'RPI' then '0'
			when EscalationType = 'Level' then '0'
			when EscalationType = 'NAEI' then '0'
			else '0'
												end ,
												cont.RefContributorTypeName
													
GO
