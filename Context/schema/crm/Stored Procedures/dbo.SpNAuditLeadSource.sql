SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditLeadSource]
	@StampUser varchar (255),
	@LeadSourceId bigint,
	@StampAction char(1)
AS

INSERT INTO TLeadSourceAudit 
( LeadTypeId, Descriptor, Reference, Cost, 
		ConcurrencyId, 
	LeadSourceId, StampAction, StampDateTime, StampUser) 
Select LeadTypeId, Descriptor, Reference, Cost, 
		ConcurrencyId, 
	LeadSourceId, @StampAction, GetDate(), @StampUser
FROM TLeadSource
WHERE LeadSourceId = @LeadSourceId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
