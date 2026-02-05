SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFee2Policy]
	@StampUser varchar (255),
	@Fee2PolicyId bigint,
	@StampAction char(1)
AS

INSERT INTO TFee2PolicyAudit 
( FeeId, PolicyBusinessId, RebateCommission, ConcurrencyId, 
		
	Fee2PolicyId, StampAction, StampDateTime, StampUser) 
Select FeeId, PolicyBusinessId, RebateCommission, ConcurrencyId, 
		
	Fee2PolicyId, @StampAction, GetDate(), @StampUser
FROM TFee2Policy
WHERE Fee2PolicyId = @Fee2PolicyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
