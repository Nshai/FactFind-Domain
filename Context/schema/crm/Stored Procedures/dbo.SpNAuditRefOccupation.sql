SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefOccupation]
	@StampUser varchar (255),
	@RefOccupationId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefOccupationAudit 
( Description, OrigoCode, IsArchived, ConcurrencyId, 
		
	RefOccupationId, StampAction, StampDateTime, StampUser) 
Select Description, OrigoCode, IsArchived, ConcurrencyId, 
		
	RefOccupationId, @StampAction, GetDate(), @StampUser
FROM TRefOccupation
WHERE RefOccupationId = @RefOccupationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
