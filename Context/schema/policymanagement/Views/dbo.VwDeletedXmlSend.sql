SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedXmlSend]
AS
  SELECT 
    XmlSendId, 
    'AuditId' = MAX(AuditId)
  FROM TXmlSendAudit
  WHERE StampAction = 'D'
  GROUP BY XmlSendId


GO
