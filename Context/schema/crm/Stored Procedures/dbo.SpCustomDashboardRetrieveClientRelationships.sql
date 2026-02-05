SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date        Modifier            Issue           Description
----        ---------           -------         -------------
20231006    Swapnil Suryavanshi	SE-2420         Relationships widget in Dashboard to display 10 records
*/

CREATE PROCEDURE [dbo].[SpCustomDashboardRetrieveClientRelationships]  
@UserId int,  
@cid int  
  
as  

	SELECT 
		TOP 10  
		ISNULL(C.CorporateName,'') + ISNULL(C.FirstName,'') + ' ' + ISNULL(C.LastName,'') AS [RelatedCustomerName],  
		(CASE WHEN CorporateName IS NULL
			THEN SUBSTRING(ISNULL(FirstName, ''),1,1) + SUBSTRING(ISNULL(LastName, ''),1,1)
		END) as ClientInitials,  
		RRT.RelationshipTypeName AS [RelationshipType],  
		C.CRMContactId as [RelatedCustomerCRMContactId],
		C.RefCRMContactStatusId AS CustomerType
	FROM 
		TRelationship R  
		INNER JOIN TCRMContact C ON c.CRMContactId = r.CRMContactToId  
		INNER JOIN TRefRelationshipType RRT ON RRT.RefRelationshipTypeId = R.RefRelTypeId
		INNER JOIN TRelationship relationTo ON r.CRMContactToId = relationTo.CRMContactFromId
                AND r.CRMContactFromId = relationTo.CRMContactToId
                AND RRT.RefRelationshipTypeId = relationTo.RefRelCorrespondTypeId      
	WHERE 
		R.CRMContactFromId = @cid  
		AND C.ArchiveFg = 0
	ORDER BY R.IsPointOfContactFg DESC

