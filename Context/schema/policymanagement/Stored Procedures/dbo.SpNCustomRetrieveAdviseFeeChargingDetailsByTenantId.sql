SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrieveAdviseFeeChargingDetailsByTenantId]

@TenantId BIGINT

AS

SELECT FChargingDetails.AdviseFeeChargingDetailsId AS AdviseFeeChargingDetailsId
, FChargingDetails.PercentageOfFee AS PercentageOfFee
, FChargingDetails.Amount AS Amount
, FChargingType.AdviseFeeChargingTypeId AS AdviseFeeChargingTypeId
, RefFChargingType.Name AS RefFeeChargingType
, RefFChargingType.RefAdviseFeeChargingTypeId AS RefAdviseFeeChargingTypeId

FROM  TAdviseFeeChargingDetails FChargingDetails 
LEFT OUTER JOIN TAdviseFeeChargingType FChargingType ON FChargingDetails.AdviseFeeChargingTypeId=FChargingType.AdviseFeeChargingTypeId 
LEFT OUTER JOIN TRefAdviseFeeChargingType RefFChargingType ON FChargingType.RefAdviseFeeChargingTypeId=RefFChargingType.RefAdviseFeeChargingTypeId 


WHERE FChargingDetails.TenantId = @TenantId
AND (RefFChargingType.RefAdviseFeeChargingTypeId = 2 
OR RefFChargingType.RefAdviseFeeChargingTypeId = 3 
OR RefFChargingType.RefAdviseFeeChargingTypeId = 1)
AND FChargingDetails.IsArchived = 0
AND FChargingType.IsArchived = 0
ORDER BY AdviseFeeChargingDetailsId ASC



select * from POlicyManagement..TRefAdviseFeeChargingType