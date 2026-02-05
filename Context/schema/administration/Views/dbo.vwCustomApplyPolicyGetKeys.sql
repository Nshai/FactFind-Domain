/*
Based on and replaces spCustomApplyPolicyGetKey
*/
CREATE VIEW dbo.vwCustomApplyPolicyGetKeys AS 
WITH Policies as (
    SELECT 
	    PolicyId, RoleId, RightMask, AdvancedMask, P.EntityId, P.IndigoClientId --, [Table] = E.Db + '..T' + E.Identifier
    FROM Administration..TPolicy P
    JOIN Administration..TEntity E ON P.EntityId = E.EntityId
    JOIN TIndigoClient i
    ON i.status ='active' AND i.IndigoClientId = p.IndigoClientId
    JOIN Administration..TRunning r on r.IndigoClientId = i.IndigoClientId AND r.RebuildKeys=0
    WHERE RightMask>0
    AND P.Applied = 'Yes'
    AND P.Propogate = 1
), Managers as (
    SELECT DISTINCT -- This needs to be distinct as the membership table sometimes contains duplicates
		U.UserId, U.GroupId, M.RoleId
	FROM TMembership M 		
	JOIN Administration..TRole R ON R.RoleId = M.RoleId --AND R.RoleId = @RoleId
	JOIN Administration..TUser U ON U.UserId = M.UserId
    JOIN TIndigoClient i ON i.status ='active' AND i.IndigoClientId = r.IndigoClientId
    JOIN Administration..TRunning n on n.IndigoClientId = i.IndigoClientId AND n.RebuildKeys=0
	WHERE
		U.Status NOT LIKE 'Access Denied%'
	AND U.SuperUser = 0 AND U.SuperViewer = 0
), Creators as 
(
	SELECT DISTINCT
		U.UserId, G.GroupId, R.RoleId
	FROM Administration..TRole R 
	JOIN Administration..TGrouping Gpg ON Gpg.GroupingId = R.GroupingId
	JOIN Administration..TGroup G ON G.GroupingId = Gpg.GroupingId
	LEFT JOIN Administration..TGroup G2 ON G2.ParentId = G.GroupId
	LEFT JOIN Administration..TGroup G3 ON G3.ParentId = G2.GroupId
	LEFT JOIN Administration..TGroup G4 ON G4.ParentId = G3.GroupId
	LEFT JOIN Administration..TGroup G5 ON G5.ParentId = G4.GroupId
	JOIN Administration..TUser U ON (U.GroupId = G.GroupId OR U.GroupId = G2.GroupId OR U.GroupId = G3.GroupId OR U.GroupId = G4.GroupId OR U.GroupId = G5.GroupId)
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
FROM
	-- Which users belong to this policy's role (these users are likely to by managers)
	 Managers
	-- Which Users can the managers see? We need to work down the organisational hierarchy to work this out
JOIN    Creators 
ON  Creators.GroupId = Managers.GroupId
AND Creators.RoleId  = Managers.RoleId
JOIN Policies P 
ON Creators.RoleId = P.RoleId

GO
