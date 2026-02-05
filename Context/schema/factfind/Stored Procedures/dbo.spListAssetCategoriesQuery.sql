SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spListAssetCategoriesQuery] 
	@TenantId INT
AS

SELECT
    ac.AssetCategoryId,
	ac.CategoryName
FROM TAssetCategory ac
WHERE ac.IndigoClientId = @TenantId

GO