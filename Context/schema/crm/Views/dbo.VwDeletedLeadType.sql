SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[VwDeletedLeadType]
AS
  SELECT 
    LeadTypeId, 
    'AuditId' = MAX(AuditId)
  FROM TLeadTypeAudit
  WHERE StampAction = 'D'
  GROUP BY LeadTypeId

GO
