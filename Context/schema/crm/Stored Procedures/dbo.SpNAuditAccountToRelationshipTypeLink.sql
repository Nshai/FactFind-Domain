SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAccountToRelationshipTypeLink]
	@StampUser varchar (255),
	@AccountToRelationshipTypeLinkId bigint,
	@StampAction char(1)
AS

INSERT INTO TAccountToRelationshipTypeLinkAudit 
( RefRelationshipTypeId, AccountTypeId, ConcurrencyId, 
	AccountToRelationshipTypeLinkId, StampAction, StampDateTime, StampUser) 
Select RefRelationshipTypeId, AccountTypeId, ConcurrencyId, 
	AccountToRelationshipTypeLinkId, @StampAction, GetDate(), @StampUser
FROM TAccountToRelationshipTypeLink
WHERE AccountToRelationshipTypeLinkId = @AccountToRelationshipTypeLinkId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
