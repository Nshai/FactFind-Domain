SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveStatusHistoryById]
@StatusHistoryId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.StatusHistoryId AS [StatusHistory!1!StatusHistoryId], 
    T1.PolicyBusinessId AS [StatusHistory!1!PolicyBusinessId], 
    T1.StatusId AS [StatusHistory!1!StatusId], 
    ISNULL(T1.StatusReasonId, '') AS [StatusHistory!1!StatusReasonId], 
    CONVERT(varchar(24), T1.ChangedToDate, 120) AS [StatusHistory!1!ChangedToDate], 
    T1.ChangedByUserId AS [StatusHistory!1!ChangedByUserId], 
    ISNULL(CONVERT(varchar(24), T1.DateOfChange, 120),'') AS [StatusHistory!1!DateOfChange], 
    T1.LifeCycleStepFG AS [StatusHistory!1!LifeCycleStepFG], 
    T1.CurrentStatusFG AS [StatusHistory!1!CurrentStatusFG], 
    T1.ConcurrencyId AS [StatusHistory!1!ConcurrencyId]
  FROM TStatusHistory T1

  WHERE (T1.StatusHistoryId = @StatusHistoryId)

  ORDER BY [StatusHistory!1!StatusHistoryId]

  FOR XML EXPLICIT

END
RETURN (0)




GO
