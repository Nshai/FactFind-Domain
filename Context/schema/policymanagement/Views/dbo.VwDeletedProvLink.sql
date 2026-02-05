SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VwDeletedProvLink]
AS

	SELECT
		ProvLinkId,
		'AuditId' = MAX(AuditId)
	FROM TProvLinkAudit
	WHERE StampAction = 'D'
	GROUP BY ProvLinkId

GO
