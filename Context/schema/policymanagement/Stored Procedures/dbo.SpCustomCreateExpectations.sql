SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomCreateExpectations]
	@DueDateTime datetime,
	@DueDateTimeUtc datetime,
	@TenantId INT = 0,
	@FeeId INT = 0,
	@StampUser varchar(255) = '0'
WITH RECOMPILE
AS

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

DECLARE @Date date = CAST(@DueDateTime as date),
	@DateUtc date = CAST(@DueDateTimeUtc as date)

Print Cast(@DateUtc as Varchar(200))

Declare @StampDateTime datetime = GETDATE()
DECLARE @ErrorMessage varchar(max)

-----------------------------------------------------------
-- Find ongoing active Fees that have an expectation that is due.
-----------------------------------------------------------
IF OBJECT_ID('tempdb..#Fees') IS NOT NULL DROP TABLE #Fees

SELECT
	F.IndigoClientId AS TenantId,
	F.FeeId, 
	RFCT.Name AS FeeType,
	ISNULL(F.FeePercentage, FCD.PercentageOfFee) AS FeePercentage,
	ISNULL(F.DiscountPercentage, 0) AS DiscountPercentage,
	CASE WHEN F.VATExempt = 1 THEN 0 ELSE ISNULL(RV.VATRate, 0) END AS VATRate,
	F.StartDate,
	FR.NextExpectationDate AS ExpectationDate,
	RecurringFrequencyId,
	CASE RecurringFrequencyId
		-- Monthly 
		WHEN 1 THEN 12
		-- Quarterly
		WHEN 2 THEN 4
		-- Bi- Annual
		WHEN 3 THEN 2
		-- Annual
		WHEN 4 THEN 1
	END AS MultiplierForAnnualisation,
	F.EndDate,
	RFCT.IsPercentageBased
INTO 
	#Fees
FROM 
	TFee F
	JOIN TFeeRecurrence FR on FR.FeeId = F.FeeId
	JOIN TAdviseFeeChargingDetails FCD on FCD.AdviseFeeChargingDetailsId = F.AdviseFeeChargingDetailsId
	JOIN TAdviseFeeChargingType FCT on FCT.AdviseFeeChargingTypeId = FCD.AdviseFeeChargingTypeId
	JOIN TRefAdviseFeeChargingType RFCT on FCT.RefAdviseFeeChargingTypeId = RFCT.RefAdviseFeeChargingTypeId
	JOIN TAdviseFeeType FT on F.AdviseFeeTypeId = FT.AdviseFeeTypeId
	JOIN TRefAdviseFeeType RFT on RFT.RefAdviseFeeTypeId = FT.RefAdviseFeeTypeId
	LEFT JOIN TRefVAT RV on F.RefVATId = RV.RefVATId
WHERE 
	-- We are only interested in recurring percentage based fees
	RFT.IsRecurring = 1
	-- Find all Fees that are still ongoing
	AND (F.EndDate IS NULL OR F.EndDate >= @Date)
	-- Find the Recurring Fees that are due 
	AND FR.NextExpectationDate <= @Date
	
	--Per Tenant
	AND (@TenantId = 0 OR (@TenantId != 0 AND F.IndigoClientId = @TenantId))
	--Per Fee
	AND (@FeeId = 0 OR (@FeeId != 0 AND F.FeeId = @FeeId))
	

-----------------------------------------------------------
-- Kill any duplicates
-- These are likely to be caused by bad TFeeRecurrence data
-----------------------------------------------------------
IF OBJECT_ID('tempdb..#Duplicates') IS NOT NULL DROP TABLE #Duplicates

SELECT FeeId
INTO #Duplicates
FROM #Fees
GROUP BY FeeId
HAVING COUNT(*) > 1

DELETE F
FROM
	#Fees F
	JOIN #Duplicates D ON D.FeeId = F.FeeId

-----------------------------------------------------------
-- Find Plans for these Fees
-----------------------------------------------------------
IF OBJECT_ID('tempdb..#FeeToPolicy') IS NOT NULL DROP TABLE #FeeToPolicy
SELECT DISTINCT
	F.FeeId,
	F2P.PolicyBusinessId
INTO
	#FeeToPolicy
FROM
	#Fees F
	JOIN TFee2Policy F2P ON F2P.FeeId = F.FeeId
WHERE f.IsPercentageBased = 1

-----------------------------------------------------------
-- Find Plan information
-----------------------------------------------------------
IF OBJECT_ID('tempdb..#Plans') IS NOT NULL DROP TABLE #Plans
SELECT DISTINCT
	PolicyBusinessId AS Id,
	CAST(NULL AS money) AS Valuation,
	CAST(0 AS money) AS RegularAnnualisedContribution,
	CAST(0 AS money) AS LumpSumContribution,
	CAST(0 AS money) AS TransferContribution,
	CAST(0 AS money) AS TotalSingleContribution
INTO 
	#Plans
FROM	
	#FeeToPolicy;

--------------------------------------------------------------
-- Work out the value for each plan
-- We're just taking the latest Plan Valuation Record here on the basis of Id, this is not necessarily correct,
-- but that's how the code was originally designed to work
--------------------------------------------------------------
IF OBJECT_ID('tempdb..#LastValuation') IS NOT NULL DROP TABLE #LastValuation
SELECT PolicyBusinessId, MAX(PlanValuationId) AS Id
INTO #LastValuation
FROM 
	TPlanValuation PV
	JOIN #Plans P ON P.Id = PV.PolicyBusinessId
GROUP BY PolicyBusinessId


-- build list of values for each 
IF OBJECT_ID('tempdb..#PlanValues') IS NOT NULL DROP TABLE #PlanValues
SELECT
	L.PolicyBusinessId,
	ISNULL(PV.PlanValue, 0) AS Amount
INTO 
	#PlanValues
FROM 
	#LastValuation L
	JOIN TPlanValuation PV ON PV.PlanValuationId = L.Id

--------------------------------------------------------------
-- Update valuations
--------------------------------------------------------------
UPDATE A
SET Valuation = PV.Amount
FROM
	#Plans A
	JOIN #PlanValues PV ON PV.PolicyBusinessId = A.Id

