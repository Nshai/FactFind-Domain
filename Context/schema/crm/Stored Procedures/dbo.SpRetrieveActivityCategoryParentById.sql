SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveActivityCategoryParentById]  @ActivityCategoryParentId bigint  AS    BEGIN    SELECT      1 AS Tag,      NULL AS Parent,      T1.ActivityCategoryParentId AS [ActivityCategoryParent!1!ActivityCategoryParentId],       T1.Name AS [ActivityCategoryParent!1!Name],       T1.IndigoClientId AS [ActivityCategoryParent!1!IndigoClientId],       T1.ConcurrencyId AS [ActivityCategoryParent!1!ConcurrencyId]    FROM TActivityCategoryParent T1      WHERE (T1.ActivityCategoryParentId = @ActivityCategoryParentId)      ORDER BY [ActivityCategoryParent!1!ActivityCategoryParentId]      FOR XML EXPLICIT    END  RETURN (0)    
GO
