SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveStatusByIdAndIndigoClientId]
@StatusId bigint,
@IndigoClientId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.StatusId AS [Status!1!StatusId], 
    T1.Name AS [Status!1!Name], 
    ISNULL(T1.OrigoStatusId, '') AS [Status!1!OrigoStatusId], 
    ISNULL(T1.IntelligentOfficeStatusType, '') AS [Status!1!IntelligentOfficeStatusType], 
    T1.PreComplianceCheck AS [Status!1!PreComplianceCheck], 
    T1.PostComplianceCheck AS [Status!1!PostComplianceCheck], 
    T1.IndigoClientId AS [Status!1!IndigoClientId], 
    T1.ConcurrencyId AS [Status!1!ConcurrencyId]
  FROM TStatus T1

  WHERE (T1.StatusId = @StatusId) AND 
        (T1.IndigoClientId = @IndigoClientId)

  ORDER BY [Status!1!StatusId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