--------------------------------------------------------------
-- Find values from Funds (we fall back to these)
-- No assets are included here, this is how the original code worked.
--------------------------------------------------------------
IF OBJECT_ID('tempdb..#FundValues') IS NOT NULL DROP TABLE #FundValues
SELECT PBF.PolicyBusinessId, SUM(PBF.CurrentUnitQuantity * PBF.CurrentPrice) AS Amount
INTO
	#FundValues
FROM 
	TPolicyBusinessFund PBF
	JOIN #Plans P ON P.Id = PBF.PolicyBusinessId
WHERE
	CurrentUnitQuantity IS NOT NULL AND CurrentPrice IS NOT NULL
GROUP BY
	PBF.PolicyBusinessId

--------------------------------------------------------------
-- Use fund values if a plan value was not found.
--------------------------------------------------------------
UPDATE A
SET Valuation = FV.Amount
FROM
	#Plans A
	JOIN #FundValues FV ON FV.PolicyBusinessId = A.Id
WHERE
	A.Valuation IS NULL
	AND FV.Amount != 0

--------------------------------------------------------------
-- Find Contributions for each plan
--------------------------------------------------------------
IF OBJECT_ID('tempdb..#RegularAnnualised') IS NOT NULL DROP TABLE #RegularAnnualised
-- These are Regular Annualised Contributions
SELECT
	PMI.PolicyBusinessId,
	SUM(PMI.Amount * 
		CASE F.RefFrequencyId  
		  WHEN 1 THEN 52 -- weekly
		  WHEN 2 THEN 26 -- fortnightly
		  WHEN 3 THEN 13 -- four weekly
		  WHEN 4 THEN 12 -- monthly
		  WHEN 5 THEN 4  -- quarterly
		  WHEN 6 THEN 3  -- termly
		  WHEN 7 THEN 2  -- half yearly
		  WHEN 8 THEN 1  -- annually
		END   
	) AS Amount
INTO
	#RegularAnnualised
FROM 
	#Plans P
	JOIN TPolicyMoneyIn PMI ON PMI.PolicyBusinessId = P.Id
	JOIN TRefFrequency F on F.RefFrequencyId = PMI.RefFrequencyId  
WHERE
	F.FrequencyName != 'Single'
	AND PMI.Amount != 0
	-- Consider only those contribution which have IsOnGoingFee = 1 
	AND PMI.IsOngoingFee = 1  
	AND PMI.RefContributionTypeId = 1 -- Regular
	-- Only consider contributions that are active
	AND @Date >= pmi.StartDate 
	AND (@Date <= pmi.stopdate OR PMI.StopDate IS NULL)
GROUP BY
	PolicyBusinessId

IF OBJECT_ID('tempdb..#LumpSum') IS NOT NULL DROP TABLE #LumpSum
-- These are Lump Sum Amounts.
SELECT 
	PolicyBusinessId,
	RefContributionTypeId,
	SUM(PMI.Amount) AS Amount
INTO
	#LumpSum
FROM 
	#Plans P
	JOIN TPolicyMoneyIn PMI ON PMI.PolicyBusinessId = P.Id
WHERE
	PMI.RefFrequencyId = 10
	AND PMI.RefContributionTypeId != 1 -- Regular
	AND PMI.IsOngoingFee = 1
	AND PMI.Amount != 0
GROUP BY
	PolicyBusinessId,
	RefContributionTypeId

IF OBJECT_ID('tempdb..#TotalLumpSum') IS NOT NULL DROP TABLE #TotalLumpSum
-- Total single contribution for each plan
SELECT
	PolicyBusinessId, SUM(Amount) AS Amount
INTO
	#TotalLumpSum
FROM
	#LumpSum
GROUP BY
	PolicyBusinessId

--------------------------------------------------------------
-- Update plans with contribution amounts
--------------------------------------------------------------
UPDATE P
SET RegularAnnualisedContribution = RA.Amount
FROM
	#Plans P
	JOIN #RegularAnnualised RA ON RA.PolicyBusinessId = P.Id

UPDATE P
SET TotalSingleContribution = TLS.Amount
FROM
	#Plans P
	JOIN #TotalLumpSum TLS ON TLS.PolicyBusinessId = P.Id

UPDATE P
SET LumpSumContribution = LS.Amount
FROM
	#Plans P
	JOIN #LumpSum LS ON LS.PolicyBusinessId = P.Id
WHERE
	LS.RefContributionTypeId = 2 -- LumpSum

UPDATE P
SET TransferContribution = LS.Amount
FROM
	#Plans P
	JOIN #LumpSum LS ON LS.PolicyBusinessId = P.Id
WHERE
	LS.RefContributionTypeId = 3 -- Transfer

--------------------------------------------------------------
-- Work out the amounts that will be used to calculate the 
-- expectations, this is dependent on Fee Type
--------------------------------------------------------------
IF OBJECT_ID('tempdb..#CalculationAmounts') IS NOT NULL DROP TABLE #CalculationAmounts
CREATE TABLE #CalculationAmounts (FeeId int, PolicyBusinessId int, Amount decimal(18,2))

--------------------------------------------------------------
-- % OF FUM/AUM
--------------------------------------------------------------
INSERT INTO #CalculationAmounts
SELECT
	F.FeeId, P.Id, 
	-- For % OF FUM/AUM that do not have a valuation,
	-- we use contributions for these instead.
	ISNULL(P.Valuation, P.RegularAnnualisedContribution + P.TotalSingleContribution)
FROM
	#Fees F
	JOIN #FeeToPolicy F2P ON F2P.FeeId = F.FeeId
	JOIN #Plans P ON P.Id = F2P.PolicyBusinessId
WHERE
	F.FeeType = '% of FUM/AUM' 

