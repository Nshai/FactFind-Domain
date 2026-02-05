SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrRefAccessOption]
	@StampUser varchar (255),
	@AtrRefAccessOptionId bigint,
	@StampAction char(1)
AS

INSERT INTO TAtrRefAccessOptionAudit 
( Identifier, ConcurrencyId, 
	AtrRefAccessOptionId, StampAction, StampDateTime, StampUser) 
Select Identifier, ConcurrencyId, 
	AtrRefAccessOptionId, @StampAction, GetDate(), @StampUser
FROM TAtrRefAccessOption
WHERE AtrRefAccessOptionId = @AtrRefAccessOptionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
