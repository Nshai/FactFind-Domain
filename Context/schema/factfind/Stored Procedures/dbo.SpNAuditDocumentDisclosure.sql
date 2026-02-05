SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditDocumentDisclosure]
	@StampUser varchar (255),
	@DocumentDisclosureId bigint,
	@StampAction char(1)
AS

INSERT INTO TDocumentDisclosureAudit (
	DocumentDisclosureId, ConcurrencyId, CRMContactId, DocumentDisclosureTypeId, IssueDate, IsClientPresent, 
	StampAction, StampDateTime, StampUser)
SELECT  
	DocumentDisclosureId, ConcurrencyId, CRMContactId, DocumentDisclosureTypeId, IssueDate, IsClientPresent,
	@StampAction, GetDate(), @StampUser
FROM TDocumentDisclosure
WHERE DocumentDisclosureId = @DocumentDisclosureId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
