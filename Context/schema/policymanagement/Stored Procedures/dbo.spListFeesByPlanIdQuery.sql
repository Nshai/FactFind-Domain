SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Modification History (most recent first)
Date        Modifier        Issue       Description
----        ---------       -------     -------------
20210916    Nick Fairway    COPS-2997     Performance Improvement
*/
CREATE PROCEDURE dbo.spListFeesByPlanIdQuery
    @PlanId INT,
    @TenantId INT
AS
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    DECLARE
        @DeletedStatus VARCHAR(30) = 'Deleted'

	-- CTE below is just performing an OR for the WHERE but produces a much better plan as a UNION(COPS-2997).
	;WITH a as (
	SELECT 
            IsTopUp =IIF (policyBusiness.TopupMasterPolicyBusinessId IS NOT NULL, 1, 0)
        ,   policyBusiness.PolicyBusinessId
        ,   fee2Policy.FeeId

        FROM	dbo.TPolicyBusiness policyBusiness
        JOIN	dbo.TFee2Policy fee2Policy ON policyBusiness.PolicyBusinessId = fee2Policy.PolicyBusinessId
        WHERE
                policyBusiness.TopupMasterPolicyBusinessId = @PlanId

        UNION ALL -- can be union ALL as TopupMasterPolicyBusinessId can never be = PolicyBusinessId as it is a hierarchy

        SELECT 
            IsTopUp =IIF (policyBusiness.TopupMasterPolicyBusinessId IS NOT NULL, 1, 0)
        ,   policyBusiness.PolicyBusinessId
	,   fee2Policy.FeeId
        FROM	dbo.TPolicyBusiness policyBusiness
        JOIN	dbo.TFee2Policy fee2Policy ON policyBusiness.PolicyBusinessId = fee2Policy.PolicyBusinessId
        WHERE
                fee2Policy.PolicyBusinessId = @PlanId
        )
    SELECT
        fee.FeeId AS FeeId,
        fee.SequentialRef AS SequentialRef,
        FeeType.RefAdviseFeeTypeId AS FeeCategory,
        FeeType.Name AS FeeType,
        FeeChargingType.RefAdviseFeeChargingTypeId AS FeeChargingType,
        paymentType.Name AS PaymentType,
        paidBy.IsPaidByProvider,
        (SELECT Status FROM TFeeStatus WHERE FeeStatusId IN(SELECT MAX(FeeStatusId) FROM TFeeStatus WHERE FeeId = fee.FeeId)) AS FeeStatus,
        COALESCE(fee.FeePercentage, feeChargingDetails.PercentageOfFee) AS FeePercentage,
        ongoingFrequency.PeriodName AS OngoingFrequencyName,
        fee.IsRecurring AS IsRecurring,
        installmentFrequency.PeriodName AS InstallmentFrequencyName,
        paidBy.Name AS PaidByName,
        fee.InvoiceDate AS InvoiceDate,
        feeOwner.CRMContactId AS FeePrimaryOwnerId,
        IsTopUp,
        fee2Policy.PolicyBusinessId AS PlanId,
        feeChargingDetails.AdviseFeeChargingDetailsId AS FeeChargingDetailsId,
        feeChargingDetails.Name AS FeeChargingDetailsName
        FROM a fee2Policy
	INNER JOIN dbo.TFee fee ON fee.FeeId = fee2Policy.FeeId AND Fee.IndigoClientId = @TenantId
	INNER JOIN dbo.TStatusHistory statusHistory
	ON	fee2Policy.PolicyBusinessId = statusHistory.PolicyBusinessId
	AND statusHistory.CurrentStatusFG = 1
	INNER JOIN dbo.TStatus status
	ON statusHistory.StatusId = status.StatusId
	AND status.IntelligentOfficeStatusType != @DeletedStatus
	LEFT JOIN dbo.TAdvisePaymentType paymentType
	ON paymentType.AdvisePaymentTypeId = fee.AdvisePaymentTypeId
	LEFT JOIN dbo.TAdviseFeeType feeType 
	ON fee.AdviseFeeTypeId=feeType.AdviseFeeTypeId 
	LEFT JOIN dbo.TRefAdvisePaidBy paidBy
	ON paidBy.RefAdvisePaidById = paymentType.RefAdvisePaidById
	LEFT JOIN dbo.TAdviseFeeChargingDetails feeChargingDetails
	ON fee.AdviseFeeChargingDetailsId = feeChargingDetails.AdviseFeeChargingDetailsId
	LEFT JOIN dbo.TAdviseFeeChargingType feeChargingType
	ON feeChargingDetails.AdviseFeeChargingTypeId = feeChargingType.AdviseFeeChargingTypeId
	LEFT JOIN dbo.TRefFeeRetainerFrequency ongoingFrequency
	ON fee.RecurringFrequencyId = ongoingFrequency.RefFeeRetainerFrequencyId
	LEFT JOIN dbo.TRefFeeRetainerFrequency installmentFrequency
	ON fee.RefFeeRetainerFrequencyId = installmentFrequency.RefFeeRetainerFrequencyId
	LEFT JOIN dbo.TFeeRetainerOwner feeOwner
	ON fee.FeeId = feeOwner.FeeId

GO