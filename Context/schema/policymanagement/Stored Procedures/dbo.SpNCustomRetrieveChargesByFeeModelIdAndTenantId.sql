SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrieveChargesByFeeModelIdAndTenantId]

@FeeModelId BIGINT,
@TenantId BIGINT

AS

SELECT FeeModelTemplate.FeeModelTemplateId AS FeeModelTemplateId
, FeeModel.FeeModelId AS FeeModelId
, FeeModelTemplate.IsDefault AS IsDefault
, AdviseFeeType.AdviseFeeTypeId AS AdviseFeeTypeId
, AdviseFeeType.Name AS FeeTypeName
, FChargingDetails.AdviseFeeChargingDetailsId AS AdviseFeeChargingDetailsId
, FChargingDetails.PercentageOfFee AS PercentageOfFee
, FChargingDetails.Amount AS Amount
, FChargingType.AdviseFeeChargingTypeId AS AdviseFeeChargingTypeId
, RefFChargingType.Name AS RefFeeChargingType
, RefFeeFrequency.RefFeeRetainerFrequencyId AS FeeFrequency
, RefFeeFrequency.PeriodName AS FeePeriodName
, RefRetainerFrequency.RefFeeRetainerFrequencyId AS RetainerFrequency
, RefRetainerFrequency.PeriodName AS RetainerPeriodName
, (CASE WHEN RefFeeFrequency.PeriodName IS NOT NULL THEN RefFeeFrequency.PeriodName ELSE RefRetainerFrequency.PeriodName END) AS PeriodName
, FeeModelTemplate.FeeAmount AS FeeAmount
, FeeModel.Name AS FeeModelName
, RefFChargingType.RefAdviseFeeChargingTypeId AS RefAdviseFeeChargingTypeId
, FeeModelTemplate.IsVATExcempt AS IsVATExcempt
, FeeModelTemplate.VATAmount AS VATAmount
, RefVat.RefVATId AS RefVATId
, FeeModelTemplate.IsInstalments AS IsInstalments
, FeeModelTemplate.NumRecurringPayments AS NumRecurringPayments
, FeeModelTemplate.RefAdviceContributionTypeId AS RefAdviceContributionTypeId
, FeeModelTemplate.InitialPeriod AS InitialPeriod
, FeeModelTemplate.StartDate AS StartDate
, FeeModelTemplate.EndDate AS EndDate
, RefAdviseFType.RefAdviseFeeTypeId AS RefAdviseFeeTypeId
, RefAdviseFType.Name AS Name
, RefAdviseFType.IsInitial AS IsInitial
, RefAdviseFType.IsOneOff AS IsOneOff
, RefAdviseFType.IsRecurring AS IsRecurring
, FeeModelTemplate.RefFeeAdviseTypeId AS RefFeeAdviseTypeId 

FROM TFeeModelTemplate FeeModelTemplate 
LEFT OUTER JOIN TFeeModel FeeModel ON FeeModelTemplate.FeeModelId=FeeModel.FeeModelId 
LEFT OUTER JOIN TAdviseFeeType AdviseFeeType ON FeeModelTemplate.AdviseFeeTypeId=AdviseFeeType.AdviseFeeTypeId 
LEFT OUTER JOIN TRefAdviseFeeType RefAdviseFType ON AdviseFeeType.RefAdviseFeeTypeId=RefAdviseFType.RefAdviseFeeTypeId 
LEFT OUTER JOIN TAdviseFeeChargingDetails FChargingDetails ON FeeModelTemplate.AdviseFeeChargingDetailsId=FChargingDetails.AdviseFeeChargingDetailsId 
LEFT OUTER JOIN TAdviseFeeChargingType FChargingType ON FChargingDetails.AdviseFeeChargingTypeId=FChargingType.AdviseFeeChargingTypeId 
LEFT OUTER JOIN TRefAdviseFeeChargingType RefFChargingType ON FChargingType.RefAdviseFeeChargingTypeId=RefFChargingType.RefAdviseFeeChargingTypeId 
LEFT OUTER JOIN TRefFeeRetainerFrequency RefRetainerFrequency ON FeeModelTemplate.RecurringFrequencyId=RefRetainerFrequency.RefFeeRetainerFrequencyId 
LEFT OUTER JOIN TRefFeeRetainerFrequency RefFeeFrequency ON FeeModelTemplate.InstalmentsFrequencyId=RefFeeFrequency.RefFeeRetainerFrequencyId 
LEFT OUTER JOIN TRefVAT RefVat ON FeeModelTemplate.RefVATId=RefVat.RefVATId 

WHERE FeeModel.FeeModelId = @FeeModelId 
and FeeModelTemplate.TenantId = @TenantId
AND (RefFChargingType.RefAdviseFeeChargingTypeId = 2 
OR RefFChargingType.RefAdviseFeeChargingTypeId = 3 
OR RefFChargingType.RefAdviseFeeChargingTypeId = 1)

ORDER BY FeeModelTemplate.FeeModelTemplateId ASC

