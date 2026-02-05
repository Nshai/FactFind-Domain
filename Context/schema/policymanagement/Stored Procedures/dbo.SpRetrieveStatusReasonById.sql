SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveStatusReasonById]
@StatusReasonId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.StatusReasonId AS [StatusReason!1!StatusReasonId], 
    T1.Name AS [StatusReason!1!Name], 
    T1.StatusId AS [StatusReason!1!StatusId], 
    ISNULL(T1.OrigoStatusId, '') AS [StatusReason!1!OrigoStatusId], 
    ISNULL(T1.IntelligentOfficeStatusType, '') AS [StatusReason!1!IntelligentOfficeStatusType], 
    T1.IndigoClientId AS [StatusReason!1!IndigoClientId], 
    T1.ConcurrencyId AS [StatusReason!1!ConcurrencyId]
  FROM TStatusReason T1

  WHERE (T1.StatusReasonId = @StatusReasonId)

  ORDER BY [StatusReason!1!StatusReasonId]

  FOR XML EXPLICIT

END
RETURN (0)




GO
