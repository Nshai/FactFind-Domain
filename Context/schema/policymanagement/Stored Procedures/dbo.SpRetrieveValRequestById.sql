SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveValRequestById]
@ValRequestId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.ValRequestId AS [ValRequest!1!ValRequestId], 
    T1.PractitionerId AS [ValRequest!1!PractitionerId], 
    ISNULL(T1.CRMContactId, '') AS [ValRequest!1!CRMContactId], 
    ISNULL(T1.PolicyBusinessId, '') AS [ValRequest!1!PolicyBusinessId], 
    ISNULL(T1.PlanValuationId, '') AS [ValRequest!1!PlanValuationId], 
    T1.ValuationType AS [ValRequest!1!ValuationType], 
    T1.RequestXML AS [ValRequest!1!RequestXML], 
    T1.RequestedUserId AS [ValRequest!1!RequestedUserId], 
    CONVERT(varchar(24), T1.RequestedDate, 120) AS [ValRequest!1!RequestedDate], 
    T1.RequestStatus AS [ValRequest!1!RequestStatus], 
    T1.ConcurrencyId AS [ValRequest!1!ConcurrencyId]
  FROM TValRequest T1

  WHERE (T1.ValRequestId = @ValRequestId)

  ORDER BY [ValRequest!1!ValRequestId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
