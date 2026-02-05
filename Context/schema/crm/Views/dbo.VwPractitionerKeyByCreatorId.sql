SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  VIEW [dbo].[VwPractitionerKeyByCreatorId]
AS
SELECT 
	CreatorId,
	UserId, 
	MAX(RightMask) AS RightMask,
	MAX(AdvancedMask) AS AdvancedMask
FROM 
	TPractitionerKey
WHERE
	(RightMask > 0 Or AdvancedMask > 0)
	AND EntityId IS NULL
GROUP BY
	UserId, CreatorId

GO
