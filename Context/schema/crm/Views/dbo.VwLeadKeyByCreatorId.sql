SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VwLeadKeyByCreatorId]
AS
SELECT
	CreatorId,
	UserId,
	MAX(RightMask) RightMask,
	MAX(AdvancedMask) AdvancedMask
FROM
	TLeadKey K
WHERE
	K.EntityId IS NULL
GROUP BY
	CreatorId, UserId
GO
