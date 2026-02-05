SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditResourceList]
	@StampUser varchar (255),
	@ResourceListId bigint,
	@StampAction char(1)
AS

INSERT INTO TResourceListAudit 
( Description, CalenderFG, IndClientId, ConcurrencyId, 
		
	ResourceListId, StampAction, StampDateTime, StampUser) 
Select Description, CalenderFG, IndClientId, ConcurrencyId, 
		
	ResourceListId, @StampAction, GetDate(), @StampUser
FROM TResourceList
WHERE ResourceListId = @ResourceListId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
