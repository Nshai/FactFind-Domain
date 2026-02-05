SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spNAuditLeadNote] 
	@StampUser		varchar(255),
	@LeadNoteId	int,
	@StampAction	char(1)
AS
INSERT INTO [dbo].[TLeadNoteAudit] (
	LeadNoteId, TenantId, LeadId, [Text], CreatedOn, CreatedBy, UpdatedOn, UpdatedBy, IsSystem, ConcurrencyId, StampAction, StampDateTime, StampUser)
SELECT
	LeadNoteId, TenantId, LeadId, [Text], CreatedOn, CreatedBy, UpdatedOn, UpdatedBy, IsSystem, ConcurrencyId, @StampAction, GETDATE(), @StampUser
FROM
	dbo.TLeadNote
WHERE
	LeadNoteId = @LeadNoteId
GO
