SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefAccType]
	@StampUser varchar (255),
	@RefAccTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefAccTypeAudit 
( IndClientId, Name, Description, ActiveFG, 
		ConcurrencyId, 
	RefAccTypeId, StampAction, StampDateTime, StampUser) 
Select IndClientId, Name, Description, ActiveFG, 
		ConcurrencyId, 
	RefAccTypeId, @StampAction, GetDate(), @StampUser
FROM TRefAccType
WHERE RefAccTypeId = @RefAccTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
