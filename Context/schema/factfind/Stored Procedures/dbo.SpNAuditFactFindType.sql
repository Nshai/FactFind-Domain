SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFactFindType]
	@StampUser varchar (255),
	@FactFindTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TFactFindTypeAudit 
(Identifier, Descriptor, CRMContactType, IndigoClientId, ConcurrencyId,
	FactFindTypeId, StampAction, StampDateTime, StampUser)
SELECT  Identifier, Descriptor, CRMContactType, IndigoClientId, ConcurrencyId,
	FactFindTypeId, @StampAction, GetDate(), @StampUser
FROM TFactFindType
WHERE FactFindTypeId = @FactFindTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
