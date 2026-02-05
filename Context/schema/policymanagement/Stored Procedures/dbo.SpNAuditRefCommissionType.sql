SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefCommissionType]
	@StampUser varchar (255),
	@RefCommissionTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefCommissionTypeAudit 
( CommissionTypeName, OrigoRef, InitialCommissionFg, RecurringCommissionFg, 
		RetireFg, ConcurrencyId, 
	RefCommissionTypeId, StampAction, StampDateTime, StampUser) 
Select CommissionTypeName, OrigoRef, InitialCommissionFg, RecurringCommissionFg, 
		RetireFg, ConcurrencyId, 
	RefCommissionTypeId, @StampAction, GetDate(), @StampUser
FROM TRefCommissionType
WHERE RefCommissionTypeId = @RefCommissionTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
