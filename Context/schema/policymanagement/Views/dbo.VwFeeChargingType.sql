
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create VIEW [dbo].[VwFeeChargingType]
AS


--Note: Charging Types are not Required, 
--      however this view is assuming you are looking for 
--		Charging types that are not null for performance reasons
--		hence the use of inner joins
	Select F.FeeId, F.IndigoClientId as TenantId, F.SequentialRef, F.AdviseFeeChargingDetailsId, B.IsArchived, C.* 
	from  policymanagement..TFee F
	Inner Join policymanagement..TAdviseFeeChargingDetails A ON f.AdviseFeeChargingDetailsId = A.AdviseFeeChargingDetailsId
	INNER join policymanagement..TAdviseFeeChargingType B on A.AdviseFeeChargingTypeId = B.AdviseFeeChargingTypeId
	INNER join policymanagement..TRefAdviseFeeChargingType C ON B.RefAdviseFeeChargingTypeId = C.RefAdviseFeeChargingTypeId
