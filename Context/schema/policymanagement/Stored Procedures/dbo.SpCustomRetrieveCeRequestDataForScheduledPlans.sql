SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomRetrieveCeRequestDataForScheduledPlans]
    @ValScheduleId bigint

as 
begin

set transaction isolation level read uncommitted
SET XACT_ABORT ON

declare  @CredentialCrmContactId bigint, @LoggedOnUser bigint, @TenantId bigint, @SystemUser bigint
declare @policyBusinessIdList table(PolicyId bigint)
declare @policyBusinessIdListUnique table(PolicyId bigint)
declare @existingWrapperPolicyBusinessIdList table(PolicyId bigint)
declare @existingNonWrapNonSubPolicyBusinessIdList table(PolicyId bigint)
declare @existingLonelySubPolicyBusinessIdList table(PolicyId bigint)

insert into @policyBusinessIdList
    select PolicyBusinessId from TValScheduledPlan
	where ValScheduleId = @valScheduleId

	if not exists (select * from @policyBusinessIdList)
		return(0)

select @TenantId = IndigoClientId, @CredentialCrmContactId = PortalCRMContactId, @LoggedOnUser = CreatedByUserId from TValSchedule where ValScheduleId = @ValScheduleId

select @SystemUser = MIN(UserId) from administration..TUser where IndigoClientId = @TenantId and RefUserTypeId = 5

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


exec PolicyManagement.dbo.SpNioCustomOpenSymmetricKeyForPasswordEncryption

;with requestorAddress(crmContactId, postCode) as 
(
	select taddress.CRMContactId, addressStore.Postcode 
	from crm..TAddress taddress 
	join crm..TAddressStore addressStore on addressStore.AddressStoreId = taddress.AddressStoreId
	where taddress.CRMContactId = @CredentialCrmContactId and 
		  taddress.RefAddressTypeId = 2 and --BusinessAddressType
		  taddress.DefaultFg = 1 and 
		  taddress.IndClientId = @TenantId	
),
sellingAdviserAddress(policyId, postCode) as 
(
	select idList.PolicyId, addressStore.Postcode 
	from @policyBusinessIdListUnique idList
	join TPolicyBusiness pb on pb.PolicyBusinessId = idList.PolicyId
	join crm..TPractitioner practitioner on practitioner.PractitionerId = pb.PractitionerId
	join crm..TAddress taddress on taddress.CRMContactId = practitioner.CRMContactId
	join crm..TAddressStore addressStore on addressStore.AddressStoreId = taddress.AddressStoreId
	where taddress.CRMContactId = @CredentialCrmContactId and 
		  taddress.RefAddressTypeId = 2 and --BusinessAddressType
		  taddress.DefaultFg = 1 and 
		  taddress.IndClientId = @TenantId	
)

select 
  valGating.OrigoProductType,
  valGating.OrigoProductVersion,
  pb.PolicyBusinessId,
  pb.PolicyNumber,
  pb.PolicyOwnerCRMContactID as ClientPartyId,
  PT.PractitionerId as SellingAdviserId,
  sellingAdviserAddress.postCode as sellingAdviserPostCode,
  tenant.SIB as Sib,
  pb.PolicyStartDate,
  pb.PortalReference,
  refPlanType.RefPlanTypeId,
  @CredentialCrmContactId as RequestorPartyId,
  tuser.UserId as RequestorUserId,
  requestorContact.FirstName + ' ' + requestorContact.LastName as RequestorPartyName,
  pt.FSAReference as AdviserFsa,  
  tgroup.FSARegNbr as GroupFsa,
  tenant.FSA as TenantFsa,
  requestorAddress.postCode as RequestorPostCode,
  tenant.Postcode as TenantPostCode,
  tenant.Identifier as TenantIdentifier,
  @LoggedOnUser as LoggedOnUserId,
  portalSetup.UserName as PortalUsername,
  dbo.FnCustomDecryptPortalPassword(portalsetup.[Password2]) as PortalPassword,
  portalSetup.Passcode as PortalPasscode,
  tcertificate.Issuer as CertificateIssuer,
  tcertificate.[Subject] as CertificateSubject,
  tcertificate.ValidFrom as CertificateValidFrom,
  tcertificate.ValidUntil as CertificateValidTo,
  tcertificate.SerialNumber as CertificateSerialNumber,
  providerConfig.PostURL as Url,
  providerConfig.OrigoResponderId,
  providerConfig.AuthenticationType,
  valGating.ImplementationCode,
  pb.PolicyProviderId as RefProdProviderId, 
  pb.ValuationProviderId,
  @SystemUser as SystemUser,
  policy.SequentialRef as IobRef,
  refPlanType.PlanTypeName as PlanTypeName,
  prodSubType.ProdSubTypeName as PlanSubTypeName,
  pb.PolicyProviderName as ValuationProviderName,
  providerConfig.ValuationProviderCode as ValuationProviderCode
from @policyBusinessIdListUnique idList
join TValPotentialPlan pb on pb.PolicyBusinessId = idList.PolicyId
join TPolicyBusiness policy on policy.PolicyBusinessId = pb.PolicyBusinessId
join TRefPlanType2ProdSubType refPlanTypeProdSubType on refPlanTypeProdSubType.RefPlanType2ProdSubTypeId = pb.RefPlanType2ProdSubTypeId
join TRefPlanType refPlanType on refPlanType.RefPlanTypeId = refPlanTypeProdSubType.RefPlanTypeId
left join TProdSubType prodSubType on prodSubType.ProdSubTypeId = refPlanTypeProdSubType.ProdSubTypeId
join crm..TPractitioner pt on pt.CRMContactId = pb.SellingAdviserCRMContactID
join administration..TIndigoClient tenant on tenant.IndigoClientId = @TenantId
join TValGating valGating on valGating.RefProdProviderId = PB.ValuationProviderId 
                         and valGating.RefPlanTypeId = refPlanType.RefPlanTypeId
						 and isnull(valGating.ProdSubTypeId, 0) = isnull(refPlanTypeProdSubType.ProdSubTypeId, 0)
join TValProviderConfig providerConfig on providerConfig.RefProdProviderId = pb.ValuationProviderId
left join requestorAddress on requestorAddress.crmContactId = @CredentialCrmContactId 
left join sellingAdviserAddress on sellingAdviserAddress.policyId = pb.PolicyBusinessId
join administration..TUser tuser on tuser.CRMContactId = @CredentialCrmContactId
left join administration..TGroup tgroup on tgroup.GroupId = tuser.GroupId
join crm..TCRMContact requestorContact on requestorContact.CRMContactId = @CredentialCrmContactId
left join administration..TCertificate tcertificate on tcertificate.CRMContactId = @CredentialCrmContactId and tcertificate.IsRevoked = 0 and tcertificate.HasExpired = 0
left join TValPortalSetup portalSetup on portalSetup.CRMContactId = @CredentialCrmContactId and portalSetup.RefProdProviderId = pb.ValuationProviderId


where pb.IndigoClientId = @TenantId



end
GO
