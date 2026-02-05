SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spCustomListActivityCategoriesForTasks] @IndigoClientId bigint
AS

SELECT 
	1 as tag,
	null as parent,
	A.ActivityCategoryId as [ActivityCategory!1!ActivityCategoryId], 
	A.Name as [ActivityCategory!1!Name]
FROM CRM..TActivityCategory A
WHERE A.ActivityEvent='Task' and A.IndigoClientId=@IndigoClientId AND A.GroupId IS NULL
ORDER BY [ActivityCategory!1!Name]

FOR XML EXPLICIT

GO
