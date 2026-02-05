create view [dbo].[vPV_FailedRTValuationForLast24Hours]
as
--All failed real time Valuation based on Tvalrequest / Tvalresponse
select ResponseDate,RefProdProviderId,RefPLanTypeId,IndigoClientId,null as PlanValue,count(1) as FailCount,RefPlanValueTypeId, ErrorCategory as Status
from
(
select distinct convert(date,TRO.ResponseDate) as ResponseDate,G.RefProdProviderId,f.RefPLanTypeId,a.IndigoClientId,ZRef.RefPlanValueTypeId,TRQ.PolicyBusinessId, 
max(
case 
when datalength(ErrorDescription) !=0 then isnull(dbo.fn_parsevaluationerrors(ErrorDescription),'')
when datalength(ProviderErrorDescription) != 0 then isnull( dbo.fn_parsevaluationerrors(ProviderErrorDescription),'')
when datalength(ProviderErrorCode) != 0 then isnull( replace(replace(replace(replace(replace(replace(replacE(replace(replacE(replace(replace(replace(ProviderErrorCode,'0',''),'1',''),'2',''),'3',''),'4',''),'5',''),'6',''),'7',''),'8',''),'9',''),'-',''),'_',''),'')       
end) over (partition by TRQ.PolicyBusinessId)  as ErrorCategory
From policymanagement.dbo.TPolicyBusiness a 
Join policymanagement.dbo.TPolicyDetail c  On A.PolicyDetailId = c.PolicyDetailId
Join policymanagement.dbo.TPlanDescription d  On c.PlanDescriptionId = d.PlanDescriptionId
Join policymanagement.dbo.TRefPlanType2ProdSubType e  on d.RefPlanType2ProdSubTypeId = e.RefPlanType2ProdSubTypeId
Join policymanagement.dbo.TRefPlanType f  on e.RefPLanTypeId = f.RefPLanTypeId
Join policymanagement.dbo.TRefProdProvider g  on d.RefProdProviderId = g.RefProdProviderId
Join CRM.dbo.TCrmContact h  on g.CrmContactId = h.CrmContactId
join Administration.dbo.v_activetenants AT on A.IndigoClientId = AT.IndigoClientId
join PolicyManagement.dbo.TValRequest  TRQ on A.PolicyBusinessId = TRQ.PolicyBusinessId
join PolicyManagement.dbo.TValResponse TRO on TRQ.ValRequestId = TRO.ValRequestId
join policymanagement.dbo.TRefPlanValueType ZRef  on (ZRef.RefPlanValueType = TRQ.valuationtype)
where 1=1
and TRQ.PlanValuationId is null
and TRO.ResponseDate between convert(date,getdate()-1) and convert(date,getdate())
) X
group by ResponseDate,RefProdProviderId,RefPLanTypeId,IndigoClientId,RefPlanValueTypeId, ErrorCategory
go
