SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditGrouping]
	@StampUser varchar (255),
	@GroupingId bigint,
	@StampAction char(1)
AS

INSERT INTO TGroupingAudit 
( Identifier, ParentId, IsPayable, IndigoClientId, 
		ConcurrencyId, 
	GroupingId, StampAction, StampDateTime, StampUser) 
Select Identifier, ParentId, IsPayable, IndigoClientId, 
		ConcurrencyId, 
	GroupingId, @StampAction, GetDate(), @StampUser
FROM TGrouping
WHERE GroupingId = @GroupingId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
