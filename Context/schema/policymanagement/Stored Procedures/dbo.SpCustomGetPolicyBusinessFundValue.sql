SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomGetPolicyBusinessFundValue]
@policyBusinessId bigint

as

begin

select 
1 as tag,
null as parent, 
4 as [PolicyFundTotal!1!RefPlanValueTypeId],
@PolicyBusinessId as [PolicyFundTotal!1!PolicyBusinessId], 
IsNull(sum(a.FundTotal),0) as [PolicyFundTotal!1!FundTotal], 
IsNull(convert(varchar(10),max(a.MaxPriceDate),121),'') as [PolicyFundTotal!1!MaxPriceDate],
null as [RefPlanValueType!2!RefPlanValueTypeId],
null as [RefPlanValueType!2!RefPlanValueType]

FROM 
(
	select 
	isnull(round(tpbf.currentprice*sum(tpbft.unitquantity),2), 0) as FundTotal,
	max(tpbf.lastpricechangedate) as MaxPriceDate
	from tpolicybusinessfund tpbf
	inner join tpolicybusinessfundtransaction tpbft on tpbft.policybusinessfundid = tpbf.policybusinessfundid
	where tpbf.policybusinessid = @policyBusinessId
	group by tpbf.currentprice
) a

UNION

select 
2 as tag,
1 as parent,
null,
@PolicyBusinessId,
null,
null,
t1.RefPlanValueTypeId,
t1.RefPlanValueType

FROM TRefPlanValueType t1
WHERE t1.RefPlanValueTypeId = 4

FOR XML EXPLICIT

end
GO
