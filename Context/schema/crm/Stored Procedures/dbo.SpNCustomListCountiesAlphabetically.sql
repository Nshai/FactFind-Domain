SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomListCountiesAlphabetically]
AS

SELECT 1 as tag,
null as parent,
t1.RefCountyId AS [County!1!RefCountyId],
t1.CountyName AS  [County!1!CountyName],
t1.CountyCode AS  [County!1!CountyCode]
FROM TRefCounty t1 WITH(NOLOCK)
WHERE t1.ArchiveFG = 0

ORDER BY [County!1!CountyName]

FOR XML EXPLICIT
GO
