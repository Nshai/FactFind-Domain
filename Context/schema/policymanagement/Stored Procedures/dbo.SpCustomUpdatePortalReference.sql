SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[SpCustomUpdatePortalReference] @ValScheduleId bigint
AS  

declare @RefProdProviderId bigint, @IndigoClientId bigint, @MatchingCriteria varchar(255)  
declare @ValScheduleItemId bigint  

--Get RefProdProviderId and @ValScheduleItemId
Select 
	@RefProdProviderId = A.RefProdProviderId, @ValScheduleItemId = B.ValScheduleItemId
From TValSchedule A with(nolock)
Inner Join TValScheduleItem B with(nolock) On A.ValScheduleId = B.ValScheduleId
Where A.ValScheduleId = @ValScheduleId

--Get Matching Criteria  
Select @MatchingCriteria = MatchingCriteria   
From TValBulkConfig with(nolock)   
Where RefProdProviderId = @RefProdProviderId  

if charindex('|U1|',@MatchingCriteria) > 0   
Begin

--Update IO PortalReference (with CustomerReference) in TpolicyBusinessExt    

	Update T1
		Set T1.PortalReference= SelectedPlans.CustomerReference,
			T1.SystemPortalReference=SelectedPlans.CustomerReference,
			T1.ConcurrencyId = T1.ConcurrencyId + 1
		
		--Get Inserted values
		OUTPUT DELETED.PolicyBusinessId, DELETED.BandingTemplateId, DELETED.MigrationRef, 
			DELETED.PortalReference, DELETED.ConcurrencyId, DELETED.PolicyBusinessExtId, 
			 DELETED.IsVisibleToClient, DELETED.IsVisibilityUpdatedByStatusChange, DELETED.WhoCreatedUserId,
			'U', GetDate(), '0', DELETED.QuoteId
			
		--Add data to Audit
		INTO TPolicyBusinessExtAudit 
			(PolicyBusinessId, BandingTemplateId, MigrationRef, 
				PortalReference, ConcurrencyId, PolicyBusinessExtId,
				 IsVisibleToClient, IsVisibilityUpdatedByStatusChange, WhoCreatedUserId,
				StampAction, StampDateTime, StampUser, QuoteId)
		
		FROM TPolicyBusinessExt T1
		Inner Join (
			Select 
				PolicyBusinessId, CustomerReference
			From 
				TValBulkHolding
			Where 
				ValScheduleItemId = @ValScheduleItemId
				And IsNull(CustomerReference,'') <> ''
				And IsNull(PolicyBusinessId,0) > 0
			Group By 
				PolicyBusinessId, CustomerReference
				) SelectedPlans 
		On T1.PolicyBusinessId = SelectedPlans.PolicyBusinessId   

End

GO
