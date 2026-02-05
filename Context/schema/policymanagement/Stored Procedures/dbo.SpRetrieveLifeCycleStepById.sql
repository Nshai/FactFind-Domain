SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveLifeCycleStepById]
@LifeCycleStepId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.LifeCycleStepId AS [LifeCycleStep!1!LifeCycleStepId], 
    T1.StatusId AS [LifeCycleStep!1!StatusId], 
    T1.LifeCycleId AS [LifeCycleStep!1!LifeCycleId], 
    T1.ConcurrencyId AS [LifeCycleStep!1!ConcurrencyId]
  FROM TLifeCycleStep T1

  WHERE (T1.LifeCycleStepId = @LifeCycleStepId)

  ORDER BY [LifeCycleStep!1!LifeCycleStepId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
