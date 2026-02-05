SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.spGetFeeById
    @FeeId INT,
    @TenantId INT
AS
    
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
    SELECT FeeId,
            SequentialRef,
            FeeType.RefAdviseFeeTypeId AS FeeCategory,
            FeeType.Name AS FeeType,
            FeeChargingType.RefAdviseFeeChargingTypeId AS FeeChargingType,
            paymentType.Name AS PaymentType,
            paidBy.IsPaidByProvider,
            (SELECT Status FROM TFeeStatus WHERE FeeStatusId IN(SELECT MAX(FeeStatusId) FROM TFeeStatus WHERE FeeId = fee.FeeId)) AS FeeStatus
    FROM TFee fee
    LEFT JOIN TAdvisePaymentType paymentType
        ON paymentType.AdvisePaymentTypeId = fee.AdvisePaymentTypeId
    LEFT JOIN TAdviseFeeType feeType 
        ON fee.AdviseFeeTypeId=feeType.AdviseFeeTypeId 
    LEFT JOIN TRefAdvisePaidBy paidBy
        ON paidBy.RefAdvisePaidById = paymentType.RefAdvisePaidById
    LEFT JOIN TAdviseFeeChargingDetails feeChargingDetails
        ON fee.AdviseFeeChargingDetailsId = feeChargingDetails.AdviseFeeChargingDetailsId
    LEFT JOIN TAdviseFeeChargingType feeChargingType
        ON feeChargingDetails.AdviseFeeChargingTypeId = feeChargingType.AdviseFeeChargingTypeId
    WHERE fee.IndigoClientId = @TenantId AND
            fee.FeeId = @FeeId