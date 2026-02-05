CREATE Procedure dbo.SpCustomValuationsTenantChanged 
	@TenantId bigint
As

Declare @ErrorMessage varchar(max)
	Declare @PolicyBusinessIds as dbo.PolicyBusinessIdListType
	Declare @Status varchar(100)
	Select @Status = Status From administration..TIndigoClient Where IndigoClientId = @TenantId
	DECLARE @ActionTime DATETIME = GETDATE(), @ActionUser VARCHAR(1) = '0'

	If @Status = 'active'
	Begin
		Insert Into @PolicyBusinessIds
		( PolicyBusinessId )
		Select PolicyBusinessId
		From TPolicyBusiness a with(nolock)
		Where 1=1
		And a.IndigoClientId = @TenantId

		exec dbo.SpCustomValuationsMultiplePolicyBusinessChanged @PolicyBusinessIds = @PolicyBusinessIds
	End
	Else
	Begin
		Delete From TValPotentialPlan 
			OUTPUT 
				DELETED.ValuationProviderId, DELETED.PolicyProviderId, DELETED.PolicyProviderName, DELETED.IndigoClientId, 
				DELETED.PolicyBusinessId,
				DELETED.PolicyDetailId, DELETED.PolicyNumber, DELETED.PortalReference 
				,DELETED.FormattedPolicyNumber, DELETED.FormattedPortalReference
				,DELETED.RefPlanType2ProdSubTypeId, DELETED.ProviderPlanType
				,DELETED.NINumber, DELETED.DOB, DELETED.LastName, DELETED.Postcode
				,DELETED.PolicyStatusId,DELETED.PolicyStartDate,DELETED.PolicyOwnerCRMContactID
				,DELETED.SellingAdviserCRMContactID, DELETED.SellingAdviserStatus
				,DELETED.ServicingAdviserCRMContactID, DELETED.ServicingAdviserStatus
				,DELETED.ExtendValuationsByServicingAdviser
				,DELETED.EligibilityMask, DELETED.EligibilityMaskRequiresUpdating, DELETED.ConcurrencyId, DELETED.ValPotentialPlanId
				, 'D', @ActionTime, @ActionUser
			INTO [TValPotentialPlanAudit]
			(ValuationProviderId, PolicyProviderId, PolicyProviderName
				,IndigoClientId, PolicyBusinessId, PolicyDetailId, PolicyNumber, PortalReference
				,FormattedPolicyNumber, FormattedPortalReference
				,RefPlanType2ProdSubTypeId, ProviderPlanType
				,NINumber,DOB,LastName,Postcode
				,PolicyStatusId, PolicyStartDate, PolicyOwnerCRMContactID
				,SellingAdviserCRMContactID, SellingAdviserStatus
				,ServicingAdviserCRMContactID,ServicingAdviserStatus
				,ExtendValuationsByServicingAdviser
				,EligibilityMask, EligibilityMaskRequiresUpdating, ConcurrencyId, ValPotentialPlanId
				,StampAction
				, StampDateTime, StampUser)		
		Where IndigoClientId = @TenantId

		Delete a
			From TValScheduledPlan a Join TPolicyBusiness b with (nolock) on a.PolicyBusinessId = b.PolicyBusinessId
		Where IndigoClientId = @TenantId

	End	
