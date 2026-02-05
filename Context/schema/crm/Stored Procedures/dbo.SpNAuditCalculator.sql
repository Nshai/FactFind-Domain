SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCalculator]
	@StampUser varchar (255),
	@CalculatorId bigint,
	@StampAction char(1)
AS

INSERT INTO TCalculatorAudit 
( Identifier, Definition, ConcurrencyId, 
	CalculatorId, StampAction, StampDateTime, StampUser) 
Select Identifier, Definition, ConcurrencyId, 
	CalculatorId, @StampAction, GetDate(), @StampUser
FROM TCalculator
WHERE CalculatorId = @CalculatorId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
