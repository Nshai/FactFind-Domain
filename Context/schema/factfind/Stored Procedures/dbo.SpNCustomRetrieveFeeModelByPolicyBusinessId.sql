SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 
CREATE PROCEDURE [dbo].[SpNCustomRetrieveFeeModelByPolicyBusinessId]   
  
@PolicyBusinessId BIGINT  
  
AS  
  
  
DECLARE @DateCheck DATETIME  
SELECT @DateCheck= CAST(CAST(GETDATE() AS DATE) AS DATETIME)  
  
-- NOTE - We are not going to return the FeeModelId from this SP because for an Existing Plan we want to return the LATEST Initial Charge and LATEST On-Going Charge irrespective  
--   of which Fee Model they belong to. We just need the Charges.   
DECLARE @TempFeeModelForPolicyBusiness TABLE (  
PolicyBusinessId BIGINT,  
InitialFeeModelId BIGINT, 
InitialFeeModelTemplateId BIGINT, 
InitialAdviseFeeChargingDetailsId BIGINT,  
InitialChargeType VARCHAR(20),
DiscountId BIGINT,
DiscountType  VARCHAR(20),
OngoingFeeModelId BIGINT,  
OngoingFeeModelTemplateId BIGINT, 
OngoingAdviseFeeChargingDetailsId BIGINT,
OngoingChargeType VARCHAR(20))  
  
-- Insert the policy Business Id  
INSERT INTO @TempFeeModelForPolicyBusiness (PolicyBusinessId)  
SELECT @PolicyBusinessId  
  
-- INITIAL CHARGE (TEMPLATE BASED) - The query has been split because we could have more than one Intial Charge linked to the policy for a Fee Template.   
--     We need to use the one that is most latest.  
SELECT   
 F2P.PolicyBusinessId AS PolicyBusinessId,  
 FTI.FeeModelId AS InitialFeeModelId,  
 FTI.FeeModelTemplateId AS InitialFeeModelTemplateId,
 ACDI.AdviseFeeChargingDetailsId As InitialAdviseFeeChargingDetailsId,  
 F2P.Fee2PolicyId As Fee2PolicyId,  
 CASE 
	WHEN RefFC.RefAdviseFeeChargingTypeId = 3 THEN 'Percentage'
	WHEN RefFC.RefAdviseFeeChargingTypeId = 1 THEN 'Amount'
	ELSE '' END
 AS InitialChargeType,
		
 IDis.DiscountId As DiscountId  ,
 CASE 
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
	 0 AS InitialFeeModelId,  
	 0 AS InitialFeeModelTemplateId,
	 ACDI.AdviseFeeChargingDetailsId As InitialAdviseFeeChargingDetailsId,  
	 F2P.Fee2PolicyId As Fee2PolicyId,
	 CASE 
		WHEN RefFC.RefAdviseFeeChargingTypeId = 3 THEN 'Percentage'
		WHEN RefFC.RefAdviseFeeChargingTypeId = 1 THEN 'Amount'
		ELSE '' END
	 AS InitialChargeType,
			
	 Fee.DiscountId As DiscountId  ,
	 CASE 
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
  
  
  
-- ONGOING CHARGE (TEMPLATE BASED) - The query has been split because we could have more than one Ongoing Charge linked to the policy for a Fee Template.   
--     We need to use the one that is most latest.  
SELECT   
 F2P.PolicyBusinessId AS PolicyBusinessId,  
 FTO.FeeModelId AS OngoingFeeModelId,  
 FTO.FeeModelTemplateId AS OngoingFeeModelTemplateId,
 F2P.Fee2PolicyId As Fee2PolicyId,
 ACDO.AdviseFeeChargingDetailsId As OngoingAdviseFeeChargingDetailsId,
 CASE 
	WHEN RefFC.RefAdviseFeeChargingTypeId = 2 THEN 'Percentage'
	WHEN RefFC.RefAdviseFeeChargingTypeId = 1 THEN 'Amount'
	ELSE '' END
 AS OngoingChargeType
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
	0 AS OngoingFeeModelId,  
	0 AS OngoingFeeModelTemplateId,
	F2P.Fee2PolicyId As Fee2PolicyId,
	ACDO.AdviseFeeChargingDetailsId As OngoingAdviseFeeChargingDetailsId,
	CASE 
		WHEN RefFC.RefAdviseFeeChargingTypeId = 2 THEN 'Percentage'
		WHEN RefFC.RefAdviseFeeChargingTypeId = 1 THEN 'Amount'
		ELSE '' END
	AS OngoingChargeType
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
 SET T1.InitialFeeModelId =  T2.InitialFeeModelId,  
  T1.InitialFeeModelTemplateId = T2.InitialFeeModelTemplateId,
  T1.InitialAdviseFeeChargingDetailsId =  T2.InitialAdviseFeeChargingDetailsId,  
  T1.InitialChargeType = T2.InitialChargeType,
  T1.DiscountId =  T2.DiscountId  ,
  T1.DiscountType = T2.DiscountType
  
 FROM @TempFeeModelForPolicyBusiness T1  
 INNER JOIN #tempIntialChargeFeeModels T2  
  ON T2.PolicyBusinessId = T1.PolicyBusinessId  
 WHERE T2.Fee2PolicyId = @MaxInitialFeeId  
END  
  
-- Update values for On-Going Fee  
IF ISNULL(@MaxOngoingFeeId, 0) > 0  
BEGIN  
 UPDATE @TempFeeModelForPolicyBusiness   
 SET T1.OngoingFeeModelId =  T2.OngoingFeeModelId, 
  T1.OngoingFeeModelTemplateId = T2.OngoingFeeModelTemplateId, 
  T1.OngoingAdviseFeeChargingDetailsId =  T2.OngoingAdviseFeeChargingDetailsId  ,
  T1.OngoingChargeType = T2.OngoingChargeType
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
