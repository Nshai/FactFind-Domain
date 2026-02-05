SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefFrequency]
	@StampUser varchar (255),
	@RefFrequencyId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefFrequencyAudit 
( FrequencyName, OrigoRef, RetireFg, OrderNo, 
		ConcurrencyId, 
	RefFrequencyId, StampAction, StampDateTime, StampUser) 
Select FrequencyName, OrigoRef, RetireFg, OrderNo, 
		ConcurrencyId, 
	RefFrequencyId, @StampAction, GetDate(), @StampUser
FROM TRefFrequency
WHERE RefFrequencyId = @RefFrequencyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
