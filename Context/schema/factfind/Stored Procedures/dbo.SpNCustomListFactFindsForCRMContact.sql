SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomListFactFindsForCRMContact]  
 @CRMContactId bigint,
 @IndigoClientId bigint


AS  
BEGIN  
  
Select a.FactFindId,d.StampDateTime 'CreatedDate',a.FactFindTypeId,a.CRMContactId1 'CRMContactId1',
b.FirstName + ' ' + b.LastName 'Client1',a.CRMContactId2 'CRMContactId2',
 CASE ISNULL(a.CRMContactId2,0)
	WHEN 0 THEN ''
	ELSE ISNULL(c.FirstName,'') + ' ' + ISNULL(c.Lastname,'')
 END AS 'Client2'
FROM FactFind..TFactFind a
JOIN TFactFindAudit d on a.FactFindId=d.FactFindId AND d.StampAction='C'
JOIN CRM..TCRMContact b on a.CRMContactId1=b.CRMContactId
LEFT JOIN CRM..TCRMContact c on a.CRMContactId2=c.CRMContactId

WHERE a.IndigoClientId=@IndigoClientId
AND (a.crmcontactid1=@crmcontactid or a.crmcontactid2=@crmcontactid)
AND b.IndClientId=@IndigoClientId


END
GO
