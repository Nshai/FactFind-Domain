SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditLead]
	@StampUser varchar (255),
	@LeadId bigint,
	@StampAction char(1)
AS

declare @MaxLeadId bigint

INSERT INTO TLeadAudit 
( CRMContactId, LeadSourceId, IndigoClientId, ConcurrencyId, LeadId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, LeadSourceId, IndigoClientId, ConcurrencyId, LeadId, @StampAction, GetDate(), @StampUser
FROM TLead
WHERE CRMContactId = @LeadId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
