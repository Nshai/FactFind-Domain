SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefCounty]
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefCountyId AS [RefCounty!1!RefCountyId], 
    ISNULL(T1.CountyName, '') AS [RefCounty!1!CountyName], 
    T1.RefCountryId AS [RefCounty!1!RefCountryId], 
    T1.ArchiveFG AS [RefCounty!1!ArchiveFG], 
    T1.ConcurrencyId AS [RefCounty!1!ConcurrencyId]
  FROM TRefCounty T1

  ORDER BY [RefCounty!1!RefCountyId]

  FOR XML EXPLICIT

END
RETURN (0)









GO
