SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[spNCustomRetrievePlanSimpleWithdrawals]

@policybusinessid bigint 

as



	--Withdrawals
	select mi.policybusinessid,
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
					) as int)  as Expenditure
	from policymanagement..TPolicyMoneyOut mi
	inner join policymanagement..TRefFrequency rf on rf.reffrequencyid = mi.reffrequencyid
	left join policymanagement..TRefEscalationType re on re.RefEscalationTypeId = mi.RefEscalationTypeId	
	where	mi.policybusinessid = @policybusinessid and
			rf.reffrequencyid in (1,2,3,4,5,7,8) and
			paymentstartdate < getdate() and
			(paymentstopdate is null or paymentstopdate > getdate()) 
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
												end
GO
