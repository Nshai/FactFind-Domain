SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[nio_SpCustomDashboardRetrieveMyPlans]
	@UserId INT,
	@TenantId INT
AS

 BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    DECLARE @DeletedStatus   VARCHAR(20) = 'Deleted',
            @CancelledStatus VARCHAR(20) = 'Cancelled';

	CREATE TABLE #Plans (PolicyBusinessId int PRIMARY KEY, StatusId int, Status varchar (50), ExpectedInitialAmount money, ReceivedInitialAmount money) 
	
	CREATE TABLE #LatestFeeStatus (FeeId int PRIMARY KEY, LatestFeeStatusId int);
	
	CREATE TABLE #LinkedFees (PolicyBusniessId INT, IsInitial INT, NetAmount money, VATAmount money, FeeId int);

	CREATE TABLE #PaySummary (PolicyId INT, LinkedFeeId INT, FeeId INT, TotalAmtReceived Money, TotalInitialCommRcvd money);
	CREATE UNIQUE CLUSTERED INDEX IX_PS_Policy_LinkedFee
    ON #PaySummary (PolicyId, LinkedFeeId, FeeId);

    -- 1. Base plans
    WITH PlanList AS (
        SELECT
            Pol.PolicyBusinessId,
            S.StatusId,
            S.Name AS [Status]
        FROM policymanagement..TPolicyBusiness Pol
        INNER JOIN CRM..TPractitioner Pr
            ON Pol.PractitionerId = Pr.PractitionerId
        INNER JOIN administration..TUser U
            ON U.CRMContactId = Pr.CRMContactId
        INNER JOIN policymanagement..TStatusHistory SH
            ON SH.PolicyBusinessId = Pol.PolicyBusinessId
           AND SH.CurrentStatusFg    = 1
        INNER JOIN policymanagement..TStatus S
            ON S.StatusId = SH.StatusId
        WHERE
            Pol.IndigoClientId = @TenantId
            AND Pr.IndClientId   = @TenantId
            AND U.IndigoClientId = @TenantId
            AND U.UserId         = @UserId
            AND S.IntelligentOfficeStatusType <> @DeletedStatus
    )
	INSERT #Plans
    SELECT
        PolicyBusinessId,
        StatusId,
        [Status],
        CAST(0 AS MONEY) AS ExpectedInitialAmount,
        CAST(0 AS MONEY) AS ReceivedInitialAmount
    FROM PlanList;


    -- 2. Latest fee status per FeeId
	INSERT #LatestFeeStatus
    SELECT
        fs.FeeId,
        MAX(fs.FeeStatusId) AS LatestFeeStatusId
    FROM policymanagement..TFeeStatus fs
    INNER JOIN policymanagement..TFee2Policy fp
        ON fp.FeeId = fs.FeeId
    INNER JOIN #Plans p
        ON p.PolicyBusinessId = fp.PolicyBusinessId
    GROUP BY fs.FeeId;

	-- LinkedFees
	INSERT #LinkedFees
	SELECT
           P.PolicyBusinessId AS PolicyBusniessId,
		   rft.IsInitial AS IsInitial,
		   f.NetAmount,
		   f.VATAmount,
		   F.FeeId as FeeId
        FROM #Plans p
        INNER JOIN policymanagement..TFee2Policy fp
            ON p.PolicyBusinessId = fp.PolicyBusinessId
        INNER JOIN policymanagement..TFee f
            ON fp.FeeId = f.FeeId
        INNER JOIN policymanagement..TAdviseFeeType aft
            ON f.AdviseFeeTypeId = aft.AdviseFeeTypeId
        INNER JOIN policymanagement..TRefAdviseFeeType rft
            ON aft.RefAdviseFeeTypeId = rft.RefAdviseFeeTypeId
        INNER JOIN #LatestFeeStatus lfs
            ON f.FeeId = lfs.FeeId
        INNER JOIN policymanagement..TFeeStatus fs
            ON fs.FeeId = lfs.FeeId
           AND fs.FeeStatusId = lfs.LatestFeeStatusId
		WHERE fs.[Status] <> @CancelledStatus
		AND f.IndigoClientId=@TenantId
			AND aft.TenantId=@TenantId

	
	INSERT #PaySummary
	SELECT
		ps.PolicyId,
		ps.LinkedFeeId,
		ps.FeeId,
		SUM(ps.AmountReceived + ps.VATAmountReceived) AS TotalAmtReceived,
		SUM(ps.InitialAmountReceived) AS TotalInitialCommRcvd
	FROM commissions..TPaymentSummary ps
	JOIN #Plans p ON ps.PolicyId = p.PolicyBusinessId
	WHERE ps.TenantId = @TenantId
	GROUP BY ps.PolicyId, ps.LinkedFeeId, ps.FeeId

	UNION ALL

	SELECT
		fp.PolicyBusinessId AS PolicyId,
		NULL AS LinkedFeeId,
		ps.FeeId,
		SUM(ps.AmountReceived + ps.VATAmountReceived) AS TotalAmtReceived,
		SUM(ps.InitialAmountReceived) AS TotalInitialCommRcvd
	FROM commissions..TPaymentSummary ps
	JOIN policymanagement..TFee2Policy fp ON ps.FeeId = fp.FeeId
	JOIN #Plans p ON fp.PolicyBusinessId = p.PolicyBusinessId
	WHERE ps.PolicyId IS NULL
		AND ps.TenantId = @TenantId
		AND ps.FeeId IN (SELECT FeeId FROM #LatestFeeStatus)
	GROUP BY fp.PolicyBusinessId, ps.FeeId;
		
    -- 3a. Update ExpectedInitialAmount
    ;WITH ExpFeeAlloc AS (
        -- Linked fees on latest plan
        SELECT
            MAX(p.PolicyBusinessId) AS PolicyBusinessId,
            SUM(lf.NetAmount + lf.VATAmount) / COUNT(p.PolicyBusinessId) AS Amount
        FROM #Plans p
		INNER JOIN #LinkedFees lf on lf.PolicyBusniessId=p.PolicyBusinessId
		WHERE
            lf.IsInitial = 1
		Group by lf.FeeId
    ),

    ExpCommission AS (
        SELECT
            p.PolicyBusinessId,
            SUM(ec.ExpectedAmount) AS Amount
        FROM #Plans p
        INNER JOIN policymanagement..TPolicyExpectedCommission ec
            ON p.PolicyBusinessId = ec.PolicyBusinessId
        INNER JOIN policymanagement..TRefCommissionType rct
            ON ec.RefCommissionTypeId = rct.RefCommissionTypeId
        WHERE rct.InitialCommissionFg = 1
        GROUP BY p.PolicyBusinessId
    )
    UPDATE p
    SET ExpectedInitialAmount = totals.Total
    FROM #Plans p
    INNER JOIN (
        SELECT PolicyBusinessId, SUM(Amount) AS Total
        FROM (
            SELECT PolicyBusinessId, Amount FROM ExpFeeAlloc
            UNION ALL
            SELECT PolicyBusinessId, Amount FROM ExpCommission
        ) AS combined
        GROUP BY PolicyBusinessId
    ) AS totals
      ON p.PolicyBusinessId = totals.PolicyBusinessId;
	  
	  
    -- 3b. Update ReceivedInitialAmount
    ;WITH RecClientFeeAlloc AS (
        SELECT
            MAX(p.PolicyBusinessId) AS PolicyBusinessId,
            SUM(ps.TotalAmtReceived) / COUNT(p.PolicyBusinessId) AS Amount
        FROM #Plans p
        INNER JOIN #LinkedFees lf On p.PolicyBusinessId=lf.PolicyBusniessId
        INNER JOIN #PaySummary ps
            ON lf.FeeId = ps.FeeId
        WHERE
            lf.IsInitial = 1
        GROUP BY lf.FeeId
    ),
    RecProvFeeAlloc AS (
        SELECT
            MAX(p.PolicyBusinessId) AS PolicyBusinessId,
			SUM(ps.TotalAmtReceived) / COUNT(p.PolicyBusinessId) AS Amount
        FROM #Plans p
        INNER JOIN #LinkedFees lf on lf.PolicyBusniessId=p.PolicyBusinessId
        INNER JOIN #PaySummary ps
            ON p.PolicyBusinessId = ps.PolicyId
           AND lf.FeeId = ps.LinkedFeeId
        WHERE
            lf.IsInitial = 1
        GROUP BY lf.FeeId
    ),
    RecCommission AS (
        SELECT
            p.PolicyBusinessId,
            SUM(ps.TotalInitialCommRcvd) AS Amount
        FROM #Plans p
        LEFT JOIN #PaySummary ps
            ON p.PolicyBusinessId = ps.PolicyId
           AND ps.LinkedFeeId IS NULL
        GROUP BY p.PolicyBusinessId
    )
    UPDATE p
    SET ReceivedInitialAmount = totals.Total
    FROM #Plans p
    INNER JOIN (
        SELECT PolicyBusinessId, SUM(Amount) AS Total
        FROM (
            SELECT PolicyBusinessId, Amount FROM RecClientFeeAlloc
            UNION ALL
            SELECT PolicyBusinessId, Amount FROM RecProvFeeAlloc
            UNION ALL
            SELECT PolicyBusinessId, Amount FROM RecCommission
        ) AS combined
        GROUP BY PolicyBusinessId
    ) AS totals
      ON p.PolicyBusinessId = totals.PolicyBusinessId;

    -- 4. Final aggregation
    SELECT
        p.StatusId,
        p.[Status],
        COUNT(*)                    AS Number,
        ISNULL(SUM(p.ExpectedInitialAmount),0.00) AS ExpectedGrossInitial,
        ISNULL(SUM(p.ReceivedInitialAmount),0.00) AS ReceivedGrossInitial
    FROM #Plans p
    GROUP BY p.StatusId, p.[Status]
    HAVING COUNT(*) > 0;

    -- 5. Cleanup
    DROP TABLE #Plans;
    DROP TABLE #LatestFeeStatus;
END;
GO