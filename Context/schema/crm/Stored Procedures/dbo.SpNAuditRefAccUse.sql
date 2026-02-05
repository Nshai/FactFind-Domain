SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefAccUse]
	@StampUser varchar (255),
	@RefAccUseId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefAccUseAudit 
( IndClientId, AccountUseDesc, ConcurrencyId, 
	RefAccUseId, StampAction, StampDateTime, StampUser) 
Select IndClientId, AccountUseDesc, ConcurrencyId, 
	RefAccUseId, @StampAction, GetDate(), @StampUser
FROM TRefAccUse
WHERE RefAccUseId = @RefAccUseId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
