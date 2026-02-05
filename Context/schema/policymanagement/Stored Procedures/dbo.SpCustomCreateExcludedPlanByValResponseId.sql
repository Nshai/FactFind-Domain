SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomCreateExcludedPlanByValResponseId] @StampUser varchar(255), @ValResponseId bigint 

as

declare @ValExcludedPlanId bigint

insert into TValExcludedPlan
(PolicyBusinessId,
RefProdProviderId,
ExcludedByUserId,
ExcludedDate,
EmailAlertSent,
ConcurrencyId)
select	pb.policybusinessid,
		pdesc.RefProdProviderId,
		null,
		getdate(),
		0,
		1
from TValResponse valResp
inner join TValRequest valReq on valReq.ValRequestId = valResp.ValRequestId
inner join TPolicyBusiness pb on pb.PolicyBusinessId = valReq.PolicyBusinessId
inner join TPolicyDetail pd on pd.policydetailid = pb.policydetailid
inner join TPlanDescription pdesc on pdesc.PlanDescriptionid = pd.PlanDescriptionid
where valResp.ValResponseId = @ValResponseId and
		--shouldn't exist but double check
		not exists (select 1 from TValExcludedPlan exc where exc.policybusinessid =  pb.policybusinessid)

select @ValExcludedPlanId = SCOPE_IDENTITY()

if (select isnull(@ValExcludedPlanId,0)) > 0 begin

insert into TValExcludedPlanAudit
(
PolicyBusinessId,
RefProdProviderId,
ExcludedByUserId,
ExcludedDate,
EmailAlertSent,
ConcurrencyId,
ValExcludedPlanId,
StampAction,
StampDateTime,
StampUser
)
select 
PolicyBusinessId,
RefProdProviderId,
ExcludedByUserId,
ExcludedDate,
EmailAlertSent,
ConcurrencyId,
ValExcludedPlanId,
'C',
getdate(),
@StampUser
from	TValExcludedPlan
where ValExcludedPlanId = @ValExcludedPlanId

end


GO
