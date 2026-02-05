SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedCreditNote]
AS
  SELECT 
    CreditNoteId, 
    'AuditId' = MAX(AuditId)
  FROM TCreditNoteAudit
  WHERE StampAction = 'D'
  GROUP BY CreditNoteId


GO
