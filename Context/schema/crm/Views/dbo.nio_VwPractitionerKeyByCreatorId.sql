SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[nio_VwPractitionerKeyByCreatorId]
AS


SELECT
	CreatorId,
	UserId,
	MAX(RightMask) RightMask,
	MAX(AdvancedMask) AdvancedMask
FROM TPractitionerKey K With(NoLock)
WHERE K.EntityId IS NULL
GROUP BY CreatorId, UserId
GO
