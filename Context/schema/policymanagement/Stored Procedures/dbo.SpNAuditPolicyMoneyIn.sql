SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPolicyMoneyIn]
	@StampUser varchar (255),
	@PolicyMoneyInId bigint,
	@StampAction char(1)
AS

INSERT INTO TPolicyMoneyInAudit
	( Amount, EscalationPercentage, RefFrequencyId, StartDate,
	PolicyBusinessId, RefTaxBasisId, RefTaxYearId, RefContributionTypeId,
	RefContributorTypeId, CurrentFg, RefEscalationTypeId, SalaryPercentage,
	StopDate, ConcurrencyId, IsInitialFee, IsOngoingFee,
	IsCreatedBySystem, [ContributionMigrationRef],
	PolicyMoneyInId, StampAction, StampDateTime, StampUser, Note, EmploymentId,
	IsFullTransfer, RefTransferTypeId, HasSafeguardedBenefit)
SELECT
	Amount, EscalationPercentage, RefFrequencyId, StartDate,
	PolicyBusinessId, RefTaxBasisId, RefTaxYearId, RefContributionTypeId,
	RefContributorTypeId, CurrentFg, RefEscalationTypeId, SalaryPercentage,
	StopDate, ConcurrencyId, IsInitialFee, IsOngoingFee,
	IsCreatedBySystem, [ContributionMigrationRef],
	PolicyMoneyInId, @StampAction, GetDate(), @StampUser, Note, EmploymentId,
	IsFullTransfer, RefTransferTypeId, HasSafeguardedBenefit
FROM TPolicyMoneyIn
WHERE PolicyMoneyInId = @PolicyMoneyInId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO

