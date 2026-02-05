SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomDeleteAdviceCase]
	@AdviceCaseId Bigint,
	@StampUser varchar (255),
	@TenantId int
AS
DECLARE @StampDateTime datetime = GETUTCDATE()

-- Delete all associated plans
DELETE FROM TAdviceCasePlan
OUTPUT deleted.AdviceCaseId, deleted.PolicyBusinessId, deleted.ConcurrencyId, deleted.AdviceCasePlanId, 'D', @StampDateTime, @StampUser
INTO TAdviceCasePlanAudit(AdviceCaseId, PolicyBusinessId, ConcurrencyId, AdviceCasePlanId, StampAction, StampDateTime, StampUser)
WHERE AdviceCaseId = @AdviceCaseId

IF @@ERROR  != 0 GOTO errh

-- Delete all associated fees
DELETE FROM TAdviceCaseFee
OUTPUT deleted.AdviceCaseId, deleted.FeeId, deleted.ConcurrencyId, deleted.AdviceCaseFeeId, 'D', @StampDateTime, @StampUser
INTO TAdviceCaseFeeAudit (AdviceCaseId, FeeId, ConcurrencyId, AdviceCaseFeeId, StampAction, StampDateTime, StampUser)
WHERE AdviceCaseId = @AdviceCaseId

IF @@ERROR  != 0 GOTO errh

-- Delete all associated retainers
DELETE FROM TAdviceCaseRetainer
OUTPUT deleted.AdviceCaseId, deleted.RetainerId, deleted.ConcurrencyId, deleted.AdviceCaseRetainerId, 'D', @StampDateTime, @StampUser
INTO TAdviceCaseRetainerAudit (AdviceCaseId, RetainerId, ConcurrencyId, AdviceCaseRetainerId, StampAction, StampDateTime, StampUser)
WHERE AdviceCaseId = @AdviceCaseId  

IF @@ERROR  != 0 GOTO errh

-- Delete all associated filecheck cases
DELETE FROM TAdviceCaseFileCheck
OUTPUT deleted.AdviceCaseId, deleted.FileCheckMiniId, deleted.ConcurrencyId, deleted.AdviceCaseFileCheckId, 'D', @StampDateTime, @StampUser
INTO TAdviceCaseFileCheckAudit (AdviceCaseId, FileCheckMiniId, ConcurrencyId, AdviceCaseFileCheckId, StampAction, StampDateTime, StampUser)
WHERE AdviceCaseId = @AdviceCaseId  

IF @@ERROR  != 0 GOTO errh

-- Delete Advice Case Opportunities
DELETE FROM TServiceCaseToOpportunity 
OUTPUT deleted.OpportunityId, deleted.AdviceCaseId, deleted.TenantId, deleted.ConcurrencyId, deleted.ServiceCaseToOpportunityId, 'D', @StampDateTime, @StampUser
INTO TServiceCaseToOpportunityAudit (OpportunityId, AdviceCaseId, TenantId, ConcurrencyId, ServiceCaseToOpportunityId, StampAction, StampDateTime, StampUser)
WHERE AdviceCaseId = @AdviceCaseId

IF @@ERROR  != 0 GOTO errh

-- Delete History
DELETE FROM TAdviceCaseHistory
OUTPUT deleted.AdviceCaseId, deleted.ChangeType, deleted.StatusId, deleted.PractitionerId, deleted.ChangedByUserId, deleted.StatusDate, deleted.ConcurrencyId, deleted.AdviceCaseHistoryId, 'D', @StampDateTime, @StampUser
INTO TAdviceCaseHistoryAudit (AdviceCaseId, ChangeType, StatusId, PractitionerId, ChangedByUserId, StatusDate, ConcurrencyId, AdviceCaseHistoryId, StampAction, StampDateTime, StampUser)
WHERE AdviceCaseId = @AdviceCaseId

IF @@ERROR != 0 GOTO errh

-- Unlink all associated tasks (Update AdviceCaseId = NULL in TOrganiserActivity)
UPDATE
	A
SET 
	AdviceCaseId = NULL
OUTPUT 
	deleted.AppointmentId, deleted.ActivityCategoryParentId, deleted.ActivityCategoryId, deleted.TaskId, deleted.CompleteFG, deleted.PolicyId, deleted.FeeId, deleted.RetainerId, deleted.OpportunityId, 
	deleted.EventListActivityId, deleted.CRMContactId, deleted.JointCRMContactId, deleted.IndigoClientId, deleted.AdviceCaseId, deleted.ConcurrencyId, deleted.OrganiserActivityId, 
	'U', @StampDateTime, @StampUser, deleted.IsRecurrence, deleted.RecurrenceSeriesId, deleted.MigrationRef, deleted.CreatedDate, deleted.CreatedByUserId, deleted.UpdatedOn, deleted.UpdatedByUserId
INTO TOrganiserActivityAudit(
	AppointmentId, ActivityCategoryParentId, ActivityCategoryId, TaskId, CompleteFG, PolicyId, FeeId, RetainerId, OpportunityId, 
	EventListActivityId, CRMContactId, JointCRMContactId, IndigoClientId, AdviceCaseId, ConcurrencyId, OrganiserActivityId, 
	StampAction, StampDateTime, StampUser, IsRecurrence, RecurrenceSeriesId, MigrationRef, CreatedDate, CreatedByUserId, UpdatedOn, UpdatedByUserId)
FROM
	CRM..TOrganiserActivity A
	JOIN CRM..TTask T ON T.TaskId = A.TaskId AND T.IndigoClientId = A.IndigoClientId -- this joins reduces subtree cost
WHERE
	A.IndigoClientId = @TenantId AND A.AdviceCaseId = @AdviceCaseId

IF @@ERROR  != 0 GOTO errh

Declare @Result int
Execute @Result = dbo.SpNAuditAdviceCase @StampUser, @AdviceCaseId, 'D'

IF @@ERROR  != 0 GOTO errh

DELETE 
FROM TAdviceCase
WHERE AdviceCaseId = @AdviceCaseId

IF @@ERROR != 0 GOTO errh

SELECT 1

errh:

RETURN (100)
GO
