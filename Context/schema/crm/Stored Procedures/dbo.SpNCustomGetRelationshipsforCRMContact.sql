SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpNCustomGetRelationshipsforCRMContact] 
@CRMContactId bigint
AS

BEGIN
  SELECT B.CRMContactId,CASE ISNULL(B.PersonId,0)
				WHEN 0 THEN B.CorporateName + ' (' + C.RelationshipTypeName + ')'
				ELSE B.FirstName + ' ' + B.LastName + ' (' + C.RelationshipTypeName + ')'
			END AS 'ContactName',A.RelationshipId,
	C.RelationshipTypeName 'RelationshipType',D.RelationshipTypeName 'CorrespondingRelationshipType'

    

    FROM TRelationship A
    JOIN TCRMContact B ON A.CRMContactToId=B.CRMContactId
    JOIN TRefRelationshipType C ON A.RefRelTypeId =C.RefRelationshipTypeId
    JOIN TRefRelationshipType D ON A.RefRelCorrespondTypeId=D.RefRelationshipTypeId

    WHERE A.CRMContactFromId=@CRMContactId




END
RETURN (0)
GO
