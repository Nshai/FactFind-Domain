SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefUserType]
	@StampUser varchar (255),
	@RefUserTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefUserTypeAudit 
( Identifier, Url, ConcurrencyId, 
	RefUserTypeId, StampAction, StampDateTime, StampUser) 
Select Identifier, Url, ConcurrencyId, 
	RefUserTypeId, @StampAction, GetDate(), @StampUser
FROM TRefUserType
WHERE RefUserTypeId = @RefUserTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
