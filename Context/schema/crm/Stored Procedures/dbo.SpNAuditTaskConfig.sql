SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditTaskConfig]  
	@StampUser varchar (255),
	@TaskConfigId bigint,
	@StampAction char(1)  
AS  
  
INSERT INTO TTaskConfigAudit 
( IndigoClientId, AllowAutoAllocation, MaxTasksPerUser, AssignedToDefault, 
		LockDefault, ConcurrencyId, 
	TaskConfigId, StampAction, StampDateTime, StampUser, ShowinDiaryDefault) 
Select IndigoClientId, AllowAutoAllocation, MaxTasksPerUser, AssignedToDefault, 
		LockDefault, ConcurrencyId, 
	TaskConfigId, @StampAction, GetDate(), @StampUser, ShowinDiaryDefault
FROM TTaskConfig
WHERE TaskConfigId = @TaskConfigId 
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
