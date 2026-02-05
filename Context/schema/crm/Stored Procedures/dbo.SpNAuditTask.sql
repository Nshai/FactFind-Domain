SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditTask]  
 @StampUser varchar (255),  
 @TaskId int,
 @StampAction char(1),
 @TenantId int

AS  
  
INSERT INTO TTaskAudit   
( StartDate, DueDate, PercentComplete, Notes,   
  AssignedUserId, PerformedUserId, AssignedToUserId, AssignedToRoleId,   
  ReminderId, Subject, RefPriorityId, Other,   
  PrivateFg, DateCompleted, EstimatedTimeHrs, EstimatedTimeMins,   
  ActualTimeHrs, ActualTimeMins, CRMContactId, URL,   
  RefTaskStatusId, ActivityOutcomeId, SequentialRef, IndigoClientId,   
  ReturnToRoleId, ConcurrencyId, EstimatedAmount, ActualAmount,  
  TaskId, StampAction, StampDateTime, StampUser,ShowinDiary,[Guid], Timezone, IsAvailableToPFPClient, 
  OriginalDueDate, IsBasedOnCompletionDate, BillingRatePerHour, SpentTimeHrs, SpentTimeMins, WorkflowName)   
Select StartDate, DueDate, PercentComplete, Notes,   
  AssignedUserId, PerformedUserId, AssignedToUserId, AssignedToRoleId,   
  ReminderId, Subject, RefPriorityId, Other,   
  PrivateFg, DateCompleted, EstimatedTimeHrs, EstimatedTimeMins,   
  ActualTimeHrs, ActualTimeMins, CRMContactId, URL,   
  RefTaskStatusId, ActivityOutcomeId, SequentialRef, IndigoClientId,   
  ReturnToRoleId, ConcurrencyId, EstimatedAmount, ActualAmount,  
  TaskId, @StampAction, GetDate(), @StampUser,ShowinDiary,[Guid], Timezone, IsAvailableToPFPClient, 
  OriginalDueDate, IsBasedOnCompletionDate, BillingRatePerHour, SpentTimeHrs, SpentTimeMins, WorkflowName
FROM TTask  
WHERE TaskId = @TaskId AND IndigoClientId = @TenantId
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  

GO