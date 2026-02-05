SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefRelationshipType]
	@StampUser varchar (255),
	@RefRelationshipTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefRelationshipTypeAudit 
( RelationshipTypeName, ArchiveFg, PersonFg, CorporateFg, 
		TrustFg, AccountFg, ConcurrencyId, 
	RefRelationshipTypeId, StampAction, StampDateTime, StampUser) 
Select RelationshipTypeName, ArchiveFg, PersonFg, CorporateFg, 
		TrustFg, AccountFg, ConcurrencyId, 
	RefRelationshipTypeId, @StampAction, GetDate(), @StampUser
FROM TRefRelationshipType
WHERE RefRelationshipTypeId = @RefRelationshipTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
