SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditDeceased]
	@StampUser varchar (255),
	@DeceasedId bigint,
	@StampAction char(1)
AS

INSERT INTO TDeceasedAudit 
( CRMContactId, DeceasedFG, DeceasedDate, ConcurrencyId, 
		
	DeceasedId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, DeceasedFG, DeceasedDate, ConcurrencyId, 
		
	DeceasedId, @StampAction, GetDate(), @StampUser
FROM TDeceased
WHERE DeceasedId = @DeceasedId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
