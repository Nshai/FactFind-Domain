SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveCategoriesForGroupScheme] @TenantId bigint,@GroupSchemeId bigint
AS


SELECT 1 AS Tag,
NULL AS Parent,
A.GroupSchemeCategoryId AS [GroupSchemeCategory!1!GroupSchemeCategoryId],
CASE ISNULL(A.IsDefault,0)
	WHEN 0 THEN A.CategoryName 
	WHEN 1 THEN A.CategoryName + ' (default)'
END AS [GroupSchemeCategory!1!CategoryName]

FROM PolicyManagement..TGroupSchemeCategory A


WHERE A.TenantId=@TenantId
AND A.GroupSchemeId=@GroupSchemeId
AND A.IsArchived=0

ORDER BY [GroupSchemeCategory!1!CategoryName]

FOR XML EXPLICIT

GO
