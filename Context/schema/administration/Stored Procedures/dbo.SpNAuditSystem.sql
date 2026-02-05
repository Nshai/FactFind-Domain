SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditSystem]
	@StampUser varchar (255),
	@SystemId bigint,
	@StampAction char(1)
AS

INSERT INTO TSystemAudit 
( Identifier, Description, SystemPath, SystemType, 
		ParentId, Url, EntityId, ConcurrencyId, 
		
	SystemId, StampAction, StampDateTime, StampUser) 
Select Identifier, Description, SystemPath, SystemType, 
		ParentId, Url, EntityId, ConcurrencyId, 
		
	SystemId, @StampAction, GetDate(), @StampUser
FROM TSystem
WHERE SystemId = @SystemId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
