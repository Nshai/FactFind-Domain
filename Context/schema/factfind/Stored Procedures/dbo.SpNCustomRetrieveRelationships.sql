SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveRelationships]
	@CRMContactId bigint
AS
SELECT DISTINCT 
	R.CRMContactToId AS CRMContactId,
	C.FirstName + ' ' + C.LastName AS ClientName,
	C.DOB,
	B.RelationshipTypeName AS Relationship
FROM 
	CRM..TRelationship R
	JOIN CRM..TCRMContact C ON C.CrmContactId = R.CrmContactToId
	JOIN CRM..TRefRelationshipType B ON B.RefRelationshipTypeId = R.RefRelTypeId
WHERE 
	R.CRMContactFromId = @CRMContactId 
	AND R.CrmContactToId != @CRMContactId 
	AND C.CRMContactType = 1 -- Must be a person
	AND ISNULL(C.ArchiveFg, 0) = 0 
	AND C.RefCRMContactStatusId = 1 -- Needs to be a client.
GO
