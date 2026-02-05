SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditLeadType]
	@StampUser varchar (255),
	@LeadTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TLeadTypeAudit 
( Descriptor, IndigoClientId, ConcurrencyId, 
	LeadTypeId, StampAction, StampDateTime, StampUser) 
Select Descriptor, IndigoClientId, ConcurrencyId, 
	LeadTypeId, @StampAction, GetDate(), @StampUser
FROM TLeadType
WHERE LeadTypeId = @LeadTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
