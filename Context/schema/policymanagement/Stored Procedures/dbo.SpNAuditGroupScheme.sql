SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditGroupScheme]
	@StampUser varchar (255),
	@GroupSchemeId bigint,
	@StampAction char(1)
AS

INSERT INTO TGroupSchemeAudit 
( TenantId, PolicyBusinessId, OwnerCRMContactId, SchemeTypeId, 
		SchemeNumber, SchemeName, RenewalDate, PaymentMethod, 
		ExpectedPaymentDate, ContributionAmount, AnnualMgmtCharge, TermsAgreedDate, 
		EventListid, PremiumFrequency, SchemeCommissionRate, SchemeCommissionTypeId, 
		IsCalculateCommissionDue, ConcurrencyId, 
	GroupSchemeId, StampAction, StampDateTime, StampUser, NonActiveMemberAmcPercentage, DefaultFund, RefSalaryExchangeTypeId, SEEmployerReviewDate,
	StagingDate,TriAnnualDate,CertificateExpiryDate,PayrollCutOffDay,PostponementInformation,DefaultFundUnitId,DefaultNonFeedFundId,
	PensionSchemeTaxReference, LumpSumAnnualMgmtCharge, TransferAnnualMgmtCharge,
	RefRegisteredId, IsCopyOfTrustHeld, IsPrincipalEmployerATrustee ) 
Select TenantId, PolicyBusinessId, OwnerCRMContactId, SchemeTypeId, 
		SchemeNumber, SchemeName, RenewalDate, PaymentMethod, 
		ExpectedPaymentDate, ContributionAmount, AnnualMgmtCharge, TermsAgreedDate, 
		EventListid, PremiumFrequency, SchemeCommissionRate, SchemeCommissionTypeId, 
		IsCalculateCommissionDue, ConcurrencyId, 
	GroupSchemeId, @StampAction, GetDate(), @StampUser, NonActiveMemberAmcPercentage, DefaultFund, RefSalaryExchangeTypeId, SEEmployerReviewDate,
	StagingDate,TriAnnualDate,CertificateExpiryDate,PayrollCutOffDay,PostponementInformation,DefaultFundUnitId,DefaultNonFeedFundId,
	PensionSchemeTaxReference, LumpSumAnnualMgmtCharge, TransferAnnualMgmtCharge,
	RefRegisteredId, IsCopyOfTrustHeld, IsPrincipalEmployerATrustee
FROM TGroupScheme
WHERE GroupSchemeId = @GroupSchemeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO




