SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveEmailQueueById]
@EmailQueueId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.EmailQueueId AS [EmailQueue!1!EmailQueueId], 
    T1.IndigoClientId AS [EmailQueue!1!IndigoClientId], 
    ISNULL(T1.OwnerId, '') AS [EmailQueue!1!OwnerId], 
    T1.QueueDescription AS [EmailQueue!1!QueueDescription], 
    ISNULL(T1.Subject, '') AS [EmailQueue!1!Subject], 
    ISNULL(T1.StatusId, '') AS [EmailQueue!1!StatusId], 
    ISNULL(T1.ToAddress, '') AS [EmailQueue!1!ToAddress], 
    ISNULL(T1.FromAddress, '') AS [EmailQueue!1!FromAddress], 
    ISNULL(T1.CcAddress, '') AS [EmailQueue!1!CcAddress], 
    ISNULL(T1.BccAddress, '') AS [EmailQueue!1!BccAddress], 
    ISNULL(T1.Body, '') AS [EmailQueue!1!Body], 
    T1.PreMergedFg AS [EmailQueue!1!PreMergedFg], 
    ISNULL(T1.Guid, '') AS [EmailQueue!1!Guid], 
    ISNULL(T1.MergeData, '') AS [EmailQueue!1!MergeData], 
    CONVERT(varchar(24), T1.AddedDate, 120) AS [EmailQueue!1!AddedDate], 
    T1.ConcurrencyId AS [EmailQueue!1!ConcurrencyId]
  FROM TEmailQueue T1

  WHERE (T1.EmailQueueId = @EmailQueueId)

  ORDER BY [EmailQueue!1!EmailQueueId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
