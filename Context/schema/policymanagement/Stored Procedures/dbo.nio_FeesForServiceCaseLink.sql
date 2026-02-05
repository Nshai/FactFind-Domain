SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_FeesForServiceCaseLink]
	@TenantId bigint,
	@ServiceCaseId bigint,
	@AllowMoreThanOneServiceCaseLink bit
AS
DECLARE @Owner1 int, @Owner2 int
------------------------------------------------------
-- Find service case owners
------------------------------------------------------
SELECT @Owner1 = CRMContactId, @Owner2 = Owner2PartyId
FROM CRM..TAdviceCase
WHERE AdviceCaseId = @ServiceCaseId

------------------------------------------------------
-- Find fees by owner
------------------------------------------------------
SELECT
	F.FeeId AS Id,
	F.SequentialRef,
	ISNULL(F.FeePercentage, FCD.PercentageOfFee) AS PercentageOfFee,
	F.NetAmount AS [FeeNetAmount],
	ISNULL(OngoingFrequency.PeriodName, InstalmentFrequency.PeriodName) AS FrequencyName,
	APB.Name as RefAdvisePaidByName,
	F.InvoiceDate,
	AFT.Name as AdviseFeeType,
	RFCT.Name  as AdviseChargingType
INTO 
	#Fees
FROM
	PolicyManagement..TFee F
	JOIN PolicyManagement..TFeeRetainerOwner FO ON FO.FeeId = F.FeeId  
	JOIN PolicyManagement..TRefFeeType RFT ON RFT.RefFeeTypeId = F.RefFeeTypeId  
	LEFT JOIN PolicyManagement.dbo.TAdviseFeeType AFT ON AFT.AdviseFeeTypeId = F.AdviseFeeTypeId
	LEFT JOIN PolicyManagement.dbo.TAdviseFeeChargingDetails FCD ON FCD.AdviseFeeChargingDetailsId = F.AdviseFeeChargingDetailsId
	LEFT JOIN PolicyManagement.dbo.TAdviseFeeChargingType FCT ON FCT.AdviseFeeChargingTypeId = FCD.AdviseFeeChargingTypeId
	LEFT JOIN PolicyManagement.dbo.TRefAdviseFeeChargingType RFCT ON RFCT.RefAdviseFeeChargingTypeId = FCT.RefAdviseFeeChargingTypeId  
	LEFT JOIN PolicyManagement.dbo.TAdvisePaymentType APT ON APT.AdvisePaymentTypeId = F.AdvisePaymentTypeId
	LEFT JOIN PolicyManagement.dbo.TRefAdvisePaidBy APB ON APB.RefAdvisePaidById = APT.RefAdvisePaidById
	LEFT JOIN PolicyManagement.dbo.TRefFeeRetainerFrequency InstalmentFrequency ON InstalmentFrequency.RefFeeRetainerFrequencyId = F.RefFeeRetainerFrequencyId
	LEFT JOIN PolicyManagement.dbo.TRefFeeRetainerFrequency OngoingFrequency ON OngoingFrequency.RefFeeRetainerFrequencyId = F.RecurringFrequencyId
WHERE
	F.IndigoClientId = @TenantId
	AND FO.IndigoClientId = @TenantId
	AND FO.CRMContactId IN (@Owner1, @Owner2)

--------------------------------------------------
-- Remove fees already linked to the service case
--------------------------------------------------
DELETE F
FROM
	#Fees F
	JOIN CRM..TAdviceCaseFee ACF ON ACF.FeeId = F.Id
WHERE
	(ACF.AdviceCaseId = @ServiceCaseId OR @AllowMoreThanOneServiceCaseLink = 0)

--------------------------------------------------
-- Find fees statuses
--------------------------------------------------
SELECT FS.FeeId, MAX(FS.FeeStatusId) AS FeeStatusId
INTO #StatusIds
FROM #Fees JOIN TFeeStatus FS ON FS.FeeId = #Fees.Id
GROUP BY FS.FeeId

--------------------------------------------------
-- Return data
--------------------------------------------------
SELECT
	#Fees.*,
	FS.[Status] AS FeeCurrentStatus
FROM
	#Fees
	JOIN #StatusIds S ON S.FeeId = #Fees.Id
	JOIN TFeeStatus FS ON FS.FeeStatusId = S.FeeStatusId
GO
