SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedRecommendation]
AS
  SELECT 
    RecommendationId, 
    'AuditId' = MAX(AuditId)
  FROM TRecommendationAudit
  WHERE StampAction = 'D'
  GROUP BY RecommendationId


GO
