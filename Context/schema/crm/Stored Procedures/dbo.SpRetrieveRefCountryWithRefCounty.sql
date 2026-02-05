SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefCountryWithRefCounty]
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefCountryId AS [RefCountry!1!RefCountryId], 
    T1.CountryName AS [RefCountry!1!CountryName], 
    T1.ArchiveFG AS [RefCountry!1!ArchiveFG], 
    T1.ConcurrencyId AS [RefCountry!1!ConcurrencyId], 
    NULL AS [RefCounty!2!RefCountyId], 
    NULL AS [RefCounty!2!CountyName], 
    NULL AS [RefCounty!2!RefCountryId], 
    NULL AS [RefCounty!2!ArchiveFG], 
    NULL AS [RefCounty!2!ConcurrencyId]
  FROM TRefCountry T1

  UNION ALL

  SELECT
    2 AS Tag,
    1 AS Parent,
    T1.RefCountryId, 
    T1.CountryName, 
    T1.ArchiveFG, 
    T1.ConcurrencyId, 
    T2.RefCountyId, 
    ISNULL(T2.CountyName, ''), 
    T2.RefCountryId, 
    T2.ArchiveFG, 
    T2.ConcurrencyId
  FROM TRefCounty T2
  INNER JOIN TRefCountry T1
  ON T2.RefCountryId = T1.RefCountryId

  ORDER BY [RefCountry!1!RefCountryId], [RefCounty!2!CountyName]

  FOR XML EXPLICIT

END
RETURN (0)










GO
