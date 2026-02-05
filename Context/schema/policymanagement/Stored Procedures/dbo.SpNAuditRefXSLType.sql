SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefXSLType]
	@StampUser varchar (255),
	@RefXSLTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefXSLTypeAudit 
( Identifier, IsArchived, ConcurrencyId, 
	RefXSLTypeId, StampAction, StampDateTime, StampUser) 
Select Identifier, IsArchived, ConcurrencyId, 
	RefXSLTypeId, @StampAction, GetDate(), @StampUser
FROM TRefXSLType
WHERE RefXSLTypeId = @RefXSLTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
