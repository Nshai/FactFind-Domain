SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveDashboardComponentExclusionByIndigoClientId]
@IndigoClientId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.DashboardComponentExclusionId AS [DashboardComponentExclusion!1!DashboardComponentExclusionId], 
    T1.IndigoClientId AS [DashboardComponentExclusion!1!IndigoClientId], 
    ISNULL(T1.Dashboard, '') AS [DashboardComponentExclusion!1!Dashboard], 
    ISNULL(T1.Component, '') AS [DashboardComponentExclusion!1!Component], 
    T1.ConcurrencyId AS [DashboardComponentExclusion!1!ConcurrencyId]
  FROM TDashboardComponentExclusion T1

  WHERE (T1.IndigoClientId = @IndigoClientId)

  ORDER BY [DashboardComponentExclusion!1!DashboardComponentExclusionId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
