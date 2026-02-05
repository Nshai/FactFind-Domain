SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VwPolicyRights]
AS
	SELECT 
		E.Identifier AS Entity,
		U.UserId,
		MAX(P.RightMask) AS RightMask,
		MAX(P.AdvancedMask) AS AdvancedMask
	FROM
		TUser U
		JOIN TMembership M ON M.UserId = U.UserId
		JOIN TPolicy P ON P.RoleId = M.RoleId
		JOIN Administration..TEntity E ON E.EntityId = P.EntityId
	GROUP BY
		U.UserId, E.Identifier
GO
