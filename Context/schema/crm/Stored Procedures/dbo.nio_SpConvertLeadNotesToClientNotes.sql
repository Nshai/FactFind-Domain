SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpConvertLeadNotesToClientNotes]
	@CRMContactId int,
	@TenantId int,
	@StampUser int
AS
SET NOCOUNT ON;
DECLARE @StampDateTime datetime = GETDATE()


-- Migrate client notes from TNote to TClientNote table
INSERT INTO [dbo].[TClientNote] (ClientId, [Text], CreatedOn, CreatedBy, IsKeyNote, UpdatedOn, UpdatedBy, PublishToPFP, IsSystem, MigrationRef, ConcurrencyId, TenantId)
OUTPUT
				  inserted.ClientNoteId
				, inserted.ClientId
				, inserted.[Text]
				, inserted.CreatedOn
				, inserted.CreatedBy
				, inserted.UpdatedOn
				, inserted.UpdatedBy
				, inserted.PublishToPFP
				, inserted.IsKeyNote
				, inserted.IsSystem
				, inserted.MigrationRef
				, inserted.ConcurrencyId
				, inserted.TenantId
				, 'C'
				, @StampDateTime
				, @StampUser
			INTO
				[dbo].[TClientNoteAudit]
				(ClientNoteId
				, ClientId
				, [Text]
				, CreatedOn
				, CreatedBy
				, UpdatedOn
				, UpdatedBy
				, PublishToPFP
				, IsKeyNote
				, IsSystem
				, MigrationRef
				, ConcurrencyId
				, TenantId
				, StampAction
				, StampDateTime
				, StampUser)
 
SELECT @CRMContactId, [Text], CreatedOn, CreatedBy, 0,  UpdatedOn, UpdatedBy, 0, IsSystem, NULL, 1, TenantId  
FROM [dbo].[TLeadNote] 
WHERE TenantId = @TenantId AND LeadId = @CRMContactId

GO
