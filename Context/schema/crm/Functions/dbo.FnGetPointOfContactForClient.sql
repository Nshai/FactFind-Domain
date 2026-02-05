SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION FnGetPointOfContactForClient
(
	@CrmContactId INT
)
RETURNS varchar(500)
AS
BEGIN
    Declare @ReturnValue varchar(500)
	
	Select TOP 1 @ReturnValue =  ISNULL(pc.FirstName,'') + ' ' + ISNULL(pc.LastName,'') + ' (' + ISNULL(reltype.RelationshipTypeName, '') + ')'
	From TRelationship rel 
	Left Join TRefRelationshipType relType on rel.RefRelTypeId = reltype.RefRelationshipTypeId
	Left Join TCRMContact pc on pc.CRMContactId = rel.CRMContactToId
	Where rel.CRMContactFromId = @CrmContactId
	and rel.IsPointOfContactFg = 1
	RETURN @ReturnValue

END
GO