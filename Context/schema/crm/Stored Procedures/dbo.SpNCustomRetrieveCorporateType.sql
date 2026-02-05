SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SpNCustomRetrieveCorporateTypes]
AS

SELECT 1 AS TAG,
	NULL AS Parent,
	c.TypeName AS [Type!1!description],
	c.RefCorporateTypeId AS [Type!1!!ELEMENT]
FROM TRefCorporateType c
WHERE ISNULL(c.ArchiveFg, 0) = 0
ORDER BY [Type!1!description]
FOR XML EXPLICIT

GO
