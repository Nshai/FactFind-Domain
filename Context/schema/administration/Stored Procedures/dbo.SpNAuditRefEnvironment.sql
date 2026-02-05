SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefEnvironment]
	@StampUser varchar (255),
	@RefEnvironmentId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefEnvironmentAudit 
( URL, ConcurrencyId, 
	RefEnvironmentId, StampAction, StampDateTime, StampUser) 
Select URL, ConcurrencyId, 
	RefEnvironmentId, @StampAction, GetDate(), @StampUser
FROM TRefEnvironment
WHERE RefEnvironmentId = @RefEnvironmentId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
