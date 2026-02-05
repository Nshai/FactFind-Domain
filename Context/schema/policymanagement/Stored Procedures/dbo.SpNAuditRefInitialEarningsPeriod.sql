SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefInitialEarningsPeriod]
	@StampUser varchar (255),
	@RefInitialEarningsPeriodId int,
	@StampAction char(1)
AS
INSERT INTO TRefInitialEarningsPeriodAudit
	 ( InitialEarningsPeriod, ConcurrencyId, RefInitialEarningsPeriodId, StampAction, StampDateTime, StampUser) 
SELECT InitialEarningsPeriod, ConcurrencyId, RefInitialEarningsPeriodId, @StampAction, GetDate(), @StampUser
FROM TRefInitialEarningsPeriod
WHERE RefInitialEarningsPeriodId = @RefInitialEarningsPeriodId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
