SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefFactFindCategoryPlanTypeById]
	@RefFactFindCategoryPlanTypeId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.RefFactFindCategoryPlanTypeId AS [RefFactFindCategoryPlanType!1!RefFactFindCategoryPlanTypeId], 
	ISNULL(T1.Category, '') AS [RefFactFindCategoryPlanType!1!Category], 
	ISNULL(T1.RefFactFindCategoryId, '') AS [RefFactFindCategoryPlanType!1!RefFactFindCategoryId], 
	ISNULL(T1.RefPlanTypeId, '') AS [RefFactFindCategoryPlanType!1!RefPlanTypeId], 
	T1.ConcurrencyId AS [RefFactFindCategoryPlanType!1!ConcurrencyId]
	FROM TRefFactFindCategoryPlanType T1
	
	WHERE T1.RefFactFindCategoryPlanTypeId = @RefFactFindCategoryPlanTypeId
	ORDER BY [RefFactFindCategoryPlanType!1!RefFactFindCategoryPlanTypeId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
