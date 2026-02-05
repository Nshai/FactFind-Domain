SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spCustomListActivityParentCategoriesForTasks] @IndigoClientId bigint
AS

SELECT 
	1 as tag,
	null as parent,
	A.ActivityCategoryParentId as [ActivityCategoryParent!1!ActivityCategoryParentId], 
	A.Name as [ActivityCategoryParent!1!Name]
FROM CRM..TActivityCategoryParent A
INNER JOIN CRM..TActivityCategory B ON A.ActivityCategoryParentId=B.ActivityCategoryParentId
WHERE B.ActivityEvent='Task' and A.IndigoClientId=@IndigoClientId AND B.GroupId IS NULL
GROUP BY A.ActivityCategoryParentId, A.Name

ORDER BY [ActivityCategoryParent!1!Name]

FOR XML EXPLICIT


GO
