SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrieveCurrentFeeChargesByPolicyBusinessId] 

@PolicyBusinessId BIGINT

AS


DECLARE @DateCheck DATETIME
SELECT @DateCheck= CAST(CAST(GETDATE() AS DATE) AS DATETIME)

-- NOTE -	We are not going to return the FeeModelId from this SP because for an Existing Plan we want to return the LATEST Initial Charge and LATEST On-Going Charge irrespective
--			of which Fee Model they belong to. We just need the Charges. 
DECLARE @TempFeeModelForPolicyBusiness TABLE (
PolicyBusinessId BIGINT,
InitialFeeModelId BIGINT,
InitialCharge DECIMAL(18, 2),
DiscountOnInitialCharge  BIGINT,
DiscountType VARCHAR(25),
InitialPeriodMonths BIGINT,
InitialChargeType VARCHAR(25),
OngoingFeeModelId BIGINT,
OngoingCharge DECIMAL(18, 2),
OngoingChargeType VARCHAR(25) ,
Frequency VARCHAR(25) ,
FrequencyMonths INT)

-- Insert the policy Business Id
INSERT INTO @TempFeeModelForPolicyBusiness (PolicyBusinessId)
SELECT @PolicyBusinessId

-- INITIAL CHARGE (TEMPLATE BASED) - The query has been split because we could have more than one Intial Charge linked to the policy for a Fee Template. 
--					We need to use the one that is most latest.
SELECT 
	F2P.PolicyBusinessId AS PolicyBusinessId,
	FTI.FeeModelId AS FeeModelId,
	F2P.Fee2PolicyId As Fee2PolicyId,
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
	INTO #tempIntialChargeFeeModels
FROM 
PolicyManagement..TFee2Policy F2P
INNER JOIN PolicyManagement..TFee Fee ON Fee.FeeId = F2P.FeeId
INNER JOIN PolicyManagement..TFeeModelTemplate FTI ON Fee.FeeModelTemplateId=FTI.FeeModelTemplateId 
INNER JOIN PolicyManagement..TFeeModel FM ON FTI.FeeModelId = FM.FeeModelId
INNER JOIN PolicyManagement..TAdviseFeeChargingDetails ACDI ON FTI.AdviseFeeChargingDetailsId = ACDI.AdviseFeeChargingDetailsId
INNER JOIN PolicyManagement..TAdviseFeeChargingType FCType ON ACDI.AdviseFeeChargingTypeId = FCType.AdviseFeeChargingTypeId
INNER JOIN PolicyManagement..TRefAdviseFeeChargingType RefFC ON RefFC.RefAdviseFeeChargingTypeId = FCType.RefAdviseFeeChargingTypeId  
INNER JOIN PolicyManagement..TAdviseFeeType AFI ON FTI.AdviseFeeTypeId = AFI.AdviseFeeTypeId  
INNER JOIN PolicyManagement..TRefFeeModelStatus RefFeeModelStatus ON FM.RefFeeModelStatusId=RefFeeModelStatus.RefFeeModelStatusId 
-- MAY or MAY NOT have a discount
LEFT JOIN PolicyManagement..TDiscount IDis ON IDis.DiscountId=Fee.DiscountId

WHERE F2P.PolicyBusinessId = @PolicyBusinessId
AND RefFeeModelStatus.RefFeeModelStatusId = 2 -- Approved
AND (FM.StartDate <= @DateCheck OR FM.StartDate IS NULL) 
AND (FM.EndDate >= @DateCheck OR FM.EndDate IS NULL) 
AND  (RefFC.RefAdviseFeeChargingTypeId = 3 -- % of All Investment Contribution  
 OR  RefFC.RefAdviseFeeChargingTypeId = 8 -- % of Regular Contribution
 OR  RefFC.RefAdviseFeeChargingTypeId = 9 -- % of Lump Sum Contribution 
 OR  RefFC.RefAdviseFeeChargingTypeId = 10 -- % of Transfer Contribution  
 OR  RefFC.RefAdviseFeeChargingTypeId = 1) -- Fixed Price  
AND AFI.RefAdviseFeeTypeId = 1 -- Initial Fee
UNION ALL
-- INITIAL CHARGE - NON TEMPLATE BASED FEE
SELECT 
	F2P.PolicyBusinessId AS PolicyBusinessId,
	0 AS FeeModelId,
	F2P.Fee2PolicyId As Fee2PolicyId,
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
	, ISNULL(Fee.InitialPeriod, 0) AS InitialPeriodMonths
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
FROM 
PolicyManagement..TFee2Policy F2P
INNER JOIN PolicyManagement..TFee Fee ON Fee.FeeId = F2P.FeeId
INNER JOIN PolicyManagement..TAdviseFeeChargingDetails ACDI ON Fee.AdviseFeeChargingDetailsId = ACDI.AdviseFeeChargingDetailsId
INNER JOIN PolicyManagement..TAdviseFeeChargingType FCType ON ACDI.AdviseFeeChargingTypeId = FCType.AdviseFeeChargingTypeId
INNER JOIN PolicyManagement..TRefAdviseFeeChargingType RefFC ON RefFC.RefAdviseFeeChargingTypeId = FCType.RefAdviseFeeChargingTypeId  
INNER JOIN PolicyManagement..TAdviseFeeType AFI ON AFI.AdviseFeeTypeId = Fee.AdviseFeeTypeId  
INNER JOIN PolicyManagement..TRefAdviseFeeType FT ON FT.RefAdviseFeeTypeId = AFI.RefAdviseFeeTypeId
LEFT JOIN PolicyManagement..TDiscount IDis ON IDis.DiscountId=Fee.DiscountId

