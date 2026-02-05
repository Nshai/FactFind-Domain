SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditPolicyMoneyOut]
	@StampUser varchar (255),
	@PolicyMoneyOutId bigint,
	@StampAction char(1)
AS

INSERT INTO TPolicyMoneyOutAudit   
	( PolicyOwnerId, PolicyBusinessId, BeneficiaryCRMContactId, BeneficiaryPercentage,    
	 Amount, RefBenefitPaymentTypeId, SalaryMultiple, RefRiskEventTypeId,     
	 PaymentStartDate, PaymentStopDate, RefFrequencyId, RefIndexationTypeId,     
	 EscalationPercentage, AssuredCRMContactId1, AssuredCRMContactId2, DeferredWeeks,     
	 AssignedCRMContactId, RefPaymentBasisTypeId, PaymentBasisPercentage, GuaranteedPeriodMonths,     
	 RefWithdrawalBasisTypeId, RefWithdrawalTypeId, RefEscalationTypeId, ConcurrencyId,     
	 TransferToPolicyMoneyInId, SpousesOrDependentsPercentage, IsOverlap, IsWithProportion,     
	 RefPaymentBasisId, GuaranteedPeriod, IsCreatedBySystem, [WithdrawalMigrationRef],
	 PolicyMoneyOutId, StampAction, StampDateTime, StampUser, Note, RefTransferTypeId, 
	 IsFullTransfer, RefArrangementTypeId, RefWithdrawalSubTypeId, TaxableValue, TaxFreeValue)   
Select 
	PolicyOwnerId, PolicyBusinessId, BeneficiaryCRMContactId, BeneficiaryPercentage,     
	Amount, RefBenefitPaymentTypeId, SalaryMultiple, RefRiskEventTypeId,     
	PaymentStartDate, PaymentStopDate, RefFrequencyId, RefIndexationTypeId,     
	EscalationPercentage, AssuredCRMContactId1, AssuredCRMContactId2, DeferredWeeks,     
	AssignedCRMContactId, RefPaymentBasisTypeId, PaymentBasisPercentage, GuaranteedPeriodMonths,     
	RefWithdrawalBasisTypeId, RefWithdrawalTypeId, RefEscalationTypeId, ConcurrencyId,     
	TransferToPolicyMoneyInId, SpousesOrDependentsPercentage, IsOverlap, IsWithProportion,     
	RefPaymentBasisId, GuaranteedPeriod, IsCreatedBySystem, [WithdrawalMigrationRef],
	PolicyMoneyOutId, @StampAction, GetDate(), @StampUser, Note, RefTransferTypeId, IsFullTransfer,
	RefArrangementTypeId, RefWithdrawalSubTypeId, TaxableValue, TaxFreeValue
FROM TPolicyMoneyOut  
WHERE PolicyMoneyOutId = @PolicyMoneyOutId    

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO

