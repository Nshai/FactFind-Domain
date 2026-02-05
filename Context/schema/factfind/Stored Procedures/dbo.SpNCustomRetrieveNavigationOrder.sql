SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveNavigationOrder]
	@TenantId bigint
AS
SELECT XmlId, OrderNumber
FROM
	TNavigationOrder A
	JOIN TRefNavigationItem B ON B.RefNavigationItemId = A.RefNavigationItemId
WHERE
	A.TenantId = @TenantId		
		
GO