WHERE F2P.PolicyBusinessId = @PolicyBusinessId
AND  (RefFC.RefAdviseFeeChargingTypeId = 3 -- % of All Investment Contribution  
 OR  RefFC.RefAdviseFeeChargingTypeId = 8 -- % of Regular Contribution
 OR  RefFC.RefAdviseFeeChargingTypeId = 9 -- % of Lump Sum Contribution 
 OR  RefFC.RefAdviseFeeChargingTypeId = 10 -- % of Transfer Contribution
 OR  RefFC.RefAdviseFeeChargingTypeId = 1) -- Fixed Price  
AND FT.RefAdviseFeeTypeId = 1 -- Initial Fee



-- ONGOING CHARGE(FEE TEMPLATE BASED) - The query has been split because we could have more than one Ongoing Charge linked to the policy for a Fee Template. 
--					We need to use the one that is most latest.
SELECT 
	F2P.PolicyBusinessId AS PolicyBusinessId,
	FTO.FeeModelId AS FeeModelId,
	F2P.Fee2PolicyId As Fee2PolicyId,
	CASE 
		WHEN ISNULL(ACDO.PercentageOfFee, 0) > 0 THEN ACDO.PercentageOfFee
		WHEN ISNULL(ACDO.AMOUNT, 0) > 0 THEN ACDO.AMOUNT
		ELSE 0 END
		AS OngoingCharge
	,CASE 
		WHEN ISNULL(ACDO.PercentageOfFee, 0) > 0 THEN 'Percentage'
		WHEN ISNULL(ACDO.AMOUNT, 0) > 0 THEN 'Amount'
		ELSE '' END
		AS OngoingChargeType
	, Frequency.PeriodName AS Frequency
	, ISNULL(Frequency.NumMonths, 0) AS FrequencyMonths
	INTO #tempOngoingChargeFeeModels
FROM 
PolicyManagement..TFee2Policy F2P
INNER JOIN PolicyManagement..TFee Fee ON Fee.FeeId = F2P.FeeId
INNER JOIN PolicyManagement..TFeeModelTemplate FTO ON Fee.FeeModelTemplateId=FTO.FeeModelTemplateId 
INNER JOIN PolicyManagement..TFeeModel FM ON FTO.FeeModelId = FM.FeeModelId
INNER JOIN PolicyManagement..TAdviseFeeChargingDetails ACDO ON FTO.AdviseFeeChargingDetailsId = ACDO.AdviseFeeChargingDetailsId
INNER JOIN PolicyManagement..TAdviseFeeChargingType FCType ON ACDO.AdviseFeeChargingTypeId = FCType.AdviseFeeChargingTypeId
INNER JOIN PolicyManagement..TRefAdviseFeeChargingType RefFC ON RefFC.RefAdviseFeeChargingTypeId = FCType.RefAdviseFeeChargingTypeId  
INNER JOIN PolicyManagement..TAdviseFeeType AFO ON FTO.AdviseFeeTypeId = AFO.AdviseFeeTypeId  
INNER JOIN PolicyManagement..TRefFeeModelStatus RefFeeModelStatus ON FM.RefFeeModelStatusId=RefFeeModelStatus.RefFeeModelStatusId 
-- MAY or MAY NOT have a frequency
LEFT JOIN PolicyManagement..TRefFeeRetainerFrequency Frequency ON Fee.RecurringFrequencyId=Frequency.RefFeeRetainerFrequencyId 

WHERE F2P.PolicyBusinessId = @PolicyBusinessId
AND RefFeeModelStatus.RefFeeModelStatusId = 2 -- Approved
AND (FM.StartDate <= @DateCheck OR FM.StartDate IS NULL) 
AND (FM.EndDate >= @DateCheck OR FM.EndDate IS NULL) 
AND ( RefFC.RefAdviseFeeChargingTypeId = 2 -- % of FUM/AUM  
 OR  RefFC.RefAdviseFeeChargingTypeId = 1) -- Fixed Price  
 AND AFO.RefAdviseFeeTypeId = 2 -- Ongoing Fee
