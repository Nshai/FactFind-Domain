SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomListCountriesAlphabetically]
AS

SELECT 1 as tag,
null as parent,
1 AS [Country!1!Key!hide],
t1.RefCountryId AS [Country!1!RefCountryId],
t1.CountryName AS  [Country!1!CountryName],
t1.CountryCode AS  [Country!1!CountryCode]
FROM TRefCountry t1 WITH(NOLOCK)
WHERE CountryName='United Kingdom'

UNION ALL

SELECT 1 as tag,
null as parent,
2 AS [Country!1!Key!hide],
t1.RefCountryId AS [Country!1!RefCountryId],
t1.CountryName AS  [Country!1!CountryName],
t1.CountryCode AS  [Country!1!CountryCode]
FROM TRefCountry t1 WITH(NOLOCK)
WHERE CountryName='United States of America'

UNION ALL

SELECT 1 as tag,
null as parent,
3 AS [Country!1!Key!hide],
t1.RefCountryId AS [Country!1!RefCountryId],
t1.CountryName AS  [Country!1!CountryName],
t1.CountryCode AS  [Country!1!CountryCode]
FROM TRefCountry t1 WITH(NOLOCK)
WHERE ArchiveFG=0
AND CountryName!='United Kingdom'
AND CountryName!='United States of America'


ORDER BY [Country!1!Key!hide],[Country!1!CountryName]

FOR XML EXPLICIT
GO
