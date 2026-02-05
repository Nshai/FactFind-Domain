SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_ListTasksForAdviserReallocation]
	@AdviserReallocateStatsId bigint,
	@NewAdviserUserId bigint,
	@TenantId int
AS

BEGIN

SELECT DISTINCT 
	Task.TaskId AS [TempDataId],    
	RAll.AdviserReallocateStatsId AS [ReallocateStatsId],
	'Task' AS [RecordType]
FROM     
  TTask Task   
  JOIN TAdviserReallocateClientDetails RAll WITH(NoLock) ON RAll.ClientPartyId = Task.CRMContactId    
  JOIN TCRMContact CRM  WITH(NoLock) ON RAll.ClientPartyId = CRM.CRMContactId  
  JOIN Administration..TUser U  WITH(NoLock) ON U.UserId = Task.AssignedToUserId    
  LEFT JOIN TRefTaskStatus Rts WITH(NoLock) ON Rts.RefTaskStatusId = Task.RefTaskStatusId     
 WHERE
  Task.IndigoClientId = @TenantId
  AND AssignedToUserId!=@NewAdviserUserId
  AND ISNULL(Rts.[Name], '')!='Complete' -- Don'Task worry about complete tasks    
  AND U.CRMContactId = CRM.CurrentAdviserCRMId -- Only update tasks that assigned to the clients current adviser    
  AND RAll.AdviserReallocateStatsId = @AdviserReallocateStatsId

END
GO
