SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefTermType]
	@StampUser varchar (255),
	@RefTermTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefTermTypeAudit
( TermTypeName,  ConcurrencyId, RefTermTypeId, StampAction, StampDateTime, StampUser) 
SELECT TermTypeName, ConcurrencyId, RefTermTypeId, @StampAction, GetDate(), @StampUser
FROM TRefTermType
WHERE RefTermTypeId = @RefTermTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
