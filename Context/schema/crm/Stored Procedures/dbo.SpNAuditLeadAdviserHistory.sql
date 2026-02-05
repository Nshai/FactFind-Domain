SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditLeadAdviserHistory]
	@StampUser varchar (255),
	@LeadAdviserHistoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TLeadAdviserHistoryAudit 
( LeadId, AdviserId, ChangedByUserId, AssignedDate, 
		ConcurrencyId, 
	LeadAdviserHistoryId, StampAction, StampDateTime, StampUser) 
Select LeadId, AdviserId, ChangedByUserId, AssignedDate, 
		ConcurrencyId, 
	LeadAdviserHistoryId, @StampAction, GetDate(), @StampUser
FROM TLeadAdviserHistory
WHERE LeadAdviserHistoryId = @LeadAdviserHistoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
