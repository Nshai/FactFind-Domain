SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNGetLastUpdatedFactFindForCRMContact]    
 @CRMContactId bigint,  
 @IndigoClientId bigint    
  
AS    
BEGIN    
    
SELECT TOP 1 a.FactFindId
	,d.StampDateTime 'ModifiedDate'
	,a.FactFindTypeId
	,a.CRMContactId1 'CRMContactId1'
	,b.FirstName + ' ' + b.LastName 'Client1'
	,a.CRMContactId2 'CRMContactId2'
	,CASE ISNULL(a.CRMContactId2, 0)
		WHEN 0
			THEN ''
		ELSE ISNULL(c.FirstName, '') + ' ' + ISNULL(c.Lastname, '')
		END AS 'Client2'
FROM FactFind..TFactFind a
JOIN TFactFindAudit d ON a.FactFindId = d.FactFindId	
JOIN CRM..TCRMContact b ON a.CRMContactId1 = b.CRMContactId
LEFT JOIN CRM..TCRMContact c ON a.CRMContactId2 = c.CRMContactId
WHERE a.IndigoClientId = @IndigoClientId
	AND (
		a.crmcontactid1 = @crmcontactid
		OR a.crmcontactid2 = @crmcontactid
		)
	AND b.IndClientId = @IndigoClientId
ORDER BY d.StampDateTime DESC
  
END
GO
