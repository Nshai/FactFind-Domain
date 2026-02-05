SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditGroupSchemeMemberImport]
	@StampUser varchar (255),
	@GroupSchemeMemberImportId bigint,
	@StampAction char(1)
AS

INSERT INTO TGroupSchemeMemberImportAudit 
( TenantId, GroupSchemeId, ImportFileId, DefaultCategoryId, 
		DefaultAdviserCRMContactId, IsUpdateContributions, ConcurrencyId, 
	GroupSchemeMemberImportId, StampAction, StampDateTime, StampUser) 
Select TenantId, GroupSchemeId, ImportFileId, DefaultCategoryId, 
		DefaultAdviserCRMContactId, IsUpdateContributions, ConcurrencyId, 
	GroupSchemeMemberImportId, @StampAction, GetDate(), @StampUser
FROM TGroupSchemeMemberImport
WHERE GroupSchemeMemberImportId = @GroupSchemeMemberImportId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
