SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spNAuditClientNote] 
	@StampUser		varchar(255),
	@ClientNoteId	int,
	@StampAction	char(1)
AS
INSERT INTO [dbo].[TClientNoteAudit] (
	ClientNoteId, ClientId, [Text], CreatedOn, CreatedBy, UpdatedOn, UpdatedBy, PublishToPFP, IsKeyNote, IsSystem, MigrationRef, ConcurrencyId,  JointClientId, IsCriticalNote, TenantId, StampAction, StampDateTime, StampUser)
SELECT
	ClientNoteId, ClientId, [Text], CreatedOn, CreatedBy, UpdatedOn, UpdatedBy, PublishToPFP, IsKeyNote, IsSystem, MigrationRef, ConcurrencyId,  JointClientId, IsCriticalNote, TenantId, @StampAction, GETDATE(), @StampUser
FROM
	dbo.TClientNote
WHERE
	ClientNoteId = @ClientNoteId
GO
