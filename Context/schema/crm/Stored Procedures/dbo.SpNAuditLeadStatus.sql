SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditLeadStatus]
	@StampUser varchar (255),
	@LeadStatusId bigint,
	@StampAction char(1)
AS

INSERT INTO TLeadStatusAudit 
( Descriptor, CanConvertToClientFG, OrderNumber, IndigoClientId, 
		ConcurrencyId, 
	LeadStatusId, StampAction, StampDateTime, StampUser) 
Select Descriptor, CanConvertToClientFG, OrderNumber, IndigoClientId, 
		ConcurrencyId, 
	LeadStatusId, @StampAction, GetDate(), @StampUser
FROM TLeadStatus
WHERE LeadStatusId = @LeadStatusId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
