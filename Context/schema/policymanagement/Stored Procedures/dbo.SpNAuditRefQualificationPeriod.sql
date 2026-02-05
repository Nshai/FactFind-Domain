SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefQualificationPeriod]
	@StampUser varchar (255),
	@RefQualificationPeriodId int,
	@StampAction char(1)
AS
INSERT INTO TRefQualificationPeriodAudit
( QualificationPeriod,  ConcurrencyId, RefQualificationPeriodId, StampAction, StampDateTime, StampUser) 
SELECT QualificationPeriod, ConcurrencyId, RefQualificationPeriodId, @StampAction, GetDate(), @StampUser
FROM TRefQualificationPeriod
WHERE RefQualificationPeriodId = @RefQualificationPeriodId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
