SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


Create Procedure [dbo].[SpNioCustomUpdateExternalApplicationForPartyChanges]
	@TenantId bigint,
	@StampUserId bigint,
	@PartyId bigint,
	@IsClient bit = null,
	@IsLead bit = null
As

	Exec Crm.dbo.SpNioCustomUpdateExternalApplicationForPartyChangesNoSelect1
		@TenantId = @TenantId, @StampUserId = @StampUserId, @PartyId = @PartyId, @IsClient = @IsClient, @IsLead = @IsLead

Select 1

GO
