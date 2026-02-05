SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
Displays parent groups in relation to requested group (RequestedGroupId)
The higher Parent group in hierarchy, the higher number in ParentLevel
*/
CREATE VIEW [dbo].[VwGroupHierarchyParents] 
AS

WITH GroupHierarchyParents (RequestedGroup, GroupId, ParentId, HierarchyLevel) AS
    (
		SELECT grp.GroupId as RequestedGroup, grp.GroupId, grp.ParentId, 0 AS HierarchyLevel
		FROM TGroup AS grp	
		UNION ALL
		SELECT d.RequestedGroup, grp.GroupId, grp.ParentId, d.HierarchyLevel + 1 AS HierarchyLevel
		FROM TGroup AS grp 
		INNER JOIN GroupHierarchyParents AS d ON grp.GroupId = d.ParentId
)

SELECT 
	g.GroupId as RequestedGroupId,
	parents.GroupId AS ParentGroupId,
	parents.HierarchyLevel AS ParentLevel,
	g.IndigoClientId
FROM TGroup g
JOIN GroupHierarchyParents parents ON parents.RequestedGroup = g.GroupId AND parents.GroupId != g.GroupId