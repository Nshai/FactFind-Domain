SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefRelationshipTypeLink]
	@StampUser varchar (255),
	@RefRelationshipTypeLinkId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefRelationshipTypeLinkAudit 
( RefRelTypeId, RefRelCorrespondTypeId, ConcurrencyId, 
	RefRelationshipTypeLinkId, StampAction, StampDateTime, StampUser) 
Select RefRelTypeId, RefRelCorrespondTypeId, ConcurrencyId, 
	RefRelationshipTypeLinkId, @StampAction, GetDate(), @StampUser
FROM TRefRelationshipTypeLink
WHERE RefRelationshipTypeLinkId = @RefRelationshipTypeLinkId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
