SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditPlanExceptionQueue]
	@StampUser varchar (255),
	@PlanExceptionQueueId bigint,
	@StampAction char(1)
AS

INSERT INTO TPlanExceptionQueueAudit 
( PolicyBusinessId, PlanTypeExceptionId, IsPreSale, TnCCoachId, 
		DateCreated, DateModified, TenantId, ConcurrencyId, 
		
	PlanExceptionQueueId, StampAction, StampDateTime, StampUser, IsArchived, ArchivedDate, ArchiveReason) 
Select PolicyBusinessId, PlanTypeExceptionId, IsPreSale, TnCCoachId, 
		DateCreated, DateModified, TenantId, ConcurrencyId, 
		
	PlanExceptionQueueId, @StampAction, GetDate(), @StampUser, IsArchived, ArchivedDate, ArchiveReason
FROM TPlanExceptionQueue
WHERE PlanExceptionQueueId = @PlanExceptionQueueId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
