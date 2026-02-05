SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPolicyExpectedCommission]
	@StampUser varchar (255),
	@PolicyExpectedCommissionId bigint,
	@StampAction char(1)
AS

INSERT INTO TPolicyExpectedCommissionAudit 
( PolicyBusinessId, RefCommissionTypeId, RefPaymentDueTypeId, RefFrequencyId, 
		ChargingPeriodMonths, ExpectedAmount, ExpectedStartDate, ExpectedCommissionType, 
		ParentPolicyExpectedCommissionId, PercentageFund, Notes, ChangedByUser, 
		PreDiscountAmount, DiscountReasonId, ConcurrencyId, 
	PolicyExpectedCommissionId, ChargingType, ExpectedPercentage, DueDate, StampAction, StampDateTime, StampUser) 
Select PolicyBusinessId, RefCommissionTypeId, RefPaymentDueTypeId, RefFrequencyId, 
		ChargingPeriodMonths, ExpectedAmount, ExpectedStartDate, ExpectedCommissionType, 
		ParentPolicyExpectedCommissionId, PercentageFund, Notes, ChangedByUser, 
		PreDiscountAmount, DiscountReasonId, ConcurrencyId, 
	PolicyExpectedCommissionId, ChargingType, ExpectedPercentage, DueDate, @StampAction, GetDate(), @StampUser
FROM TPolicyExpectedCommission
WHERE PolicyExpectedCommissionId = @PolicyExpectedCommissionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
