SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditOrganiserActivity]
	@StampUser varchar (255),
	@OrganiserActivityId bigint,
	@StampAction char(1)
AS

INSERT INTO TOrganiserActivityAudit ( 
	AppointmentId, ActivityCategoryParentId, ActivityCategoryId, TaskId, 
	CompleteFG, PolicyId, FeeId, RetainerId, 
	OpportunityId, EventListActivityId, CRMContactId, IndigoClientId, 
	AdviceCaseId, ConcurrencyId, OrganiserActivityId, StampAction, StampDateTime, StampUser, 
	IsRecurrence, RecurrenceSeriesId, MigrationRef, JointCRMContactId, CreatedDate, CreatedByUserId, UpdatedOn, UpdatedByUserId,PropertiesJson) 
SELECT 
	AppointmentId, ActivityCategoryParentId, ActivityCategoryId, TaskId, 
	CompleteFG, PolicyId, FeeId, RetainerId, 
	OpportunityId, EventListActivityId, CRMContactId, IndigoClientId, 
	AdviceCaseId, ConcurrencyId, OrganiserActivityId, @StampAction, GETDATE(), @StampUser, 
	IsRecurrence, RecurrenceSeriesId, MigrationRef, JointCRMContactId, CreatedDate, CreatedByUserId, UpdatedOn, UpdatedByUserId,PropertiesJson
FROM 
	TOrganiserActivity
WHERE 
	OrganiserActivityId = @OrganiserActivityId

IF @@ERROR != 0 GOTO errh
RETURN (0)

errh:
RETURN (100)
GO
