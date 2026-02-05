SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VwAccountKeyByEntityId]
AS
SELECT     EntityId, UserId, MAX(RightMask) AS RightMask, MAX(AdvancedMask) AS AdvancedMask
FROM         (SELECT EntityId, UserId, RightMask, AdvancedMask
                    FROM dbo.TAccountKey AS K WITH (NoLock)
					WHERE (EntityId IS NOT NULL) AND (UserId IS NOT NULL)
              UNION ALL
				SELECT K.EntityId, M.UserId, K.RightMask, K.AdvancedMask
                    FROM dbo.TAccountKey AS K WITH (NoLock) 
						INNER JOIN Administration.dbo.TMembership AS M WITH (NoLock) ON M.RoleId = K.RoleId
                    WHERE (K.EntityId IS NOT NULL) AND (K.RoleId IS NOT NULL)) AS Keys
GROUP BY UserId, EntityId
GO
