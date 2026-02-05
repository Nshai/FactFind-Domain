SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditDefaultPercentage]
	@StampUser varchar (255),
	@DefaultPercentageId bigint,
	@StampAction char(1)
AS

INSERT INTO TDefaultPercentageAudit 
( IndigoClientId, Percentage, GroupingId, PaymentEntityId, 
		ConcurrencyId, 
	DefaultPercentageId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, Percentage, GroupingId, PaymentEntityId, 
		ConcurrencyId, 
	DefaultPercentageId, @StampAction, GetDate(), @StampUser
FROM TDefaultPercentage
WHERE DefaultPercentageId = @DefaultPercentageId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
