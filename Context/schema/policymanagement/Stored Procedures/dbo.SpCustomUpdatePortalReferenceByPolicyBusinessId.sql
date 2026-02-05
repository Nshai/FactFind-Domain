SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[SpCustomUpdatePortalReferenceByPolicyBusinessId] 
	@PolicyBusinessId bigint, 
	@PortalReference varchar(50), 
	@StampUser varchar(255)
AS  

SET NOCOUNT ON

Begin

	Update TPolicyBusinessExt
		Set PortalReference= @PortalReference,
			SystemPortalReference=@PortalReference,
			ConcurrencyId = ConcurrencyId + 1
		
		--Get Inserted values
		OUTPUT DELETED.PolicyBusinessId, DELETED.BandingTemplateId, DELETED.MigrationRef, 
			DELETED.PortalReference, DELETED.ConcurrencyId, DELETED.PolicyBusinessExtId, 
			DELETED.IsVisibleToClient, DELETED.IsVisibilityUpdatedByStatusChange,
			'U', GetDate(), @StampUser, DELETED.QuoteId
			
		--Add data to Audit
		INTO TPolicyBusinessExtAudit 
			(PolicyBusinessId, BandingTemplateId, MigrationRef, 
				PortalReference, ConcurrencyId, PolicyBusinessExtId,
				IsVisibleToClient, IsVisibilityUpdatedByStatusChange,
				StampAction, StampDateTime, StampUser, QuoteId)
		
		Where PolicyBusinessId = @PolicyBusinessId
		
End

GO
