SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefAdverseCredit]
	@StampUser varchar (255),
	@RefAdverseCreditId bigint,	
	@StampAction char(1)
AS

INSERT INTO TRefAdverseCreditAudit
( RefAdverseCreditId, Name,  ConcurrencyId, StampAction, StampDateTime, StampUser) 
SELECT RefAdverseCreditId, Name, ConcurrencyId, @StampAction, GetDate(), @StampUser
FROM TRefAdverseCredit
WHERE RefAdverseCreditId = @RefAdverseCreditId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