--------------------------------------------------------------
-- % of Contribution
--------------------------------------------------------------
INSERT INTO #CalculationAmounts
SELECT
	F.FeeId, P.Id,
	CASE F.FeeType
		WHEN '% of All Investment Contribution' THEN P.RegularAnnualisedContribution + P.TotalSingleContribution
		WHEN '% of Regular Contribution' THEN P.RegularAnnualisedContribution
		WHEN '% of Lump Sum Contribution' THEN P.LumpSumContribution
		WHEN '% of Transfer Contribution' THEN P.TransferContribution
	END
FROM
	#Fees F
	JOIN #FeeToPolicy F2P ON F2P.FeeId = F.FeeId
	JOIN #Plans P ON P.Id = F2P.PolicyBusinessId
WHERE
	F.FeeType != '% of FUM/AUM'

--------------------------------------------------------------
-- Calculate the expectation amounts.
--------------------------------------------------------------
IF OBJECT_ID('tempdb..#Expectations') IS NOT NULL DROP TABLE #Expectations
SELECT
	A.FeeId, A.PolicyBusinessId, F.TenantId,
	F.VATRate, F.ExpectationDate, F.DiscountPercentage,
	A.Amount AS CalculationAmount,
	-- Initial expectation is based on the Calculated Plan amount, FeePercentage and the annualisation multiplier
	CAST((A.Amount * (F.FeePercentage) / 100) / F.MultiplierForAnnualisation AS decimal(18,2)) AS ExpectationAmount,
	CAST(0 AS decimal(18,2)) AS DiscountAmount,
	CAST(0 AS decimal(18,2)) AS TotalAmount,
	CAST(0 AS decimal(18,2)) AS NetAmount,
	CAST(0 AS decimal(18,2)) AS VatAmount
INTO
	#Expectations
FROM
	#CalculationAmounts A
	JOIN #Fees F ON F.FeeId = A.FeeId

--------------------------------------------------------------
-- Apply any discounts.
--------------------------------------------------------------
UPDATE #Expectations
SET
	DiscountAmount = (DiscountPercentage / 100) * ExpectationAmount
WHERE
	DiscountPercentage != 0

--------------------------------------------------------------
-- Work out Net amount
--------------------------------------------------------------
UPDATE #Expectations
SET NetAmount = ExpectationAmount - DiscountAmount

--------------------------------------------------------------
-- Work out vat amounts
--------------------------------------------------------------
UPDATE #Expectations
SET VatAmount = NetAmount * (VatRate / 100)

--------------------------------------------------------------
-- Work out total amounts
--------------------------------------------------------------
UPDATE #Expectations
SET TotalAmount = NetAmount + VatAmount

--------------------------------------------------------------
-- Check that we've got as many expectations as we've got Fees
--------------------------------------------------------------
DECLARE @FeeCount int, @ExpectationCount int
SELECT @FeeCount = COUNT(DISTINCT FeeId) FROM #FeeToPolicy
SELECT @ExpectationCount = COUNT(1) FROM #Expectations

IF (@ExpectationCount < @FeeCount) BEGIN
	RAISERROR('Number of Expectations does not match Fee Count', 16, 1)
	RETURN;
END

--------------------------------------------------------------
-- Find the next expectation date for the Fees.
-- We night need to adjust some of the dates. This is 
-- because successive months have a different number of days.
-- E.g. a Fee starting 31-Jan will then have expectations on
-- 28-Feb, 31-Mar, 30-Apr etc. If we just add 1 month onto the
-- expectation date for Feb that gives us 28-Feb, 28-Mar, 28-Apr
--------------------------------------------------------------
IF OBJECT_ID('tempdb..#Dates') IS NOT NULL DROP TABLE #Dates
SELECT
	FeeId,
	StartDate,
	DAY(StartDate) AS StartDay,
	--If start date is in the future or current date is a start date next due date should be the start date
	
	-- Calculate the next date on the basis of frequency.
	(CASE RecurringFrequencyId
		-- Monthly
		WHEN 1 THEN DATEADD(month, 1, ExpectationDate)
		-- Quarterly
		WHEN 2 THEN DATEADD(month, 3, ExpectationDate)
		-- BiAnnual
		WHEN 3 THEN DATEADD(month, 6, ExpectationDate)
		-- Annual
		WHEN 4 THEN DATEADD(year, 1, ExpectationDate)
	END) AS NextDate
INTO
	#Dates
FROM
	#Fees

-- Adjust our expectation date slightly
-- We're moving the date nearer to the end of month.
-- E.g. if the start date is 31-Jan and our current date is 28-Feb
-- we need to make sure that the next date is 31-Mar (not 28-Mar)
UPDATE #Dates
SET NextDate = 				
		CASE 
			--If the DAY of the Start date IS the same as the DAY of teh END OF THE MONTH, then return the END OF THE MONTH of the next date
			--Unless for Feb the last day could be leap year so just account for that too
			WHEN MONTH(StartDate) = 2 And  Day(StartDate) in(28,29) THEN EOMONTH(NextDate) 
			WHEN MONTH(StartDate) != 2 AND Day(StartDate) = DAY(EOMonth(StartDate)) THEN EOMONTH(NextDate) 
			-- Not end of any month, but the day of the next date is less than the day of teh start date , EG: 30 Jan, 28 Feb to 30 March !!!
			WHEN MONTH(NextDate) != 2 AND DAY(StartDate) > Day(NextDate) THEN Cast(cast(Day(StartDate) as varchar(5)) + ' ' + Convert(char(3), NextDate, 0) + ' ' + cast(YEAR(NextDate) as varchar(5)) as Date) 
			--Otherwise just reurn the next Date
			ELSE NextDate 
		END 
			
		
