SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedFavourite]
AS
  SELECT 
    FavouriteId, 
    'AuditId' = MAX(AuditId)
  FROM TFavouriteAudit
  WHERE StampAction = 'D'
  GROUP BY FavouriteId


GO
