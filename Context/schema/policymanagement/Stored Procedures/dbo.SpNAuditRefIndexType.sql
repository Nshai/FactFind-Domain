SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefIndexType]
	@StampUser varchar (255),
	@RefIndexTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefIndexTypeAudit
( IndexTypeName,  ConcurrencyId, RefIndexTypeId, StampAction, StampDateTime, StampUser) 
SELECT IndexTypeName, ConcurrencyId, RefIndexTypeId, @StampAction, GetDate(), @StampUser
FROM TRefIndexType
WHERE RefIndexTypeId = @RefIndexTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