--------------------------------------------------------------
-- Insert the expectations - this is NOT Idempotent - it inserts duplicates if the job is run multiple times
--------------------------------------------------------------
BEGIN TRANSACTION
BEGIN TRY

	INSERT INTO TExpectations (
		[PolicyBusinessId],
		[FeeId],
		[Date],
		[NetAmount],
		[TotalAmount],
		[CalculatedAmount],
		[TenantId],
		[IsManual])
	OUTPUT
		INSERTED.ExpectationsId,
		INSERTED.PolicyBusinessId,
		INSERTED.FeeId,
		INSERTED.Date,
		INSERTED.NetAmount,
		INSERTED.TotalAmount,
		INSERTED.CalculatedAmount,
		INSERTED.TenantId,
		INSERTED.ConcurrencyId,
		INSERTED.[IsManual],
		'C',
		@StampDateTime,
		@StampUser
	INTO TExpectationsAudit (
		[ExpectationsId], 
		[PolicyBusinessId], 
		[FeeId], 
		[Date], 
		[NetAmount], 
		[TotalAmount], 
		[CalculatedAmount], 
		[TenantId], 
		[ConcurrencyId],
		[IsManual], 
		[StampAction], 
		[StampDateTime], 
		[StampUser])
	SELECT DISTINCT
        A.PolicyBusinessId,
        A.FeeId,
        A.ExpectationDate,
        A.NetAmount,
        A.TotalAmount,
        A.CalculationAmount,
        A.TenantId,
        0
    FROM
        #Expectations A
            -- DO NOT INSERT DUPLICATES FROM THE JOB !!!!
        LEFT JOIN TExpectations B ON     
            A.TenantId = B.TenantId AND    
            A.PolicyBusinessId = B.PolicyBusinessId AND
            A.FeeId = B.FeeID AND
            B.[IsManual] = 0 AND
            cast(A.ExpectationDate as Date) = cast(B.[Date] as Date)
        WHERE B.ExpectationsId IS NULL
		




	-- -------------------------------------------------------------
	-- Add MOvements
	/*
	Add Mvt with Todays date, use Net Amt and VAT Amt from Tfee for Fixed Price and Fixed Price Range fees 
	Add Mvt with Todays date, use Expected amount calculated for the % Fees in TExpectations table  "
	*/
	-- -------------------------------------------------------------

	Declare @FixedPrice varchar(20) = 'Fixed Price'
	Declare @FixedPriceRange varchar(20) = 'Fixed price-Range'


	--Check Tenant Preferences	
	Declare  @Preference_Name varchar(20) = 'GenerateMovements'

	IF OBJECT_ID('tempdb..#Tenants') IS NOT NULL DROP TABLE #Tenants
	Create Table #Tenants(TenantId INT)


	--Get whichever tenants have The Tenant Preference 
	Insert into #Tenants 
	Select Distinct IndigoClientId 
	from administration..TIndigoClientPreference
	WHERE PreferenceName = @Preference_Name
	AND (ISNULL(@TenantId, 0) = 0 OR (ISNULL(@TenantId, 0) != 0 AND IndigoClientId = @TenantId))

	Create clustered index IDX_TenantId ON #tenants(TenantId)


	If not exists (Select TenantId from #Tenants) 
	BEGIN
		print 'ZERO tenants configured'
	END

	IF OBJECT_ID('tempdb..#AdviserAndCRABanding') IS NOT NULL DROP TABLE #AdviserAndCRABanding
	Create Table #AdviserAndCRABanding(IndigoClientId INT, BandingTemplateId INT, PractitionerId INT, CRAPractitionerId INT, BandingRate decimal(10,2))

	INSERT INTO #AdviserAndCRABanding
	SELECT Rate.IndigoClientId, Rate.BandingTemplateId, Rate.PractitionerId, rate.CRAPractitionerId, rate.BandingRate
	FROM commissions..VwAdviserAndCRABanding rate
	INNER JOIN #Tenants t ON rate.IndigoClientId = t.TenantId

	-- In orde rnot to insert duplicates for a given Day we must first delete them .
	Delete M from TMovement M
	INNER JOIN TFeeRecurrence FR ON M.FeeId = FR.FeeId
	INNER JOIN policymanagement..TFee A ON FR.FeeId = A.FeeId
	INNER join policymanagement..VwFeeChargingType E ON E.TenantId = A.IndigoClientId and A.FeeId = E.FeeId -- NO Charging Type then NO Fee MOVEMENT !!!! BITCHES !!!!
	INNER JOIN #Tenants t ON M.TenantId = t.TenantId -- ONLY CONFIGURED TENANTS
	WHERE M.IncomeTypeName = E.Name
	AND M.IsRecurring = 1 
	And Cast(M.MovementDateTime as date) = Cast(@DateUtc as date)
	and PolicyBusinessId IS NULL
	and PayAdjustId IS NULL
	--Per Tenant
	AND (@TenantId = 0 OR (@TenantId != 0 AND A.IndigoClientId = @TenantId))
	--Per Fee
	AND (@FeeId = 0 OR (@FeeId != 0 AND A.FeeId = @FeeId))

	
	
	--GET FEES MOFOS!
	IF OBJECT_ID('tempdb..#MovementFees') IS NOT NULL DROP TABLE #MovementFees

	CREATE TABLE #MovementFees(TenantId INT, FeeId INT, LinkedToPolicyBusinessId Int null, IsPayawayReceived INT default(0), SellingAdviserId Int, RecevingAdviserId INT, 
	IncomeTypeName varchar(200), IsRecurring Int, IsPaidByProvider Int, MaxTriggerTimeStamp datetime, FeeDate datetime, CanSnapShot int default(0), HasMovement int default (0),
	BandingRate decimal (10,2) default(0), GrossAmount money default(0), VATAmount money default(0),   IntroducerAmount money default(0), ClientAmount money default(0), AdviserAmount money default(0), NetAmount money default(0), 
	PayawayReceivedPercentage decimal (10,2) default(0), Introducers varchar(200), Clients varchar(200) , Advisers varchar(200)
	
	)


	--Insert Fixed Price and Fixed Price Range (from Fee Record)
	insert into #MovementFees
	(TenantId, FeeId, SellingAdviserId, RecevingAdviserId,  IncomeTypeName, IsRecurring, IsPaidByProvider, 
	MaxTriggerTimeStamp, FeeDate, CanSnapShot, HasMovement, BandingRate, GrossAmount, VATAmount)

	Select distinct A.IndigoClientId, A.FeeId, Rate.PractitionerId, rate.CRAPractitionerId, E.Name, D.IsRecurring, G.IsPaidByProvider,
		@DateUtc, 
		A.StartDate ,
		1, 0, rate.BandingRate, 
			
		--Fee Net and Vat amounts
		ISNULL(A.NetAmount, 0),
		ISNULL(A.VATAmount, 0)
	

	FROM TFeeRecurrence FR
	INNER JOIN policymanagement..TFee A ON FR.FeeId = A.FeeId
	INNER JOIN #Tenants t ON A.IndigoClientId = t.TenantId -- ONLY CONFIGURED TENANTS
	
	INNER JOIN policymanagement..TFeeStatus B ON A.FeeId = B.FeeID
	INNER JOIN policymanagement..TAdviseFeeType C on A.AdviseFeeTypeId = C.AdviseFeeTypeId
	INNER JOIN policymanagement..TRefAdviseFeeType D ON c.RefAdviseFeeTypeId = d.RefAdviseFeeTypeId
	INNER JOIN policymanagement..VwFeeChargingType E ON E.TenantId = A.IndigoClientId and A.FeeId = E.FeeId -- NO Charging Type then NO Fee MOVEMENT !!!! BITCHES !!!!
	INNER JOIN policymanagement..TAdvisePaymentType F ON A.AdvisePaymentTypeId = F.AdvisePaymentTypeId
	INNER JOIN policymanagement..TRefAdvisePaidBy G On F.RefAdvisePaidById = G.RefAdvisePaidById
	INNER JOIN policymanagement..TFeeRetainerOwner own ON A.IndigoClientId = own.IndigoClientId AND A.FeeId = own.FeeId 
	INNER JOIN #AdviserAndCRABanding rate ON rate.IndigoClientID = A.IndigoClientId AND  own.BandingTemplateId = rate.BandingTemplateId -- this tells us exactly which rate to use and if a CRA is going to ovverride it
	WHERE Convert(date, FR.NextExpectationDate) = @Date
	AND E.Name IN (@FixedPrice, @FixedPriceRange) 
	--Per Tenant
	AND (@TenantId = 0 OR (@TenantId != 0 AND A.IndigoClientId = @TenantId))
	--Per Fee
	AND (@FeeId = 0 OR (@FeeId != 0 AND A.FeeId = @FeeId))



	--Are any Fees linked to Plans 
	Update A
		Set A.LinkedToPolicyBusinessId = B.PolicyBusinessId
	From #MovementFees A
	Inner join 
	(
		Select A.FeeId, Max(PolicyBusinessId) as PolicyBusinessId from #MovementFees A
		Inner join policymanagement..TFee2Policy B ON A.FeeId = B.FeeId
		group by A.FeeId
	) B ON A.FeeId = B.FeeId


	--Insert  other types not fixed price (from expectations)
	insert into #MovementFees
	(TenantId, FeeId, LinkedToPolicyBusinessId, SellingAdviserId, RecevingAdviserId,  IncomeTypeName, IsRecurring, IsPaidByProvider, 
	MaxTriggerTimeStamp, FeeDate, CanSnapShot, HasMovement, BandingRate, GrossAmount, VATAmount)

	Select distinct A.IndigoClientId, A.FeeId, Ex.PolicyBusinessId, Rate.PractitionerId, rate.CRAPractitionerId, E.Name, D.IsRecurring, G.IsPaidByProvider,
		@DateUtc, 
		A.StartDate ,
		1, 0, rate.BandingRate, 
			
		--Fee Net and Vat amounts
		ISNULL(EX.NetAmount, 0),

		ISNULL(EX.VatAmount, 0)

	FROM TFeeRecurrence FR
	INNER JOIN policymanagement..TFee A ON FR.FeeId = A.FeeId
	INNER JOIN #Tenants t ON A.IndigoClientId = t.TenantId -- ONLY CONFIGURED TENANTS
	
	INNER JOIN 
	(
		Select Ex.tenantId,  ex.FeeId, Ex.PolicyBusinessId, Sum(ex.NetAmount) as NetAmount, Sum(ex.TotalAmount) - Sum(ex.NetAmount) as VatAmount
		FROM TFeeRecurrence FR
		INNER JOIN policymanagement..TFee A ON FR.FeeId = A.FeeId
		INNER JOIN #Tenants t ON A.IndigoClientId = t.TenantId -- ONLY CONFIGURED TENANTS
		INNER JOIN policymanagement..TExpectations ex ON A.FeeId = ex.FeeId
		WHERE cast(FR.NextExpectationDate as date) = @Date	
		AND  cast(EX.[Date] as Date) = @Date
		--Per Tenant
		AND (@TenantId = 0 OR (@TenantId != 0 AND A.IndigoClientId = @TenantId))
		--Per Fee
		AND (@FeeId = 0 OR (@FeeId != 0 AND A.FeeId = @FeeId))
		GROUP BY ex.tenantId, ex.FeeId, Ex.PolicyBusinessId
	)  Ex ON  A.FeeId = ex.FeeId
	INNER JOIN policymanagement..VwFeeCurrentStatus B ON A.FeeId = B.FeeID
	INNER JOIN policymanagement..TAdviseFeeType C on A.AdviseFeeTypeId = C.AdviseFeeTypeId
	INNER JOIN policymanagement..TRefAdviseFeeType D ON c.RefAdviseFeeTypeId = d.RefAdviseFeeTypeId
	INNER JOIN policymanagement..VwFeeChargingType E ON E.TenantId = A.IndigoClientId and A.FeeId = E.FeeId -- NO Charging Type then NO Fee MOVEMENT !!!! BITCHES !!!!
	INNER JOIN policymanagement..TAdvisePaymentType F ON A.AdvisePaymentTypeId = F.AdvisePaymentTypeId
	INNER JOIN policymanagement..TRefAdvisePaidBy G On F.RefAdvisePaidById = G.RefAdvisePaidById
	INNER JOIN policymanagement..TFeeRetainerOwner own ON A.IndigoClientId = own.IndigoClientId AND A.FeeId = own.FeeId 
	INNER JOIN #AdviserAndCRABanding rate ON rate.IndigoClientID = A.IndigoClientId AND  own.BandingTemplateId = rate.BandingTemplateId -- this tells us exactly which rate to use and if a CRA is going to override it
	WHERE cast(FR.NextExpectationDate as date) = @Date
	AND E.Name NOT IN (@FixedPrice, @FixedPriceRange) -- Other Types
	--Per Tenant
	AND (@TenantId = 0 OR (@TenantId != 0 AND A.IndigoClientId = @TenantId))
	--Per Fee
	AND (@FeeId = 0 OR (@FeeId != 0 AND A.FeeId = @FeeId))


	
	
	Update A
	Set 
		A.IntroducerAmount = (( ISNULL(FeeIntroducerSplits.SplitPercent, 0) * A.GrossAmount) / 100 ),
		A.Introducers = FeeIntroducerSplits.Introducers,
		A.ClientAmount = (( ISNULL(FeeClientSplits.SplitPercent, 0) * A.GrossAmount) / 100),
		A.Clients = FeeClientSplits.clients,
		A.AdviserAmount = (( ISNULL(FeeAviserSplits.SplitPercent, 0) * A.GrossAmount) / 100 ),
		A.Advisers = FeeAviserSplits.Advisers
	FROM #MovementFees A
	LEFT JOIN
	(
		--Fee INtroducer Splits
		Select A.FeeId, IncomeTypeName, Sum(B.SplitPercent) AS splitPercent , 
			MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Introducers 
		FROM #MovementFees A
		Inner Join commissions..TSplit B ON A.TenantId = B.IndClientId and A.FeeId = B.FeeId
		inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId
		inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
	
		Where A.CanSnapShot = 1
		AND ((A.IsRecurring = 0) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
		AND C.RefIntroducerTypeId IS NOT NULL
		and A.IsPaidByProvider = 0
		Group by A.FeeId , A.IncomeTypeName

	) FeeIntroducerSplits ON A.FeeId = FeeIntroducerSplits.FeeId
	LEFT JOIN
	(	
		--Fee Client Splits
		Select A.FeeId, IncomeTypeName, Sum(B.SplitPercent) AS splitPercent , 
			MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Clients 
		FROM #MovementFees A
		Inner Join commissions..TSplit B ON A.TenantId = B.IndClientId and A.FeeId = B.FeeId
		inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId
		inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
	
		Where A.CanSnapShot = 1
		AND ((A.IsRecurring = 0 ) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
		AND C.ClientFg = 1
		and A.IsPaidByProvider = 0
		Group by A.FeeId , A.IncomeTypeName
	) FeeClientSplits ON A.FeeId = FeeClientSplits.FeeId
	LEFT JOIN
	(
	--Fee Client Splits
		--Fee Client Splits
		Select A.FeeId, IncomeTypeName, Sum(B.SplitPercent) AS splitPercent , 
			MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Advisers 
		FROM #MovementFees A
		Inner Join commissions..TSplit B ON A.TenantId = B.IndClientId and A.FeeId = B.FeeId
		inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId
		inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
	
		Where A.CanSnapShot = 1
		AND ((A.IsRecurring = 0 ) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
		and  C.PractitionerFG = 1
		and A.IsPaidByProvider = 0
		AND ISNULL(B.PartnershipType,0) IN (0,1)
		Group by A.FeeId , IncomeTypeName
	) FeeAviserSplits ON A.FeeId = FeeAviserSplits.FeeId
	Where A.IsPaidByProvider = 0 -- ONLY CLIENT PAID FEES USE FEE SPLITS
	and  A.CanSnapShot = 1

	
	
	-- provider PAID FEES USE THE  plan split
	Update A
	Set 
		A.IntroducerAmount = (( ISNULL(FeeIntroducerSplits.SplitPercent, 0) * A.GrossAmount) / 100 ),
		A.Introducers = FeeIntroducerSplits.Introducers,
		A.ClientAmount = (( ISNULL(FeeClientSplits.SplitPercent, 0) * A.GrossAmount) / 100),
		A.Clients = FeeClientSplits.clients,
		A.AdviserAmount = (( ISNULL(FeeAdviserSplits.SplitPercent, 0) * A.GrossAmount) / 100 ),
		A.Advisers = FeeAdviserSplits.Advisers
	FROM #MovementFees A
	LEFT JOIN
	(
		--Fee INtroducer Splits
		Select A.FeeId, IncomeTypeName, Sum(B.SplitPercent) AS splitPercent , 
			MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Introducers 
		FROM #MovementFees A	
		Inner Join commissions..TSplit B ON A.TenantId = B.IndClientId and A.LinkedToPolicyBusinessId = B.PolicyId -- fees linked to policy Splits
		inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId
		inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
		Where A.CanSnapShot = 1
		AND ((A.IsRecurring = 0 ) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
		AND C.RefIntroducerTypeId IS NOT NULL
		and A.IsPaidByProvider = 1
		Group by A.FeeId , A.IncomeTypeName
	) FeeIntroducerSplits ON A.FeeId = FeeIntroducerSplits.FeeId
	LEFT JOIN
	(	
		--Fee Client Splits
		Select A.FeeId, IncomeTypeName, Sum(B.SplitPercent) AS splitPercent , 
			MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Clients 
		FROM #MovementFees A	
		Inner Join commissions..TSplit B ON A.TenantId = B.IndClientId and A.LinkedToPolicyBusinessId = B.PolicyId -- fees linked to policy Splits
		inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId
		inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
		Where A.CanSnapShot = 1
		AND ((A.IsRecurring = 0 ) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
		AND C.ClientFg = 1
		and A.IsPaidByProvider = 1
		Group by A.FeeId , A.IncomeTypeName
	) FeeClientSplits ON A.FeeId = FeeClientSplits.FeeId
	LEFT JOIN
		(
		--Fee Adviser Splits
		Select A.FeeId, IncomeTypeName, Sum(B.SplitPercent) AS splitPercent , 
			MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Advisers 
		FROM #MovementFees A	
		Inner Join commissions..TSplit B ON A.TenantId = B.IndClientId and A.LinkedToPolicyBusinessId = B.PolicyId -- fees linked to policy Splits
		inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId
		inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
		Where A.CanSnapShot = 1
		AND ((A.IsRecurring = 0 ) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
		AND C.PractitionerFG = 1
		and A.IsPaidByProvider = 1
		AND ISNULL(B.PartnershipType,0) IN (0,1)
		Group by A.FeeId, IncomeTypeName 
	) FeeAdviserSplits ON A.FeeId = FeeAdviserSplits.FeeId
	INNER join policymanagement..TFee2Policy ftp ON A.FeeId = ftp.FeeId  --  FEES LINKED TO PLANS use the plansplit
	Where A.IsPaidByProvider = 1
	and  A.CanSnapShot = 1


	Update A
	Set GrossAmount = ISNULL(GrossAmount, 0),
		VATAmount = ISNULL(VATAmount, 0),
		IntroducerAmount = ISNULL(IntroducerAmount, 0),
		ClientAmount = ISNULL(ClientAmount, 0),
		AdviserAmount = ISNULL(AdviserAmount, 0),
		NetAmount = (ISNULL(GrossAmount, 0) - ISNULL(IntroducerAmount, 0) - ISNULL(ClientAmount, 0) - ISNULL(AdviserAmount, 0)) * ISNULL(A.BandingRate, 0) / 100
		From #MovementFees A
		where A.CanSnapShot = 1


	
	--Client paid Fees PawayReceived
	INSERT INTO #MovementFees
	(	TenantId , FeeId , IsPayawayReceived, SellingAdviserId , RecevingAdviserId ,  IncomeTypeName , IsRecurring, IsPaidByProvider , MaxTriggerTimeStamp, FeeDate , CanSnapShot , HasMovement ,
		 GrossAmount, VATAmount , NetAmount , 
		PayawayReceivedPercentage , Advisers
	)
	Select
		A.TenantId, A.FeeId, 1, ClientPaidAdviserSplitsReceived.PractitionerId, ClientPaidAdviserSplitsReceived.CRAPractitionerId,  ClientPaidAdviserSplitsReceived.IncomeTypeName, A.IsRecurring, A.IsPaidByProvider, A.MaxTriggerTimeStamp, A.FeeDate, A.CanSnapShot, A.HasMovement,
		0, 0, --Gross and Vat are zero for payaways received
		NetAmount = ((ISNULL(ClientPaidAdviserSplitsReceived.SplitPercent, 0) * A.GrossAmount) / 100 ), 
		PayawayReceivedPercentage = ISNULL(ClientPaidAdviserSplitsReceived.SplitPercent, 0),
		ISNULL(ClientPaidAdviserSplitsReceived.Advisers, '')

	FROM #MovementFees A
	INNER JOIN
	(
		--Policy Adviser Splits - Treat Banding Partner ship and normal payway as the same (CDV using 100% banding on 100% Banding partnership is the same as a 100% split)
		Select A.FeeId, cra.PractitionerId, CRA.CRAPractitionerId ,IncomeTypeName, ISNULL(Sum(B.SplitPercent), 0) AS SplitPercent ,
			MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Advisers  
		FROM #MovementFees A
		Inner Join commissions..TSplit B ON A.TenantId = B.IndClientId AND  A.FeeId = B.FeeId
		inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId	
		inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
		Inner join CRM..TPractitioner E ON B.IndClientId = E.IndClientId AND B.PaymentEntityCRMId = E.CRMContactId
		INNER JOIN #AdviserAndCRABanding cra ON A.TenantId =  cra.IndigoClientId AND  E.PractitionerId =  cra.PractitionerId -- this tells us exactly which rate to use and if a CRA is going to ovverride it
		Where A.CanSnapShot = 1
		AND ((A.IsRecurring = 0) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
		and  C.PractitionerFG = 1
		and ISNULL(B.PartnershipType,0) IN (0,1)
		and A.IsPaidByProvider = 0
		Group by A.FeeId, cra.PractitionerId, CRA.CRAPractitionerId, PaymentEntityCRMId , IncomeTypeName
	) ClientPaidAdviserSplitsReceived ON A.FeeId = ClientPaidAdviserSplitsReceived.FeeId and A.IncomeTypeName = ClientPaidAdviserSplitsReceived.IncomeTypeName
	Where A.CanSnapShot = 1
	and A.IsPaidByProvider = 0


	
	
	--Provider paid Fees PawayReceived
	INSERT INTO #MovementFees
	(	TenantId , FeeId, LinkedToPolicyBusinessId , IsPayawayReceived, SellingAdviserId , RecevingAdviserId ,  IncomeTypeName , IsRecurring , IsPaidByProvider, MaxTriggerTimeStamp, FeeDate , CanSnapShot , HasMovement ,
		 GrossAmount, VATAmount , NetAmount , 
		PayawayReceivedPercentage , Advisers
	)
	Select
		A.TenantId, A.FeeId, A.LinkedToPolicyBusinessId, 1, ClientPaidAdviserSplitsReceived.PractitionerId, ClientPaidAdviserSplitsReceived.CRAPractitionerId,  ClientPaidAdviserSplitsReceived.IncomeTypeName, A.IsRecurring, A.IsPaidByProvider, A.MaxTriggerTimeStamp, A.FeeDate, A.CanSnapShot, A.HasMovement,
		0, 0,
		NetAmount = ((ISNULL(ClientPaidAdviserSplitsReceived.SplitPercent, 0) * A.GrossAmount) / 100 ), 
		PayawayReceivedPercentage = ISNULL(ClientPaidAdviserSplitsReceived.SplitPercent, 0),
		ISNULL(ClientPaidAdviserSplitsReceived.Advisers, '')

	FROM #MovementFees A
	INNER JOIN
	(
		--Policy Adviser Splits - Treat Banding Partner ship and normal payway as the same (CDV using 100% banding on 100% Banding partnership is the same as a 100% split)
		Select A.FeeId, cra.PractitionerId, CRA.CRAPractitionerId ,IncomeTypeName, ISNULL(Sum(B.SplitPercent), 0) AS SplitPercent ,
			MIN(ISNULL(D.CorporateName, '') + '' + ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '')) as Advisers  
		FROM #MovementFees A
		Inner Join commissions..TSplit B ON A.TenantId = B.IndClientId AND  A.LinkedToPolicyBusinessId = B.PolicyId -- Provider paid fees use Policy Splits
		inner Join commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId	
		inner Join crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
		Inner join CRM..TPractitioner E ON B.IndClientId = E.IndClientId AND B.PaymentEntityCRMId = E.CRMContactId
		INNER JOIN #AdviserAndCRABanding cra ON A.TenantId =  cra.IndigoClientId AND  E.PractitionerId =  cra.PractitionerId -- this tells us exactly which rate to use and if a CRA is going to ovverride it
		Where A.CanSnapShot = 1
		AND ((A.IsRecurring = 0) OR(A.IsRecurring = 1 AND B.RenewalsFG = 1))
		and  C.PractitionerFG = 1
		and ISNULL(B.PartnershipType,0) IN (0,1)
		and A.IsPaidByProvider = 1
		Group by A.FeeId, cra.PractitionerId, CRA.CRAPractitionerId, PaymentEntityCRMId , IncomeTypeName
	) ClientPaidAdviserSplitsReceived ON A.FeeId = ClientPaidAdviserSplitsReceived.FeeId and A.IncomeTypeName = ClientPaidAdviserSplitsReceived.IncomeTypeName
	Where A.CanSnapShot = 1
	and A.IsPaidByProvider = 1



	--All Fee movements that Don't exist must exist :-)
	Insert into TMovement 
	(	
	
		TenantId,
		PractitionerId,
		PolicyBusinessId,
		FeeId,
		LinkedPolicyBusinessId,
		IsRecurring,
		PayAdjustId,
		IsPayawayReceived,
		MovementDateTime,
		CreatedDateTime,
		IncomeTypeName,
		Percentage,
		GrossAmount,
		IntroducerAmount,
		IntroducerName,
		ClientAmount,
		ClientName,
		AdviserAmount,
		AdviserName,
		NetAmount,
		VATAmount,
		LastRunDateTime	

		)
	Select TenantId,
		RecevingAdviserId,
		null,
		FeeId,
		LinkedToPolicyBusinessId,
		IsRecurring,
		null,
		IsPayawayReceived,
		@DateUtc,
		GETDATE(),
		IncomeTypeName,
		Case when IsPayawayReceived = 0 Then BandingRate Else PayawayReceivedPercentage END,
		GrossAmount,
		IntroducerAmount,
		Introducers,
		ClientAmount,
		Clients,
		AdviserAmount,
		Advisers,
		NetAmount,
		VATAmount,
		GETDATE()	

from #MovementFees
Where CanSnapShot = 1 and HasMovement = 0	



	--------------------------------------------------------------
	-- Work out the next recurrence date for our fees.
	--------------------------------------------------------------
	-- Audit
	INSERT INTO TFeeRecurrenceAudit (
		FeeId, NextExpectationDate, ConcurrencyId, FeeRecurrenceId, StampAction, StampDateTime, StampUser)
	SELECT
		FR.FeeId, FR.NextExpectationDate, FR.ConcurrencyId, FR.FeeRecurrenceId, 'U', @StampDateTime, @StampUser
	FROM
		TFeeRecurrence FR
		JOIN #Dates D ON D.FeeId = FR.FeeId
		JOIN #Fees F ON F.FeeId = FR.FeeId
	WHERE f.EndDate IS NULL OR f.EndDate > NextDate

	-- Update
	UPDATE FR
	SET
		NextExpectationDate = NextDate
	FROM
		TFeeRecurrence FR
		JOIN #Dates D ON D.FeeId = FR.FeeId
		JOIN #Fees F ON D.FeeId = F.FeeId
	WHERE f.EndDate IS NULL OR f.EndDate > NextDate


		--GET Fee Current Status!
	IF OBJECT_ID('tempdb..#FeeCurrentStatus') IS NOT NULL DROP TABLE #FeeCurrentStatus

	SELECT DISTINCT f.feeid AS feeid, f.IndigoClientId as tenantid, MAX(tfs.feestatusId) as statusId
	into #FeeCurrentStatus
	FROM TFee f 
		JOIN TAdviseFeeType aft on f.AdviseFeeTypeId = aft.AdviseFeeTypeId
		JOIN TFeeStatus tfs  ON f.FeeId =  tfs.FeeId
		JOIN TFeeRecurrence tfr on f.FeeId = tfr.FeeId
	WHERE  aft.RefAdviseFeeTypeId = 2 AND ((f.EndDate IS NOT NULL AND tfr.NextExpectationDate > f.EndDate))
	--Per Tenant
	AND (@TenantId = 0 OR (@TenantId != 0 AND f.IndigoClientId = @TenantId))
	--Per Fee
	AND (@FeeId = 0 OR (@FeeId != 0 AND f.FeeId = @FeeId))

	Group by f.FeeId, f.IndigoClientId

	
	DELETE tfr
	OUTPUT DELETED.FeeId, DELETED.NextExpectationDate, DELETED.ConcurrencyId, DELETED.FeeRecurrenceId, 'D', @StampDateTime, @StampUser
	INTO TFeeRecurrenceAudit (FeeId, NextExpectationDate, ConcurrencyId, FeeRecurrenceId, StampAction, StampDateTime, StampUser)
	FROM TFeeRecurrence tfr
		JOIN #FeeCurrentStatus fcs on tfr.FeeId = fcs.feeid
		JOIN TFeeStatus tfs on fcs.statusId = tfs.FeeStatusId
	WHERE tfs.[Status] = 'Due' 
	--Per Tenant
	AND (@TenantId = 0 OR (@TenantId != 0 AND fcs.tenantid = @TenantId))
	--Per Fee
	AND (@FeeId = 0 OR (@FeeId != 0 AND fcs.FeeId = @FeeId))


END TRY
BEGIN CATCH
	
	SET @ErrorMessage = ERROR_MESSAGE()
	ROLLBACK TRANSACTION
	RAISERROR(@ErrorMessage, 16, 1)
	RETURN;

END CATCH
	

COMMIT TRANSACTION

