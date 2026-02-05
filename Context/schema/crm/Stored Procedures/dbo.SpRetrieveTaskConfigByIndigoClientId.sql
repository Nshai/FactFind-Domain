SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveTaskConfigByIndigoClientId]
@IndigoClientId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.TaskConfigId AS [TaskConfig!1!TaskConfigId], 
    T1.IndigoClientId AS [TaskConfig!1!IndigoClientId], 
    T1.AllowAutoAllocation AS [TaskConfig!1!AllowAutoAllocation], 
    T1.MaxTasksPerUser AS [TaskConfig!1!MaxTasksPerUser], 
    T1.AssignedToDefault AS [TaskConfig!1!AssignedToDefault], 
    T1.LockDefault AS [TaskConfig!1!LockDefault], 
    T1.ConcurrencyId AS [TaskConfig!1!ConcurrencyId]
  FROM TTaskConfig T1

  WHERE (T1.IndigoClientId = @IndigoClientId)

  ORDER BY [TaskConfig!1!TaskConfigId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
