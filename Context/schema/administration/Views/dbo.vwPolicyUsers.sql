/*
Based on user info in SpCustomApplyPolicyGetKeys.
Used to determine whcih users to process for spRebuildKeys
*/
CREATE VIEW dbo.vwPolicyUsers as 
WITH Policies as (
    SELECT 
	    RoleId, i.IndigoClientId
    FROM Administration..TPolicy P
    JOIN TIndigoClient i
    ON i.status ='active' AND i.IndigoClientId = p.IndigoClientId
    JOIN Administration..TRunning r on r.IndigoClientId = i.IndigoClientId AND r.RebuildKeys=0
    WHERE RightMask>0
    AND P.Applied = 'Yes'
), Creators as 
(
	SELECT DISTINCT
		U.UserId, R.RoleId, R.IndigoClientId
	FROM Administration..TRole R 
	JOIN Administration..TGrouping Gpg ON Gpg.GroupingId = R.GroupingId
	JOIN Administration..TGroup G ON G.GroupingId = Gpg.GroupingId
	LEFT JOIN Administration..TGroup G2 ON G2.ParentId = G.GroupId
	LEFT JOIN Administration..TGroup G3 ON G3.ParentId = G2.GroupId
	LEFT JOIN Administration..TGroup G4 ON G4.ParentId = G3.GroupId
	LEFT JOIN Administration..TGroup G5 ON G5.ParentId = G4.GroupId
	JOIN Administration..TUser U ON (U.GroupId = G.GroupId OR U.GroupId = G2.GroupId OR U.GroupId = G3.GroupId OR U.GroupId = G4.GroupId OR U.GroupId = G5.GroupId)
)

SELECT 
	Creators.UserId, 
    P.IndigoClientId,
    ct = count(1)
FROM	Creators
JOIN Policies P 
ON Creators.RoleId = P.RoleId
GROUP BY 
    P.IndigoClientId, Creators.UserId
GO
