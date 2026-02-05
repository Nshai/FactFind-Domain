SET QUOTED_IDENTIFIER OFF
GO

SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditFeeModelTemplate] @StampUser VARCHAR(255),
	@FeeModelTemplateId BIGINT,
	@StampAction CHAR(1)
AS
	INSERT INTO 
		TFeeModelTemplateAudit 
		(FeeModelId,
		AdviseFeeTypeId,
		AdviseFeeChargingDetailsId,
		FeeAmount,
		IsDefault,
		VATAmount,
		IsVATExcempt,
		RefVATId,
		InitialPeriod,
		IsInstalments,
		IsPaidByProvider,
		RecurringFrequencyId,
		InstalmentsFrequencyId,
		NumRecurringPayments,
		RefAdviceContributionTypeId,
		StartDate,
		EndDate,
		TenantId,
		ConcurrencyId,
		FeeModelTemplateId,
		RefFeeAdviseTypeId,
		FeePercentage,
		StampAction,
		StampDateTime,
		StampUser,
		IsConsultancyFee,
		ServiceStatusId,
		IsRetainer,
		FeeCode)
	SELECT 
		FeeModelId,
		AdviseFeeTypeId,
		AdviseFeeChargingDetailsId,
		FeeAmount,
		IsDefault,
		VATAmount,
		IsVATExcempt,
		RefVATId,
		InitialPeriod,
		IsInstalments,
		IsPaidByProvider,
		RecurringFrequencyId,
		InstalmentsFrequencyId,
		NumRecurringPayments,
		RefAdviceContributionTypeId,
		StartDate,
		EndDate,
		TenantId,
		ConcurrencyId,
		FeeModelTemplateId,
		RefFeeAdviseTypeId,
		FeePercentage,
		@StampAction,
		GetDate(),
		@StampUser,
		IsConsultancyFee,
		ServiceStatusId,
		IsRetainer,
		FeeCode
	FROM 
		TFeeModelTemplate
	WHERE 
		FeeModelTemplateId = @FeeModelTemplateId

IF @@ERROR != 0
	GOTO errh

RETURN (0)

errh:

RETURN (100)
GO