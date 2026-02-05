SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRepaymentVehicle]
	@StampUser varchar (255),
	@RepaymentVehicleId bigint,
	@StampAction char(1)
AS

INSERT INTO TRepaymentVehicleAudit 
( MortgageId, PolicyBusinessId, ConcurrencyId, 
	RepaymentVehicleId, StampAction, StampDateTime, StampUser) 
Select MortgageId, PolicyBusinessId, ConcurrencyId, 
	RepaymentVehicleId, @StampAction, GetDate(), @StampUser
FROM TRepaymentVehicle
WHERE RepaymentVehicleId = @RepaymentVehicleId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
