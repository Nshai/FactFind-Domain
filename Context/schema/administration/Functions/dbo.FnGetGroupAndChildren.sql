SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO  
CREATE FUNCTION [dbo].[FnGetGroupAndChildren](@GroupId bigint)
RETURNS TABLE
AS
RETURN
WITH GroupHierarchy(GroupId, [Level])
AS (
	-- Anchor definition, find the specified group
	SELECT
		GroupId, 1
	FROM
		TGroup
	WHERE
		GroupId = @GroupId

	-- Recursively find child groups
	UNION ALL
	SELECT
		Child.GroupId, A.[Level] + 1
	FROM
		GroupHierarchy A
		JOIN TGroup Child ON Child.ParentId = A.GroupId
	WHERE
		A.[Level] < 10 -- Just to make sure we don't get in an endless loop if there is bad data in the system.
)
SELECT GroupId
FROM GroupHierarchy
GO
