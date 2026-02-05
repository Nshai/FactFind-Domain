SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefLifeCover]
	@StampUser varchar (255),
	@RefLifeCoverId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefLifeCoverAudit 
( RefLifeCover, RetireFg, ConcurrencyId, 
	RefLifeCoverId, StampAction, StampDateTime, StampUser) 
Select RefLifeCover, RetireFg, ConcurrencyId, 
	RefLifeCoverId, @StampAction, GetDate(), @StampUser
FROM TRefLifeCover
WHERE RefLifeCoverId = @RefLifeCoverId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
