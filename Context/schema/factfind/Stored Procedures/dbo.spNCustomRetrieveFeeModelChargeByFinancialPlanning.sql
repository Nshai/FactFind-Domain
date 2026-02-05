SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spNCustomRetrieveFeeModelChargeByFinancialPlanning]

@FinancialPlanningId BIGINT

AS

SELECT
	FS.FinancialPlanningId AS FinancialPlanningId,
	FM.FeeModelId AS FeeModelId,
	CASE 
		WHEN ISNULL(ACDI.PercentageOfFee, 0) > 0 THEN ACDI.PercentageOfFee
		WHEN ISNULL(ACDI.AMOUNT, 0) > 0 THEN ACDI.AMOUNT
		ELSE 0 END
		AS InitialCharge
	,CASE 
		WHEN ISNULL(ACDI.PercentageOfFee, 0) > 0 THEN 'Percentage'
		WHEN ISNULL(ACDI.AMOUNT, 0) > 0 THEN 'Amount'
		ELSE '' END
		AS InitialChargeType
	, ISNULL(FTI.InitialPeriod, 0) AS InitialPeriodMonths
	,CASE 
		WHEN ISNULL(IDis.Percentage, 0) > 0 THEN IDis.Percentage
		WHEN ISNULL(IDis.AMOUNT, 0) > 0 THEN IDis.AMOUNT
		ELSE 0 END
		AS DiscountOnInitialCharge
	,CASE 
		WHEN ISNULL(IDis.Percentage, 0) > 0 THEN 'Percentage'
		WHEN ISNULL(IDis.AMOUNT, 0) > 0 THEN 'Amount'
		ELSE '' END
		AS DiscountType
	,CASE 
		WHEN ISNULL(ACDO.PercentageOfFee, 0) > 0 THEN ACDO.PercentageOfFee
		WHEN ISNULL(ACDO.AMOUNT, 0) > 0 THEN ACDO.AMOUNT
		ELSE 0 END
		AS OngoingCharge
	,CASE 
		WHEN ISNULL(ACDO.PercentageOfFee, 0) > 0 THEN 'Percentage'
		WHEN ISNULL(ACDO.AMOUNT, 0) > 0 THEN 'Amount'
		ELSE '' END
		AS OngoingChargeType
	, RF.PeriodName AS Frequency
	, ISNULL(RF.NumMonths, 0) AS FrequencyMonths

FROM TFinancialPlanningFeeModelForSession FS

LEFT JOIN PolicyManagement..TFeeModel FM ON FS.FeeModelId = FM.FeeModelId
LEFT JOIN PolicyManagement..TFeeModelTemplate FTI ON FTI.FeeModelTemplateId = FS.InitialFeeModelTemplateId
LEFT JOIN PolicyManagement..TAdviseFeeChargingDetails ACDI ON FTI.AdviseFeeChargingDetailsId = ACDI.AdviseFeeChargingDetailsId
LEFT JOIN PolicyManagement..TDiscount IDis ON IDis.DiscountId = FS.DiscountId
LEFT JOIN PolicyManagement..TFeeModelTemplate FTO ON FTO.FeeModelTemplateId = FS.OngoingFeeModelTemplateId
LEFT JOIN PolicyManagement..TAdviseFeeChargingDetails ACDO ON FTO.AdviseFeeChargingDetailsId = ACDO.AdviseFeeChargingDetailsId
LEFT JOIN PolicyManagement..TRefFeeRetainerFrequency RF ON FTO.RecurringFrequencyId = RF.RefFeeRetainerFrequencyId

WHERE FS.FinancialPlanningId = @FinancialPlanningId

GO
