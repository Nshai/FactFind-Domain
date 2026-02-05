SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spNAuditGroupSchemeNote] 
	@StampUser varchar(255),
	@GroupSchemeNoteId	int,
	@StampAction char(1)
AS
INSERT INTO [dbo].[TGroupSchemeNoteAudit] (
	GroupSchemeNoteId,	GroupSchemeId, TenantId, [Text], CreatedOn, CreatedBy, UpdatedOn, UpdatedBy, IsSystem, ConcurrencyId, StampAction, StampDateTime, StampUser)
SELECT
	GroupSchemeNoteId,	GroupSchemeId, TenantId, [Text], CreatedOn, CreatedBy, UpdatedOn, UpdatedBy, IsSystem, ConcurrencyId, @StampAction, GETDATE(), @StampUser
FROM
	dbo.TGroupSchemeNote
WHERE
	GroupSchemeNoteId = @GroupSchemeNoteId
GO