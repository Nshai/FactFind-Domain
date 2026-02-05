SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[nio_ContractEnquiry_EnablePlansForScheduleByAdviser] @StampUser bigint, @UserCRMContactId bigint, @ValuationProviderId bigint
as

declare @TenantId bigint
select @TenantId = a.IndigoClientId from administration..TUser a where a.UserId = @StampUser
/*
	Custom Sp to Include Plans For Schedule By Adviser
	LIO Procedure: SpCustomEnablePlansForScheduleByAdviser
	Changes to Create an Empty PR
*/

--get all linked providers to this one
if (object_id('tempdb..#LinkedProviders')) is not null drop table #LinkedProviders
Create table #LinkedProviders (RefProdProviderId bigint)

Insert InTo #LinkedProviders (RefProdProviderId)
Values (@ValuationProviderId)

Insert InTo #LinkedProviders (RefProdProviderId)
Select RefProdProviderId 
From TValLookUp with(nolock) 
Where MappedRefProdProviderId = @ValuationProviderId

--delete from excludePlans where the user is their selling/servicing adviser based on the preference
delete a
   output deleted.PolicyBusinessId, deleted.RefProdProviderId, deleted.ExcludedByUserId, deleted.ExcludedDate, deleted.EmailAlertSent, deleted.ConcurrencyId, deleted.ValExcludedPlanId, 'D', getdate(), @StampUser
   into policymanagement..TValExcludedPlanAudit(PolicyBusinessId, RefProdProviderId, ExcludedByUserId, ExcludedDate, EmailAlertSent, ConcurrencyId, ValExcludedPlanId, StampAction, StampDateTime, StampUser)
FROM   PolicyManagement.dbo.[TValExcludedPlan] a
       inner join #LinkedProviders c with(nolock) on a.RefProdProviderId = c.RefProdProviderId
       inner join PolicyManagement.dbo.VPolicyBusiness pb2_   with(nolock)   on a.PolicyBusinessId = pb2_.PolicyBusinessId
	   inner join Administration.dbo.[TUser] selladviser with (nolock) on pb2_.AdviserCRMContactId = selladviser.CRMContactId
       inner join PolicyManagement.dbo.[TPolicyDetail] pd3_   with(nolock)   on pb2_.PolicyDetailId = pd3_.PolicyDetailId
       inner join PolicyManagement.dbo.TPolicyOwner po4_      with(nolock)   on pd3_.PolicyDetailId = po4_.PolicyDetailId
	                                                                             and (po4_.PolicyOwnerId = (SELECT MIN(Prim.PolicyOwnerId)
																		                                    FROM   PolicyManagement.dbo.TPolicyOwner Prim
																						     			    WHERE  Prim.PolicyDetailId = po4_.PolicyDetailId
																									        GROUP  BY Prim.PolicyDetailId))
       inner join CRM.dbo.TCRMContact own5_         with(nolock)             on po4_.CRMContactId = own5_.CRMContactId
       left outer join CRM.dbo.VCustomer customer6_    with(nolock)          on own5_.CRMContactId = customer6_.CRMContactId
       left outer join CRM.dbo.TCRMContact currentadv7_    with(nolock)		 on customer6_.CurrentAdviserCRMId = currentadv7_.CRMContactId
	   inner join Administration.dbo.[TUser] servadviser with (nolock)		 on currentadv7_.CRMContactId = servadviser.CRMContactId
       inner join Administration.dbo.[TIndigoClient] tenant8_ with(nolock)   on pb2_.IndigoClientId = tenant8_.IndigoClientId

WHERE  tenant8_.IndigoClientId = @TenantId        
       and (
				(pb2_.AdviserCRMContactId = @UserCRMContactId and selladviser.Status like '%Access Granted%')
				OR
				(customer6_.CurrentAdviserCRMId = @UserCRMContactId and (selladviser.Status not like '%Access Granted%' and servadviser.Status like '%Access Granted%'))
		   )
GO
