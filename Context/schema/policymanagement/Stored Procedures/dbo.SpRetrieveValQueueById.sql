SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveValQueueById]
@ValQueueId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.ValQueueId AS [ValQueue!1!ValQueueId], 
    T1.Guid AS [ValQueue!1!Guid], 
    T1.PolicyBusinessId AS [ValQueue!1!PolicyBusinessId], 
    T1.Status AS [ValQueue!1!Status], 
    ISNULL(T1.ValRequestId, '') AS [ValQueue!1!ValRequestId], 
    CONVERT(varchar(24), T1.StartTime, 120) AS [ValQueue!1!StartTime], 
    ISNULL(CONVERT(varchar(24), T1.EndTime, 120),'') AS [ValQueue!1!EndTime], 
    T1.ConcurrencyId AS [ValQueue!1!ConcurrencyId]
  FROM TValQueue T1

  WHERE (T1.ValQueueId = @ValQueueId)

  ORDER BY [ValQueue!1!ValQueueId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
