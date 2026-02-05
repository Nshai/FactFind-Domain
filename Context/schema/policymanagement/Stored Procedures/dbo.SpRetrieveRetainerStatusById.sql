SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRetainerStatusById]
@RetainerStatusId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RetainerStatusId AS [RetainerStatus!1!RetainerStatusId], 
    T1.RetainerId AS [RetainerStatus!1!RetainerId], 
    T1.Status AS [RetainerStatus!1!Status], 
    ISNULL(T1.StatusNotes, '') AS [RetainerStatus!1!StatusNotes], 
    CONVERT(varchar(24), T1.StatusDate, 120) AS [RetainerStatus!1!StatusDate], 
    T1.UpdatedUserId AS [RetainerStatus!1!UpdatedUserId], 
    T1.ConcurrencyId AS [RetainerStatus!1!ConcurrencyId]
  FROM TRetainerStatus T1

  WHERE (T1.RetainerStatusId = @RetainerStatusId)

  ORDER BY [RetainerStatus!1!RetainerStatusId]

  FOR XML EXPLICIT

END
RETURN (0)




GO
