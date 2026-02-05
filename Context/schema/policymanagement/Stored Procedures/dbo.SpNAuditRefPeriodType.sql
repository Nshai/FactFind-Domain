SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefPeriodType]
	@StampUser varchar (255),
	@RefPeriodTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefPeriodTypeAudit
( PeriodTypeName,  ConcurrencyId, RefPeriodTypeId, StampAction, StampDateTime, StampUser) 
SELECT PeriodTypeName, ConcurrencyId, RefPeriodTypeId, @StampAction, GetDate(), @StampUser
FROM TRefPeriodType
WHERE RefPeriodTypeId = @RefPeriodTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
