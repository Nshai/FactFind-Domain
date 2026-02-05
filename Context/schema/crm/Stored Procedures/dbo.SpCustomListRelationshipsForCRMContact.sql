SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomListRelationshipsForCRMContact]
@CRMContactId bigint

as


SELECT
1 as tag,
NULL as parent,
tr.CRMContactToId as [Relationship!1!CRMContactId],
isnull(tp.Title,'') + ' ' + isnull(tp.FirstName,'') + ' ' + isnull(tp.LastName,'') + ' (' + trrt.RelationshipTypeName + ')' as [Relationship!1!FullName]

FROM TRelationship tr
INNER JOIN TCRMContact tc ON tc.CRMContactId = tr.CRMContactToId
INNER JOIN TPerson tp ON tc.PersonId = tp.PersonId
INNER JOIN TRefRelationshipType trrt ON tr.RefRelTypeId = trrt.RefRelationshipTypeId
WHERE crmcontactfromid = @CRMContactId

FOR XML EXPLICIT
GO