UNION ALL
-- ONGOING CHARGE - ANY OTHER FEE
SELECT 
	F2P.PolicyBusinessId AS PolicyBusinessId,
	0 AS FeeModelId,
	F2P.Fee2PolicyId As Fee2PolicyId,
	CASE 
		WHEN ISNULL(ACDO.PercentageOfFee, 0) > 0 THEN ACDO.PercentageOfFee
		WHEN ISNULL(ACDO.AMOUNT, 0) > 0 THEN ACDO.AMOUNT
		ELSE 0 END
		AS OngoingCharge
	,CASE 
		WHEN ISNULL(ACDO.PercentageOfFee, 0) > 0 THEN 'Percentage'
		WHEN ISNULL(ACDO.AMOUNT, 0) > 0 THEN 'Amount'
		ELSE '' END
		AS OngoingChargeType
	, Frequency.PeriodName AS Frequency
	, ISNULL(Frequency.NumMonths, 0) AS FrequencyMonths

FROM 
PolicyManagement..TFee2Policy F2P
INNER JOIN PolicyManagement..TFee Fee ON Fee.FeeId = F2P.FeeId
INNER JOIN PolicyManagement..TAdviseFeeChargingDetails ACDO ON Fee.AdviseFeeChargingDetailsId = ACDO.AdviseFeeChargingDetailsId
INNER JOIN PolicyManagement..TAdviseFeeChargingType FCType ON ACDO.AdviseFeeChargingTypeId = FCType.AdviseFeeChargingTypeId
INNER JOIN PolicyManagement..TRefAdviseFeeChargingType RefFC ON RefFC.RefAdviseFeeChargingTypeId = FCType.RefAdviseFeeChargingTypeId  
INNER JOIN PolicyManagement..TAdviseFeeType AFO ON Fee.AdviseFeeTypeId = AFO.AdviseFeeTypeId  
INNER JOIN PolicyManagement..TRefAdviseFeeType FT ON FT.RefAdviseFeeTypeId = AFO.RefAdviseFeeTypeId
-- MAY or MAY NOT have a frequency
LEFT JOIN PolicyManagement..TRefFeeRetainerFrequency Frequency ON Fee.RecurringFrequencyId=Frequency.RefFeeRetainerFrequencyId 

WHERE F2P.PolicyBusinessId = @PolicyBusinessId
AND  (RefFC.RefAdviseFeeChargingTypeId =  2 -- % of FUM/AUM  
OR  RefFC.RefAdviseFeeChargingTypeId = 1) -- Fixed Price  
AND FT.RefAdviseFeeTypeId = 2 -- ONGOING Fee



-- Get the Maximum Fee Id. This will be our latest fee that has been linked
DECLARE @MaxInitialFeeId BIGINT, @MaxOngoingFeeId BIGINT
SELECT @MaxInitialFeeId = MAX(Fee2PolicyId) From #tempIntialChargeFeeModels
SELECT @MaxOngoingFeeId = MAX(Fee2PolicyId) From #tempOngoingChargeFeeModels

-- UPDATE THE TEMP TABLE

-- Update values for Initial Fee
IF ISNULL(@MaxInitialFeeId, 0) > 0
BEGIN
	UPDATE @TempFeeModelForPolicyBusiness 
	SET T1.InitialFeeModelId = T2.FeeModelId,
		T1.InitialCharge =  T2.InitialCharge,
		T1.DiscountOnInitialCharge =  T2.DiscountOnInitialCharge,
		T1.DiscountType =  T2.DiscountType,
		T1.InitialPeriodMonths =  T2.InitialPeriodMonths,
		T1.InitialChargeType =  T2.InitialChargeType
	FROM @TempFeeModelForPolicyBusiness T1
	INNER JOIN #tempIntialChargeFeeModels T2
		ON T2.PolicyBusinessId = T1.PolicyBusinessId
	WHERE T2.Fee2PolicyId = @MaxInitialFeeId
END

-- Update values for On-Going Fee
IF ISNULL(@MaxOngoingFeeId, 0) > 0
BEGIN
	UPDATE @TempFeeModelForPolicyBusiness 
	SET T1.OngoingFeeModelId = T2.FeeModelId,
		T1.OngoingCharge =  T2.OngoingCharge,
		T1.OngoingChargeType =  T2.OngoingChargeType,
		T1.Frequency =  T2.Frequency,
		T1.FrequencyMonths =  T2.FrequencyMonths
	FROM @TempFeeModelForPolicyBusiness T1
	INNER JOIN #tempOngoingChargeFeeModels T2
		ON T2.PolicyBusinessId = T1.PolicyBusinessId
	WHERE T2.Fee2PolicyId = @MaxOngoingFeeId
END

-- Return the Select Statement.
SELECT * FROM @TempFeeModelForPolicyBusiness 

-- DROP The Tempporary Tables
DROP TABLE #tempOngoingChargeFeeModels
DROP TABLE #tempIntialChargeFeeModels



GO
