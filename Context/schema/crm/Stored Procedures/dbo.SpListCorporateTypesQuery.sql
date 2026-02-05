SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SpListCorporateTypesQuery]
AS

SELECT
	c.RefCorporateTypeId AS Id,
	c.TypeName AS [Type]
FROM TRefCorporateType AS c
WHERE ISNULL(c.ArchiveFg, 0) = 0
ORDER BY [Type]

GO