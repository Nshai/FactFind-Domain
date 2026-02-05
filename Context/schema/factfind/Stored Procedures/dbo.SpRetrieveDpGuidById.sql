SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveDpGuidById]
	@DpGuidId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.DpGuidId AS [DpGuid!1!DpGuidId], 
	T1.EntityId AS [DpGuid!1!EntityId], 
	T1.DpGuidTypeId AS [DpGuid!1!DpGuidTypeId], 
	T1.Guid AS [DpGuid!1!Guid], 
	T1.ConcurrencyId AS [DpGuid!1!ConcurrencyId]
	FROM TDpGuid T1
	
	WHERE T1.DpGuidId = @DpGuidId
	ORDER BY [DpGuid!1!DpGuidId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
