SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VwLeadKeyByEntityId]
AS
SELECT 
	EntityId,
	UserId, 
	MAX(RightMask) RightMask,
	MAX(AdvancedMask) AdvancedMask
FROM
	(	
	SELECT
		EntityId,
		UserId, 
		RightMask,
		AdvancedMask
	FROM 
		TLeadKey K
	WHERE
		K.EntityId IS NOT NULL
		AND K.UserId IS NOT NULL
	
	UNION ALL

	SELECT
		K.EntityId,
		M.UserId, 
		K.RightMask,
		K.AdvancedMask
	FROM 
		TLeadKey K
		JOIN Administration..TMembership M ON M.RoleId = K.RoleId
	WHERE
		K.EntityId IS NOT NULL
		AND K.RoleId IS NOT NULL
	) AS Keys
GROUP BY
	UserId, EntityId
GO
