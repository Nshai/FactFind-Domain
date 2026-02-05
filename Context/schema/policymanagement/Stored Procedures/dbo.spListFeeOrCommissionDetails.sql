SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spListFeeOrCommissionDetails]
    @TenantId INT,
    @CommissionIds VARCHAR(MAX) = NULL,
    @FeeIds VARCHAR(MAX) = NULL
AS

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    SELECT
        pec.PolicyExpectedCommissionId AS 'CommissionId',
        refct.RefCommissionTypeId AS 'CommissionTypeId',
        refct.CommissionTypeName AS 'CommissionTypeName',
        NULL AS 'FeeId',
        NULL AS 'FeeTypeName',
        refct.InitialCommissionFg AS 'IsInitial',
        refct.RecurringCommissionFg AS 'IsRecurring',
        0 AS 'IsAdHocFee',
        NULL AS 'PaidBy',
        NULL AS 'Reference',
        pec.EndsOn AS 'ExpectedEndDate',
        NULL AS 'FeeStatus'
    FROM TPolicyExpectedCommission pec
    JOIN TRefCommissionType refct ON refct.RefCommissionTypeId = pec.RefCommissionTypeId
    JOIN TPolicyBusiness pb ON pb.PolicyBusinessId = pec.PolicyBusinessId
    WHERE
        @CommissionIds IS NOT NULL AND pec.PolicyExpectedCommissionId IN (SELECT value FROM STRING_SPLIT(@CommissionIds, ',')) AND
        pb.IndigoClientId = @TenantId
    
    UNION
    
    SELECT
        NULL AS 'CommissionId',
        NULL AS 'CommissionTypeId',
        NULL AS 'CommissionTypeName',
        f.FeeId AS 'FeeId',
        refaft.Name AS 'FeeTypeName',
        refaft.IsInitial AS 'IsInitial',
        refaft.IsRecurring AS 'IsRecurring',
        refaft.IsOneOff AS 'IsAdHocFee',
        refapb.Name AS 'PaidBy',
        f.SequentialRef AS 'Reference',
        NULL AS 'ExpectedEndDate',
        (SELECT Status FROM TFeeStatus WHERE FeeStatusId IN(SELECT MAX(FeeStatusId) FROM TFeeStatus WHERE FeeId = f.FeeId)) AS 'FeeStatus'
    FROM Tfee f
    LEFT JOIN TAdvisePaymentType apt ON apt.AdvisePaymentTypeId = f.AdvisePaymentTypeId
    LEFT JOIN TRefAdvisePaidBy refapb ON refapb.RefAdvisePaidById = apt.RefAdvisePaidById
    LEFT JOIN TAdviseFeeType aft ON aft.AdviseFeeTypeId = f.AdviseFeeTypeId
    LEFT JOIN TRefAdviseFeeType refaft ON refaft.RefAdviseFeeTypeId = aft.RefAdviseFeeTypeId
    WHERE
        @FeeIds IS NOT NULL AND f.FeeId IN (SELECT value FROM STRING_SPLIT(@FeeIds, ',')) AND
        f.IndigoClientId = @TenantId
