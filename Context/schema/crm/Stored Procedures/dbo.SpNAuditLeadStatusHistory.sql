SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditLeadStatusHistory]
	@StampUser varchar (255),
	@LeadStatusHistoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TLeadStatusHistoryAudit 
( LeadId, LeadStatusId, Notes, DateChanged, 
		ChangedByUserId, CurrentFG, ConcurrencyId, 
	LeadStatusHistoryId, StampAction, StampDateTime, StampUser) 
Select LeadId, LeadStatusId, Notes, DateChanged, 
		ChangedByUserId, CurrentFG, ConcurrencyId, 
	LeadStatusHistoryId, @StampAction, GetDate(), @StampUser
FROM TLeadStatusHistory
WHERE LeadStatusHistoryId = @LeadStatusHistoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
