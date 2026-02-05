SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedXmlSendDet]
AS
  SELECT 
    XmlSendDetId, 
    'AuditId' = MAX(AuditId)
  FROM TXmlSendDetAudit
  WHERE StampAction = 'D'
  GROUP BY XmlSendDetId


GO
