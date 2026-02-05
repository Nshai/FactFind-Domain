SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedIntroducer]
AS
  SELECT 
    IntroducerId, 
    'AuditId' = MAX(AuditId)
  FROM TIntroducerAudit
  WHERE StampAction = 'D'
  GROUP BY IntroducerId


GO
