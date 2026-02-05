SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefRiskEventType]
	@StampUser varchar (255),
	@RefRiskEventTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefRiskEventTypeAudit 
( RiskEventTypeName, OrigoRef, ContactAssuredFg, RetireFg, 
		ConcurrencyId, 
	RefRiskEventTypeId, StampAction, StampDateTime, StampUser) 
Select RiskEventTypeName, OrigoRef, ContactAssuredFg, RetireFg, 
		ConcurrencyId, 
	RefRiskEventTypeId, @StampAction, GetDate(), @StampUser
FROM TRefRiskEventType
WHERE RefRiskEventTypeId = @RefRiskEventTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
