SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditDocumentDisclosureType]
	@StampUser varchar (255),
	@DocumentDisclosureTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TDocumentDisclosureTypeAudit (ConcurrencyId, Name, IsArchived, IndigoClientId,DocumentDisclosureTypeId, StampAction, StampDateTime, StampUser)
SELECT  ConcurrencyId, Name, IsArchived, IndigoClientId,	DocumentDisclosureTypeId, @StampAction, GetDate(), @StampUser
FROM TDocumentDisclosureType
WHERE DocumentDisclosureTypeId = @DocumentDisclosureTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
