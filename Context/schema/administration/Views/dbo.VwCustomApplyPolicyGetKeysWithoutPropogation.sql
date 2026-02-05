/*
Based on and replaces spCustomApplyPolicyGetKeysWithoutPropogation
*/
CREATE VIEW dbo.VwCustomApplyPolicyGetKeysWithoutPropogation AS
WITH Policies as (
    SELECT 
	    PolicyId, RoleId, RightMask, AdvancedMask, P.EntityId, P.IndigoClientId --, [Table] = E.Db + '..T' + E.Identifier
    FROM Administration..TPolicy P
    JOIN Administration..TEntity E ON P.EntityId = E.EntityId
    WHERE RightMask>0
    AND P.Applied = 'Yes'
    AND P.Propogate = 0
), Managers as (
    SELECT DISTINCT -- This needs to be distinct as the membership table sometimes contains duplicates
		U.UserId, U.GroupId, M.RoleId
	FROM TMembership M 		
	JOIN Administration..TRole R ON R.RoleId = M.RoleId
	JOIN Administration..TUser U ON U.UserId = M.UserId
    JOIN Administration..TIndigoClient i ON i.IndigoClientId = r.IndigoClientId AND i.Status = 'Active'
    JOIN Administration..TRunning n on n.IndigoClientId = i.IndigoClientId AND n.RebuildKeys=0
	WHERE
		U.Status NOT LIKE 'Access Denied%'
	AND U.SuperUser = 0 AND U.SuperViewer = 0
)

SELECT distinct
	Creators.UserId AS CreatorId, 
	Managers.UserId AS UserId, 
	P.RightMask, 
	P.AdvancedMask, 
	P.RoleId,
    P.EntityId,
    P.PolicyId,
    P.IndigoClientId
    --,P.[Table]
FROM
	-- Which users belong to this policy's role (these users are likely to by managers)
	 Managers
	-- Which Users can the managers see? We need to work down the organisational hierarchy to work this out
JOIN   Administration.dbo.TUser Creators 
ON  Creators.GroupId = Managers.GroupId
JOIN Policies P 
ON Managers.RoleId = P.RoleId
GO
