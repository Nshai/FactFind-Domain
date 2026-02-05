SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VwAccountKeyByCreatorId]
AS
SELECT     CreatorId, UserId, MAX(RightMask) AS RightMask, MAX(AdvancedMask) AS AdvancedMask
FROM         dbo.TAccountKey AS K WITH (NoLock)
WHERE     (EntityId IS NULL)
GROUP BY CreatorId, UserId
GO
