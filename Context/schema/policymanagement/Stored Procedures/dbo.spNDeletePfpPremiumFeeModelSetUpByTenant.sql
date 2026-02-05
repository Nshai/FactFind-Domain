-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Teodora Pilitis
-- Create date: 02 March 2015
-- Description:	Deletes PFP Premium Fee model set up for a tenant
-- =============================================
CREATE PROCEDURE [dbo].[spNDeletePfpPremiumFeeModelSetUpByTenant]
	-- Add the parameters for the stored procedure here
	@TenantId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @PfpPremiumFeeModel varchar(50) = 'PFP Premium'
		, @PfpPaymentTypeName varchar(100) = 'Online Payment via PayPal'
		, @StampDate DATETIME = GetDate()
		, @StampUser INT = 0
		, @ErrorMessage VARCHAR(1000)

	DECLARE 
			@AdviceFeeChargingDetailId		INT
			, @FeeModelId					INT
			, @AdviseFeeTypeId				INT
			, @PfpPremiumFeeTemplateId		INT
			, @PfpPaymentTypeId				INT

	IF NOT EXISTS ( SELECT 1 FROM dbo.TFeeModel WHERE Name = @PfpPremiumFeeModel and TenantId = @TenantId and IsSystemDefined = 1)
		RETURN

	SELECT
		@FeeModelId = FeeModelId
	FROM 
		dbo.TFeeModel 
	WHERE 
		Name = @PfpPremiumFeeModel and TenantId = @TenantId and IsSystemDefined = 1

	SELECT 
		@PfpPremiumFeeTemplateId = FeeModelTemplateId
		, @AdviceFeeChargingDetailId = AdviseFeeChargingDetailsId
		, @AdviseFeeTypeId = AdviseFeeTypeId 
	FROM 
		dbo.TFeeModelTemplate 
	WHERE 
		FeeModelId = @FeeModelId AND TenantId = @TenantId

	SELECT 
		@PfpPaymentTypeId = AdvisePaymentTypeId 
	FROM 
		dbo.TAdvisePaymentType 
	WHERE 
		Name = @PfpPaymentTypeName AND TenantId = @TenantId

	---------------------------------------------------------------------------------------------
	-- Prerequisite check if there is a fee created using either the  advise fee charging details, fee type or the payment type used by the PFP PRemium Fee Model
	-- If there is just print a message an return
	IF EXISTS ( SELECT 1 FROM TFee WHERE AdviseFeeTypeId = @AdviseFeeTypeId and IndigoClientId = @TenantId)
		BEGIN
			PRINT('PFP Premium model cannot be deleted for tenant: ' + convert(varchar, @TenantId))
			RETURN
		END

	IF EXISTS ( SELECT 1 FROM TFee WHERE AdvisePaymentTypeId = @PfpPaymentTypeId and IndigoClientId = @TenantId)
		BEGIN
			PRINT('PFP Premium model cannot be deleted for tenant: ' + convert(varchar, @TenantId))
			RETURN
		END

	PRINT('START DELETES PFP Premium FEE MODEL set up for а tenant:' + convert(varchar, @TenantId))
	---------------------------------------------------------------------------------------------
	-- STEP 1 UNASSIGN PAYMENT TYPE TO PFP PREMIUM FEE TEMPLATE
	--PRINT('STEP 1 UNASSIGN PAYMENT TYPE TO PFP PREMIUM FEE TEMPLATE')
	DELETE 
		dbo.TFeeModelTemplateToAdvisePaymentType
	OUTPUT
		DELETED.FeeModelTemplateId
		, DELETED.AdvisePaymentTypeId
		, DELETED.TenantId
		, DELETED.ConcurrencyId
		, DELETED.FeeModelTemplateToAdvisePaymentTypeId
		, 'D'
		, @StampDate
		, @StampUser
	INTO
		dbo.TFeeModelTemplateToAdvisePaymentTypeAudit
		(FeeModelTemplateId
		, AdvisePaymentTypeId
		, TenantId
		, ConcurrencyId
		, FeeModelTemplateToAdvisePaymentTypeId
		, StampAction
		, StampDateTime
		, StampUser)
	WHERE
		FeeModelTemplateId = @PfpPremiumFeeTemplateId
		AND AdvisePaymentTypeId = @PfpPaymentTypeId
		AND TenantId = @TenantId

	-- STEP 2 DELETE PayPal Payment Type
	--PRINT('STEP 2 DELETE PayPal Payment Type')
	DELETE FROM 
		dbo.TAdvisePaymentType 
	OUTPUT
		DELETED.TenantId
		, DELETED.IsArchived
		, DELETED.ConcurrencyId
		, DELETED.AdvisePaymentTypeId
		, 'D'
		, @StampDate
		, @StampUser
		, DELETED.Name
		, DELETED.IsSystemDefined
		, DELETED.GroupId
		, DELETED.RefAdvisePaidById
		, DELETED.PaymentProviderId
	INTO
		dbo.TAdvisePaymentTypeAudit
		(TenantId
		, IsArchived
		, ConcurrencyId
		, AdvisePaymentTypeId
		, StampAction
		, StampDateTime
		, StampUser
		, Name
		, IsSystemDefined
		, GroupId
		, RefAdvisePaidById
		, PaymentProviderId)
	WHERE 
		Name = @PfpPaymentTypeName AND TenantId = @TenantId

	-- STEP 3 DELETE Fee Template fro model 'PFP Premium'
	--PRINT('STEP 3 DELETE Fee Template for model "PFP Premium"')
	DELETE FROM
		dbo.TFeeModelTemplate
	OUTPUT
		DELETED.FeeModelId
		, DELETED.AdviseFeeTypeId
		, DELETED.AdviseFeeChargingDetailsId
		, DELETED.FeeAmount
		, DELETED.IsDefault
		, DELETED.VATAmount
		, DELETED.IsVATExcempt
		, DELETED.TenantId
		, DELETED.ConcurrencyId
		, DELETED.FeeModelTemplateId
		, DELETED.RecurringFrequencyId
		, DELETED.InstalmentsFrequencyId
		, DELETED.RefVATId
		, DELETED.InitialPeriod
		, DELETED.IsInstalments
		, DELETED.IsPaidByProvider
		, DELETED.NumRecurringPayments
		, DELETED.RefAdviceContributionTypeId
		, DELETED.StartDate
		, DELETED.EndDate
		, DELETED.RefFeeAdviseTypeId
		, DELETED.FeePercentage
		, 'D'
		, @StampDate
		, @StampUser
		, DELETED.IsConsultancyFee
		, DELETED.ServiceStatusId
		, DELETED.IsRetainer
		, DELETED.FeeCode
	INTO
		dbo.TFeeModelTemplateAudit
		(FeeModelId
		, AdviseFeeTypeId
		, AdviseFeeChargingDetailsId
		, FeeAmount
		, IsDefault
		, VATAmount
		, IsVATExcempt
		, TenantId
		, ConcurrencyId
		, FeeModelTemplateId
		, RecurringFrequencyId
		, InstalmentsFrequencyId
		, RefVATId
		, InitialPeriod
		, IsInstalments
		, IsPaidByProvider
		, NumRecurringPayments
		, RefAdviceContributionTypeId
		, StartDate
		, EndDate
		, RefFeeAdviseTypeId
		, FeePercentage
		, StampAction
		, StampDateTime
		, StampUser
		, IsConsultancyFee
		, ServiceStatusId
		, IsRetainer
		, FeeCode)
	WHERE
		FeeModelId = @FeeModelId 
		AND TenantId = @TenantId
		AND IsDefault = 1

	-- STEP 4 DELETE Fee Model History for model 'PFP Premium'
	--PRINT('STEP 4 DELETE Fee Model History for model "PFP Premium"')
	DELETE FROM	
		dbo.TFeeModelStatusHistory 
	OUTPUT
		DELETED.FeeModelId
		, DELETED.[Version]
		, DELETED.RefFeeModelStatusId
		, DELETED.ActionType
		, DELETED.UpdatedDate
		, DELETED.UpdatedBy
		, DELETED.FeeModelStatusHistoryNote
		, DELETED.TenantId
		, DELETED.ConcurrencyId
		, DELETED.FeeModelStatusHistoryId
		, 'D'
		, @StampDate
		, @StampUser
	INTO
		dbo.TFeeModelStatusHistoryAudit
		(FeeModelId
		, [Version]
		, RefFeeModelStatusId
		, ActionType
		, UpdatedDate
		, UpdatedBy
		, FeeModelStatusHistoryNote
		, TenantId
		, ConcurrencyId
		, FeeModelStatusHistoryId
		, StampAction
		, StampDateTime
		, StampUser)
	WHERE 
		FeeModelId = @FeeModelId

	-- STEP 5 DELETE Fee Model "PFP Premium"
	--PRINT('STEP 5 DELETE Fee Model "PFP Premium"')
	DELETE FROM	
		dbo.TFeeModel
	OUTPUT
		DELETED.Name
		, DELETED.StartDate
		, DELETED.EndDate
		, DELETED.RefFeeModelStatusId
		, DELETED.IsDefault
		, DELETED.TenantId
		, DELETED.ConcurrencyId
		, DELETED.FeeModelId
		, 'D'
		, @StampDate
		, @StampUser
		, DELETED.GroupId
		, DELETED.IsPropagated
		, DELETED.IsSystemDefined
		, DELETED.IsArchived
	INTO
		dbo.TFeeModelAudit
		(Name
		, StartDate
		, EndDate
		, RefFeeModelStatusId
		, IsDefault
		, TenantId
		, ConcurrencyId
		, FeeModelId
		, StampAction
		, StampDateTime
		, StampUser
		, GroupId
		, IsPropagated
		, IsSystemDefined
		, IsArchived)
	WHERE
		FeeModelId = @FeeModelId

	-- STEP 6 DELETE PFP Premium Fee AdviseFeeType
	--PRINT('STEP 6 DELETE PFP Premium Fee AdviseFeeType')
	DELETE FROM	
		dbo.TAdviseFeeType
	OUTPUT
		DELETED.Name
		, DELETED.TenantId
		, DELETED.IsArchived
		, DELETED.ConcurrencyId
		, DELETED.AdviseFeeTypeId
		, 'D'
		, @StampDate
		, @StampUser
		, DELETED.IsRecurring
		, DELETED.GroupId
		, DELETED.RefAdviseFeeTypeId
		, DELETED.IsSystemDefined
	INTO
		dbo.TAdviseFeeTypeAudit
		(Name
		, TenantId
		, IsArchived
		, ConcurrencyId
		, AdviseFeeTypeId
		, StampAction
		, StampDateTime
		, StampUser
		, IsRecurring
		, GroupId
		, RefAdviseFeeTypeId
		, IsSystemDefined)
	WHERE
		AdviseFeeTypeId = @AdviseFeeTypeId

	-- STEP 7 DELETE PFP Fee Template Charging Details
	IF NOT EXISTS ( SELECT 1 FROM TFee WHERE AdviseFeeChargingDetailsId = @AdviceFeeChargingDetailId and IndigoClientId = @TenantId)
	BEGIN
		--PRINT('STEP 7 DELETE PFP Fee Template Charging Details')
		DELETE FROM
			dbo.TAdviseFeeChargingDetails
		OUTPUT
			DELETED.AdviseFeeChargingTypeId
			, DELETED.Amount
			, DELETED.PercentageOfFee
			, DELETED.MinimumFee
			, DELETED.MaximumFee
			, DELETED.TenantId
			, DELETED.ConcurrencyId
			, DELETED.AdviseFeeChargingDetailsId
			, 'D'
			, @StampDate
			, @StampUser
			, DELETED.IsArchived
			, DELETED.GroupId
			, DELETED.MinimumFeePercentage
			, DELETED.MaximumFeePercentage
			, DELETED.IsSystemDefined
		INTO
			dbo.TAdviseFeeChargingDetailsAudit
			(AdviseFeeChargingTypeId
			, Amount
			, PercentageOfFee
			, MinimumFee
			, MaximumFee
			, TenantId
			, ConcurrencyId
			, AdviseFeeChargingDetailsId
			, StampAction
			, StampDateTime
			, StampUser
			, IsArchived
			, GroupId
			, MinimumFeePercentage
			, MaximumFeePercentage
			, IsSystemDefined)
		WHERE
			AdviseFeeChargingDetailsId = @AdviceFeeChargingDetailId
	END

	PRINT('PFP Premium FEE MODEL has been deleted for а tenant:' + convert(varchar, @TenantId))
END
GO
