SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFactFind]
	@StampUser varchar (255),
	@FactFindId bigint,
	@StampAction char(1)
AS

INSERT INTO TFactFindAudit 
( CRMContactId1, CRMContactId2, FactFindTypeId, IndigoClientId, 
		ConcurrencyId,
	FactFindId, StampAction, StampDateTime, StampUser) 
Select CRMContactId1, CRMContactId2, FactFindTypeId, IndigoClientId, 
		ConcurrencyId, 
	FactFindId, @StampAction, GetDate(), @StampUser
FROM TFactFind
WHERE FactFindId = @FactFindId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
