SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveLifeAssuredClientsForXML]
	@CRMContactId bigint
AS
-- Return client
SELECT
	CRMContactId AS [CRMContactId],
	ISNULL(CorporateName, FirstName + ' ' + LastName) AS ClientName	
FROM
	CRM..TCRMContact
WHERE
	CRMContactId = @CRMContactId
		
-- Get a list of relationships for this CRMContact which are to
-- another person contact, not another corporate contact
UNION ALL 
SELECT DISTINCT 
	A.CRMContactToId AS [CRMContactId] ,
	B.FirstName + ' ' + B.LastName AS [ClientName]
FROM 
	CRM..TRelationship A
	JOIN CRM..TCRMContact B ON B.CrmContactId = A.CrmContactToId
WHERE 
	A.CRMContactFromId = @CrmContactId 
	And A.CrmContactToId <> @CrmContactId 
	And B.CRMContactType = 1
ORDER BY ClientName
For XML RAW('LifeAssured')
GO
