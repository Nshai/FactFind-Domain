SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAction]
	@StampUser varchar (255),
	@ActionId bigint,
	@StampAction char(1)
AS

INSERT INTO TActionAudit 
( Identifier, Descriptor, Javascript, Ordinal, 
		FactFindTypeId, ConcurrencyId, 
	ActionId, StampAction, StampDateTime, StampUser) 
Select Identifier, Descriptor, Javascript, Ordinal, 
		FactFindTypeId, ConcurrencyId, 
	ActionId, @StampAction, GetDate(), @StampUser
FROM TAction
WHERE ActionId = @ActionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
