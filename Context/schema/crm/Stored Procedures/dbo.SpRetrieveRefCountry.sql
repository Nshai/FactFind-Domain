SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefCountry]
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefCountryId AS [RefCountry!1!RefCountryId], 
    T1.CountryName AS [RefCountry!1!CountryName], 
    T1.ArchiveFG AS [RefCountry!1!ArchiveFG], 
    T1.ConcurrencyId AS [RefCountry!1!ConcurrencyId]
  FROM TRefCountry T1

  ORDER BY [RefCountry!1!RefCountryId]

  FOR XML EXPLICIT

END
RETURN (0)









GO
