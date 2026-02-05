SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefEmailAssociationType]
	@StampUser varchar (255),
	@RefEmailAssociationTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefEmailAssociationTypeAudit 
( AssociationTypeName, ConcurrencyId, 
	RefEmailAssociationTypeId, StampAction, StampDateTime, StampUser) 
Select AssociationTypeName, ConcurrencyId, 
	RefEmailAssociationTypeId, @StampAction, GetDate(), @StampUser
FROM TRefEmailAssociationType
WHERE RefEmailAssociationTypeId = @RefEmailAssociationTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
