SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spCustomCalculateNextDueDateAndAmount]
	@ExpectedCommissionId Int = 0,
	@PolicyBusinessId Int = 0,
	@DueDateTime DateTime,
	@MovementDateTime DateTime = null
	with recompile
AS

IF(@MovementDateTime IS NULL)
BEGIN
	SET @MovementDateTime  = DATEADD( DAY, 1 , CAST(GETDATE() as DATE))
	Print Cast(@MovementDateTime as Varchar(200))
END

/*
Steps

	1) Set Due Date For all recurring expecteds with NULL

	2) Calculate

	3) Set Due Date for all recurring OR all fund based % that calcuated

	4) Generate Movements

*/


DECLARE @FundBasedName varchar(50) = 'fund based'
DECLARE @PercentageChargingType varchar(50) = 'PercentageCommission'

DECLARE @RefPaymentDueType_StartOfPolicy varchar(50) = 'At start of policy'
DECLARE @RefPaymentDueType_SpecificDate varchar(50) = 'specific date'
DECLARE @RefPaymentDueType_Now varchar(50) = 'Now'
DECLARE @RefPaymentDueType_AfterCharingPeriod varchar(50) = 'After Charging Period'


DECLARE @Status_Deleted varchar(50) = 'Deleted'
DECLARE @Status_OutOfForce varchar(50) = 'Out Of Force'
DECLARE @Status_OffRisk varchar(50) = 'Off Risk'
DECLARE @Status_Rejected varchar(50) = 'Rejected'
DECLARE @Status_NTU varchar(50) = 'NTU'

DECLARE @FrequencyName_Single varchar(50) = 'Single'

DECLARE @Condition nvarchar(255) = '';
DECLARE @ThePolicyId_Condition nvarchar(255);

DECLARE @ThePolicyId INT = 0

	if(@PolicyBusinessId > 0)
	Begin 
		Set @ThePolicyId = @policyBusinessId
		Set @Condition += ' AND A.PolicyBusinessId = @PolicyBusinessId'
	End
	Else if (@ExpectedCommissionId > 0)
	Begin
		Set @ThePolicyId = (Select PolicyBusinessId from TPolicyExpectedCommission where PolicyBusinessId=  @PolicyBusinessId)
		Set @Condition += ' AND A.PolicyExpectedCommissionId = @ExpectedCommissionId'
	End

	if(@ThePolicyId > 0)
	Begin 
		Set @ThePolicyId_Condition = ' AND A.PolicyBusinessId = @ThePolicyId'
	End
	Else if (@ThePolicyId IS NULL)
	Begin
		Set @ThePolicyId_Condition = ' AND A.PolicyBusinessId IS NULL '
	End
	Else if (@ThePolicyId = 0)
	Begin
		Set @ThePolicyId_Condition = ''
	End


	--######################################################
	--######################################################
	-- 1) Find the START date
	--######################################################
	--######################################################



	-- To avoid calulcating ALL initial dates we need to find out which commission records don't have a Due Date AND also which are set to use the Charging period
	--, so we can then limit the initial records we look at. 
	IF OBJECT_ID('tempdb..#ExpectedRecurring') IS NOT NULL DROP TABLE #ExpectedRecurring
	CREATE TABLE #ExpectedRecurring(
		PolicyExpectedCommissionId INT,
		PolicyBusinessId INT,
		ExpectedStartDate DATETIME,
		DueDate DATETIME,
		CommissionTypeName VARCHAR(50),
		PaymentDueType VARCHAR(255),
		PolicyStartDate DATETIME,
		MinChargingPeriodMonths INT
	);
	CREATE CLUSTERED INDEX IDX_PolicyExpectedCommissionId ON #ExpectedRecurring(PolicyExpectedCommissionId);

	if(@Condition != '')
		BEGIN
			DECLARE @ExpectedRecurring_SQL nvarchar(2000)
			--RecurringCommissionFg = 1 - IP-30605 calc for all recurring, % and amount based 
			--DueDate IS NULL - Step one - these are NEW or recently changed
			SET @ExpectedRecurring_SQL = 'INSERT INTO #ExpectedRecurring(PolicyExpectedCommissionId, PolicyBusinessId, ExpectedStartDate, DueDate, CommissionTypeName, PaymentDueType, PolicyStartDate, MinChargingPeriodMonths)'
										+ ' SELECT A.PolicyExpectedCommissionId, A.PolicyBusinessId, A.ExpectedStartDate, A.DueDate, B.CommissionTypeName, C.PaymentDueType, pb.PolicyStartDate, Cast(NULL as int) as MinChargingPeriodMonths'
										+ ' FROM TPolicyExpectedCommission A'
										+ ' INNER JOIN TRefCommissionType B ON A.RefCommissionTypeId = B.RefCommissionTypeId'
										+ ' INNER JOIN TRefPaymentDueType C ON A.RefPaymentDueTypeId = C.RefPaymentDueTypeId'
										+ ' INNER JOIN TPolicyBusiness pb ON A.PolicyBusinessId = pb.PolicyBusinessId'
										+ ' INNER JOIN TStatusHistory sh ON pb.PolicyBusinessId = sh.PolicyBusinessId'
										+ ' INNER JOIN Tstatus s ON sh.StatusId = s.StatusId'
										+ ' WHERE B.RecurringCommissionFg = 1'
										+ ' AND A.DueDate IS NULL'
										+ @Condition
										+ ' AND sh.CurrentStatusFG = 1'
										+ ' AND s.IntelligentOfficeStatusType not in(@Status_Deleted, @Status_OutOfForce, @Status_OffRisk, @Status_Rejected, @Status_NTU)'

			EXEC sp_executesql @ExpectedRecurring_SQL, 
				N'@PolicyBusinessId int, @ExpectedCommissionId int, @Status_Deleted varchar(50), @Status_OutOfForce varchar(50), @Status_OffRisk varchar(50), @Status_Rejected varchar(50), @Status_NTU varchar(50)',
				@PolicyBusinessId, @ExpectedCommissionId, @Status_Deleted, @Status_OutOfForce, @Status_OffRisk, @Status_Rejected, @Status_NTU
		END
	else
		BEGIN
			DROP TABLE if exists #temp_table
			SELECT A.PolicyExpectedCommissionId, A.PolicyBusinessId, A.ExpectedStartDate, A.DueDate, B.CommissionTypeName, C.PaymentDueType
			INTO #temp_table
			FROM TPolicyExpectedCommission A 
			INNER JOIN TRefCommissionType B ON A.RefCommissionTypeId = B.RefCommissionTypeId 
			INNER JOIN TRefPaymentDueType C ON A.RefPaymentDueTypeId = C.RefPaymentDueTypeId 
			INNER JOIN TStatusHistory sh ON a.PolicyBusinessId = sh.PolicyBusinessId 
			INNER JOIN Tstatus s ON sh.StatusId = s.StatusId 
			WHERE B.RecurringCommissionFg = 1 
			AND A.DueDate IS NULL 
			AND sh.CurrentStatusFG = 1 
			AND s.IntelligentOfficeStatusType not in(@Status_Deleted, @Status_OutOfForce, @Status_OffRisk, @Status_Rejected, @Status_NTU)

			INSERT INTO #ExpectedRecurring(PolicyExpectedCommissionId, PolicyBusinessId, ExpectedStartDate, DueDate, CommissionTypeName, PaymentDueType, PolicyStartDate, MinChargingPeriodMonths)
			SELECT A.PolicyExpectedCommissionId, A.PolicyBusinessId, A.ExpectedStartDate, A.DueDate, A.CommissionTypeName, A.PaymentDueType
			, pb.PolicyStartDate, Cast(NULL as int) as MinChargingPeriodMonths
			from #temp_table a
			INNER JOIN TPolicyBusiness pb ON A.PolicyBusinessId = pb.PolicyBusinessId
		END
	
	--SO CONFUSING
	/*

	for recurring that has a "After charing period" we need to get
	the first initial commission 


	*/

	IF OBJECT_ID('tempdb..#WhichInitialPlans') IS NOT NULL DROP TABLE #WhichInitialPlans
	Select Distinct PolicyBusinessId  into #WhichInitialPlans from #ExpectedRecurring
	Where PaymentDueType = @RefPaymentDueType_AfterCharingPeriod

	IF OBJECT_ID('tempdb..#InitialMinCharingPeriodMonths') IS NOT NULL DROP TABLE #InitialMinCharingPeriodMonths
	CREATE TABLE #InitialMinCharingPeriodMonths(
		PolicyBusinessId INT,
		ChargingPeriodMonths TINYINT
	);
	CREATE CLUSTERED INDEX IDX_PolicyBusinessId ON #InitialMinCharingPeriodMonths(PolicyBusinessId);

	-- get the start date for the first INITIAL commission so that we can work out the charging period for the recurring
	DECLARE @InitialMinCharingPeriodMonths_SQL nvarchar(2500)

	-- Inner join #WhichInitialPlans - This makes sure we don't calculate more than we need to every time
	SET @InitialMinCharingPeriodMonths_SQL = 'INSERT INTO #InitialMinCharingPeriodMonths(PolicyBusinessId, ChargingPeriodMonths)'
								+ ' SELECT DISTINCT A.PolicyBusinessId, ISNULL(A.ChargingPeriodMonths, 0) AS ChargingPeriodMonths'
								+ ' from TPolicyExpectedCommission A'
								+ ' Inner join('
								+ ' Select distinct Min(A.PolicyExpectedCommissionId) as  PolicyExpectedCommissionId, A.PolicyBusinessId'
								+ ' from TPolicyExpectedCommission A'
								+ ' Inner join #WhichInitialPlans WHICH on A.PolicyBusinessId = WHICH.PolicyBusinessId' 
								+ ' Inner join TRefCommissionType B ON A.RefCommissionTypeId = B.RefCommissionTypeId'
								+ ' Inner join TRefPaymentDueType C ON A.RefPaymentDueTypeId = C.RefPaymentDueTypeId'
								+ ' Inner join TPolicyBusiness pb on A.PolicyBusinessId = pb.PolicyBusinessId'
								+ ' Where InitialCommissionFg = 1'
								+ @ThePolicyId_Condition
								+ ' Group By A.PolicyBusinessId'
								+ ' )PE ON A.PolicyExpectedCommissionId = PE.PolicyExpectedCommissionId'
								+ ' Inner join #WhichInitialPlans WHICH on A.PolicyBusinessId = WHICH.PolicyBusinessId'
								+ ' Inner join TRefCommissionType B ON A.RefCommissionTypeId = B.RefCommissionTypeId'
								+ ' Inner join TRefPaymentDueType C ON A.RefPaymentDueTypeId = C.RefPaymentDueTypeId'
								+ ' Inner join TPolicyBusiness pb on A.PolicyBusinessId = pb.PolicyBusinessId'
								+ ' Where InitialCommissionFg = 1'
								+ @ThePolicyId_Condition
								+ ' order by ISNULL(A.ChargingPeriodMonths, 0) asc'
	
	EXEC sp_executesql @InitialMinCharingPeriodMonths_SQL, 
		N'@ThePolicyId int', @ThePolicyId

	-- Back to the Recuring Data - Set the min Charing periods that was used - Also set the initial date to the calulated date
	Update A
		set A.MinChargingPeriodMonths = Cm.ChargingPeriodMonths

	 from #ExpectedRecurring A
	inner Join #InitialMinCharingPeriodMonths cm ON A.PolicyBusinessId = cm.PolicyBusinessId -- 
	Where A.PaymentDueType = @RefPaymentDueType_AfterCharingPeriod -- this is the recurring payment due type !!!!!




	-- NOW we can set the DUE DATE because we have all the dates for all the payment due types
	update A
	Set DueDate = Case	WHen PaymentDueType = @RefPaymentDueType_StartOfPolicy THEN PolicyStartDate
						WHen PaymentDueType = @RefPaymentDueType_SpecificDate THEN ExpectedStartDate
						WHen PaymentDueType = @RefPaymentDueType_Now THEN ExpectedStartDate
						WHen PaymentDueType = @RefPaymentDueType_AfterCharingPeriod THEN DATEADD(month, ISNULL(MinChargingPeriodMonths,0), PolicyStartDate) -- use policy Start Date
					End
	from #ExpectedRecurring A



	--Chek the Lasst day of the month for charging period
	--The Charing period is X months from TODAY
	-- if today happens to be the last day of a month ... then the charing period in X months MUST also be the last day of that month.
	UPDATE A
		SET  DueDate = 
				
				CASE 
					--If the DAY of the initial date IS the same as the DAY of teh END OF THE MONTH, then return the END OF THE MONTH of the next date
					--Unless for Feb the last day could be leap year so just account for that too
					WHEN MONTH(PolicyStartDate) = 2 And  Day(PolicyStartDate) in(28,29) THEN EOMONTH(DueDate) 
					WHEN MONTH(PolicyStartDate) != 2 AND Day(PolicyStartDate) = DAY(EOMonth(PolicyStartDate)) THEN EOMONTH(DueDate) 
					WHEN MONTH(DueDate) != 2 AND DAY(PolicyStartDate) > Day(DueDate) THEN Cast(cast(Day(PolicyStartDate) as varchar(5)) + ' ' + Convert(char(3), DueDate, 0) + ' ' + cast(YEAR(DueDate) as varchar(5)) as Date) 
					--Otherwise just reurn the Date
					ELSE DueDate 
				END 
										
	FROM #ExpectedRecurring A
	Where A.PaymentDueType = @RefPaymentDueType_AfterCharingPeriod -- this is the recurring payment due type !!!!!






	--Select * from #ExpectedRecurring
	--return
	--Where PaymentDueType = @RefPaymentDueType_AfterCharingPeriod -- this is the recurring payment due type !!!!!
	--rollback
	--return


	--Update the Expected Commission -- leave out where Due Date is null 
	Insert into TPolicyExpectedCommissionAudit
	(
		PolicyBusinessId,
		RefCommissionTypeId,
		RefPaymentDueTypeId,
		RefFrequencyId,
		ChargingPeriodMonths,
		ExpectedAmount,
		ExpectedStartDate,
		ExpectedCommissionType,
		ParentPolicyExpectedCommissionId,
		PercentageFund,
		Notes,
		ChangedByUser,
		PreDiscountAmount,
		DiscountReasonId,
		Extensible,
		ConcurrencyId,
		PolicyExpectedCommissionId,
		StampAction,
		StampDateTime,
		StampUser,
		PlanMigrationRef,
		CommissionMigrationRef,
		ChargingType,
		ExpectedPercentage,
		DueDate	
	)
	Select A.PolicyBusinessId,
		RefCommissionTypeId,
		RefPaymentDueTypeId,
		A.RefFrequencyId,
		ChargingPeriodMonths,
		ExpectedAmount,
		A.ExpectedStartDate,
		ExpectedCommissionType,
		ParentPolicyExpectedCommissionId,
		PercentageFund,
		Notes,
		ChangedByUser,
		PreDiscountAmount,
		DiscountReasonId,
		Extensible,
		ConcurrencyId,
		A.PolicyExpectedCommissionId,
		'U',
		GetDate(),
		'9999999999',
		PlanMigrationRef,
		CommissionMigrationRef,
		ChargingType,
		ExpectedPercentage,
		A.DueDate	
	from TPolicyExpectedCommission A
	inner join #ExpectedRecurring B ON A.PolicyExpectedCommissionId = B.PolicyExpectedCommissionId
	Where B.DueDate IS NOT NULL 

	Update A
	Set A.DueDate = B.DueDate
	from TPolicyExpectedCommission A
	inner join #ExpectedRecurring B ON A.PolicyExpectedCommissionId = B.PolicyExpectedCommissionId
	Where B.DueDate IS NOT NULL 



 
--######################################################
--######################################################
-- 2) Calulcate AMounts
--######################################################
--######################################################


	--Update ALL % Fund Based  PolicyExpected Commission That is Due Today or earlier


	IF OBJECT_ID('tempdb..#CommissionToCalculate') IS NOT NULL DROP TABLE #CommissionToCalculate;
	CREATE TABLE #CommissionToCalculate(
		PolicyExpectedCommissionId INT,
		PolicyBusinessId INT,
		ExpectedStartDate DATETIME,
		ExpectedPercentage DECIMAL(18,2),
		ExpectedAmount MONEY,
		DueDate DATETIME,
		ChargingType VARCHAR(50),
		CommissionTypeName VARCHAR(50),
		PaymentDueType VARCHAR(255),
		PolicyStartDate DATETIME,
		RefFrequencyId INT,
		FrequencyName VARCHAR(50),
		TheInitialDate DATETIME,
		TheDate DATETIME,
		IsUpdated INT,
	);
	CREATE CLUSTERED INDEX IDX_PolicyExpectedCommissionId ON #CommissionToCalculate(PolicyExpectedCommissionId);

	if(@Condition != '')
		BEGIN
			DECLARE @CommissionToCalculate_SQL nvarchar(2000)
			SET @CommissionToCalculate_SQL = 'INSERT INTO #CommissionToCalculate('
										   + ' PolicyExpectedCommissionId, PolicyBusinessId, ExpectedStartDate, ExpectedPercentage,'
										   + ' ExpectedAmount, DueDate, ChargingType, CommissionTypeName, PaymentDueType,'
										   + ' PolicyStartDate, RefFrequencyId, FrequencyName, TheInitialDate, TheDate, IsUpdated)'
										   + ' SELECT A.PolicyExpectedCommissionId, A.PolicyBusinessId, A.ExpectedStartDate, A.ExpectedPercentage,'
										   + ' A.ExpectedAmount, A.DueDate, A.ChargingType, B.CommissionTypeName, C.PaymentDueType,'
										   + ' pb.PolicyStartDate, A.RefFrequencyId, f.FrequencyName, A.DueDate as TheInitialDate, CAST(NULL AS datetime) AS TheDate, Cast(0 as int) as IsUpdated'
										   + ' FROM TPolicyExpectedCommission A'
										   + ' INNER JOIN TRefCommissionType B ON A.RefCommissionTypeId = B.RefCommissionTypeId'
										   + ' INNER JOIN TRefPaymentDueType C ON A.RefPaymentDueTypeId = C.RefPaymentDueTypeId'
										   + ' INNER JOIN TPolicyBusiness pb ON A.PolicyBusinessId = pb.PolicyBusinessId'
										   + ' INNER join TRefFrequency f ON A.RefFrequencyId = f.RefFrequencyId'
										   + ' INNER join TStatusHistory sh ON pb.PolicyBusinessId = sh.PolicyBusinessId'
										   + ' INNER join Tstatus s ON sh.StatusId = s.StatusId '
										   + ' WHERE B.RecurringCommissionFg = 1'
										   + @Condition
										   + ' AND ISNULL(A.DueDate, cast(''01 Jan 2500'' as datetime)) < @DueDateTime'
										   + ' AND sh.CurrentStatusFG = 1'
										   + ' AND s.IntelligentOfficeStatusType not in( @Status_Deleted, @Status_OutOfForce, @Status_OffRisk, @Status_Rejected, @Status_NTU)'
										   + ' AND ((F.FrequencyName !=  @FrequencyName_Single) OR (F.FrequencyName = @FrequencyName_Single'
										   + ' AND DueDate IS NOT NULL AND ISNULL(ExpectedPercentage, 0) != 0'
										   + ' And ISNUll(A.ExpectedAmount, 0) = 0 ))'

			EXEC sp_executesql @CommissionToCalculate_SQL, 
				N'@PolicyBusinessId int, @ExpectedCommissionId int, @DueDateTime date, @Status_Deleted varchar(50), @Status_OutOfForce varchar(50), @Status_OffRisk varchar(50), @Status_Rejected varchar(50), @Status_NTU varchar(50), @FrequencyName_Single varchar(50)',
				@PolicyBusinessId, @ExpectedCommissionId, @DueDateTime, @Status_Deleted, @Status_OutOfForce, @Status_OffRisk, @Status_Rejected, @Status_NTU, @FrequencyName_Single
		END
	else
		BEGIN
			drop table if exists #temp_table2
			SELECT A.PolicyExpectedCommissionId, A.PolicyBusinessId, A.ExpectedStartDate, A.ExpectedPercentage, A.ExpectedAmount, A.DueDate, A.ChargingType, B.CommissionTypeName, C.PaymentDueType, A.RefFrequencyId, f.FrequencyName, A.DueDate as TheInitialDate
			INTO #temp_table2
			from TPolicyExpectedCommission A
			INNER JOIN TRefCommissionType B ON A.RefCommissionTypeId = B.RefCommissionTypeId
			INNER JOIN TRefPaymentDueType C ON A.RefPaymentDueTypeId = C.RefPaymentDueTypeId
			INNER JOIN TRefFrequency f ON A.RefFrequencyId = f.RefFrequencyId
			INNER JOIN TStatusHistory sh ON a.PolicyBusinessId = sh.PolicyBusinessId 
			INNER JOIN Tstatus s ON sh.StatusId = s.StatusId
			WHERE B.RecurringCommissionFg = 1 -- we need to calculate the dates for all recurring, but ONLY THE AMOUNT for percentage based !!!!
			AND ISNULL(A.DueDate, cast('01 Jan 2500' as datetime)) < @DueDateTime
			and sh.CurrentStatusFG = 1
			AND s.IntelligentOfficeStatusType not in (@Status_Deleted, @Status_OutOfForce, @Status_OffRisk, @Status_Rejected, @Status_NTU)
			AND ((F.FrequencyName != @FrequencyName_Single) OR (F.FrequencyName = @FrequencyName_Single AND DueDate IS NOT NULL AND ISNULL(ExpectedPercentage, 0) != 0 And ISNUll(A.ExpectedAmount, 0) = 0 )) -- only include Single if it doesn't already  done

			INSERT INTO #CommissionToCalculate(
			PolicyExpectedCommissionId,
			PolicyBusinessId,
			ExpectedStartDate,
			ExpectedPercentage,
			ExpectedAmount,
			DueDate,
			ChargingType,
			CommissionTypeName,
			PaymentDueType,
			PolicyStartDate,
			RefFrequencyId,
			FrequencyName,
			TheInitialDate,
			TheDate,
			IsUpdated
			)
			SELECT
			A.PolicyExpectedCommissionId,
			A.PolicyBusinessId,
			A.ExpectedStartDate,
			A.ExpectedPercentage,
			A.ExpectedAmount,
			A.DueDate,
			A.ChargingType,
			A.CommissionTypeName,
			A.PaymentDueType,
			pb.PolicyStartDate,
			A.RefFrequencyId,
			A.FrequencyName,
			A.DueDate as TheInitialDate,
			CAST(NULL AS datetime) AS TheDate,
			Cast(0 as int) as IsUpdated
			from #temp_table2 A
			INNER JOIN TPolicyBusiness pb ON A.PolicyBusinessId = pb.PolicyBusinessId
		END
	
	IF OBJECT_ID('tempdb..#Plans') IS NOT NULL DROP TABLE #Plans
	IF OBJECT_ID('tempdb..#LastValuation') IS NOT NULL DROP TABLE #LastValuation
	IF OBJECT_ID('tempdb..#PlanValues') IS NOT NULL DROP TABLE #PlanValues
	IF OBJECT_ID('tempdb..#FundValues') IS NOT NULL DROP TABLE #FundValues



	
	--Lets Get Plans :-) to calculate
	SELECT DISTINCT
		PolicyBusinessId,
		CAST(NULL AS money) AS Valuation

	INTO 
		#Plans
	FROM	
		#CommissionToCalculate A
	WHERE A.CommissionTypeName = @FundBasedName
	AND A.ChargingType = @PercentageChargingType



	--------------------------------------------------------------
	-- Work out the value for each plan
	-- We're just taking the latest Plan Valuation Record here on the basis of Id, this is not necessarily correct,
	-- but that's how the code was originally designed to work
	--------------------------------------------------------------
	SELECT PV.PolicyBusinessId, MAX(PlanValuationId) AS Id
	INTO #LastValuation
	FROM 
		TPlanValuation PV
		JOIN #Plans P ON P.PolicyBusinessId = PV.PolicyBusinessId
	GROUP BY PV.PolicyBusinessId

	-- build list of values for each 
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
		JOIN #PlanValues PV ON PV.PolicyBusinessId = A.PolicyBusinessId

	--------------------------------------------------------------
	-- Find values from Funds (we fall back to these)
	-- No assets are included here, this is how the original code worked.
	--------------------------------------------------------------
	SELECT PBF.PolicyBusinessId, SUM(PBF.CurrentUnitQuantity * PBF.CurrentPrice) AS Amount
	INTO
		#FundValues
	FROM 
		TPolicyBusinessFund PBF
		JOIN #Plans P ON P.PolicyBusinessId = PBF.PolicyBusinessId
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
		JOIN #FundValues FV ON FV.PolicyBusinessId = A.PolicyBusinessId
	WHERE
		A.Valuation IS NULL
		AND FV.Amount != 0
	
	

	--Get the Valueation Amount
	Update A
	Set ExpectedAmount =  Round(((A.ExpectedPercentage / 100) * B.Valuation) / freq.MultiplierForAnnualisedAmount, 2),
		IsUpdated = 1
	from #CommissionToCalculate A
	Inner join #Plans B ON A.PolicyBusinessId = B.PolicyBusinessId
	Inner join TRefFrequency freq ON A.RefFrequencyId = freq.RefFrequencyId
	Where A.ExpectedPercentage IS NOT NULL
	AND B.Valuation IS NOT NULL




	--######################################################
	--######################################################
	-- 3) Next Due Date
	--######################################################
	--######################################################

	PRINT 'Step 3 Started at: ' + CAST(GETDATE() as nvarchar);


	/*
	The below update replaced about 60 lines of old code that attempted to track the end of the month.
	SQL 2012+ has an inbuilt function for this. It eans this procedure is now 100% accurate as well
	a more easy to read and maintain.

	*/

	UPDATE ctc
	SET ctc.DueDate = [dbo].[FnCustomGetNextPayDate](ctc.RefFrequencyId, ctc.TheInitialDate, @DueDateTime)
	FROM #CommissionToCalculate ctc


	--Used Later for Storing the due dates
	IF OBJECT_ID('tempdb..#DueDate') IS NOT NULL DROP TABLE #DueDate
	CREATE TABLE #DueDate(
		PolicyExpectedCommissionId INT,
		PolicyBusinessId INT,
		Amount MONEY,
		DueDate DATETIME,
		IsUpdated INT,
		IncomeTypeName VARCHAR(50)
	);
	CREATE CLUSTERED INDEX IDX_DueDate ON #DueDate(DueDate);

	--Get Single Dates and Also remove from Table as these are only calulcated once
	INSERT INTO #DueDate
	SELECT A.PolicyExpectedCommissionId, A.PolicyBusinessId, A.ExpectedAmount, TheInitialDate, IsUpdated, CommissionTypeName
	FROM #CommissionToCalculate A
		INNER JOIN TPolicyExpectedCommission B ON A.PolicyExpectedCommissionId = B.PolicyExpectedCommissionId
	WHERE FrequencyName = @FrequencyName_Single
		AND (
			CAST(A.TheInitialDate AS DATE) != CAST(b.DueDate AS DATE) -- only if they are different - They shouldn't be
			OR (ISNULL(A.ExpectedAmount, 0) != ISNULL(B.ExpectedAmount, 0) AND IsUpdated = 1)
		)

	UPDATE A
	SET A.ExpectedAmount = CASE WHEN B.IsUpdated = 1 THEN B.ExpectedAmount ELSE A.ExpectedAmount END
	FROM TPolicyExpectedCommission A
		INNER JOIN #CommissionToCalculate B ON A.PolicyExpectedCommissionId = B.PolicyExpectedCommissionId
	WHERE B.FrequencyName = @FrequencyName_Single --Do single Frequency Separate

	--Remove from Temp Table
	DELETE FROM #CommissionToCalculate WHERE FrequencyName = @FrequencyName_Single

	INSERT INTO #DueDate
	SELECT PolicyExpectedCommissionId, PolicyBusinessId, ExpectedAmount, DueDate, IsUpdated, CommissionTypeName
	FROM #CommissionToCalculate

	---------------------------------------------------------------------------------------------------------

	INSERT INTO TPolicyExpectedCommissionAudit
	(
		PolicyBusinessId
		,RefCommissionTypeId
		,RefPaymentDueTypeId
		,RefFrequencyId
		,ChargingPeriodMonths
		,ExpectedAmount
		,ExpectedStartDate
		,ExpectedCommissionType
		,ParentPolicyExpectedCommissionId
		,PercentageFund
		,Notes
		,ChangedByUser
		,PreDiscountAmount
		,DiscountReasonId
		,Extensible
		,ConcurrencyId
		,PolicyExpectedCommissionId
		,StampAction
		,StampDateTime
		,StampUser
		,PlanMigrationRef
		,CommissionMigrationRef
		,ChargingType
		,ExpectedPercentage
		,DueDate
	)
	SELECT
		A.PolicyBusinessId
		,RefCommissionTypeId
		,RefPaymentDueTypeId
		,A.RefFrequencyId
		,ChargingPeriodMonths
		,A.ExpectedAmount
		,A.ExpectedStartDate
		,ExpectedCommissionType
		,ParentPolicyExpectedCommissionId
		,PercentageFund
		,Notes
		,ChangedByUser
		,PreDiscountAmount
		,DiscountReasonId
		,Extensible
		,ConcurrencyId
		,A.PolicyExpectedCommissionId
		,'U'
		,GetDate()
		,'9999999999'
		,PlanMigrationRef
		,CommissionMigrationRef
		,A.ChargingType
		,A.ExpectedPercentage
		,A.DueDate
	FROM TPolicyExpectedCommission A
		INNER JOIN #DueDate B ON A.PolicyExpectedCommissionId = B.PolicyExpectedCommissionId
	WHERE CAST(B.DueDate AS DATE) >= DATEADD(DAY, -1 , CAST(@DueDateTime AS DATE))


	UPDATE A
	SET A.ExpectedAmount = B.Amount
	FROM TPolicyExpectedCommission A
		INNER JOIN #DueDate B ON A.PolicyExpectedCommissionId = B.PolicyExpectedCommissionId
	WHERE IsUpdated = 1




	--######################################################
	--######################################################
	-- 4) Movements
	--######################################################
	--######################################################

	-- It was agreed to leave only the UTC date. 
	-- This date is only used for the UK region.
	Declare @MovementDate Date = DateAdd(Day, -1 , CAST(@MovementDateTime AS Date))
	Print @movementdate


	--Check Tenant Preferences	
	Declare  @Preference_Name varchar(20) = 'GenerateMovements'

	IF OBJECT_ID('tempdb..#Tenants') IS NOT NULL DROP TABLE #Tenants;
	CREATE TABLE #Tenants(TenantId INT);
	CREATE CLUSTERED INDEX IDX_TenantId ON #tenants(TenantId);

	--Get whichever tenants have The Tenant Preference 
	Insert into #Tenants 
	Select Distinct IndigoClientId 
	from administration..TIndigoClientPreference
	WHERE PreferenceName = @Preference_Name




	If not exists (Select TenantId from #Tenants) 
	BEGIN
		print 'ZERO tenants configured'
	END





	--RemoveAnyMOvements that we are about to put in for the date EG - one could hae been added in the mornin the value then updates in the evening ... the overnight job will effectivly update the movement to have the latest value for the day

	Delete M from TMovement M
	Inner join #DueDate B ON  M.PolicyBusinessId = B.PolicyBusinessId AND M.IncomeTypeName = B.IncomeTypeName
	INNER JOIN #Tenants t ON M.TenantId = t.TenantId -- ONLY CONFIGURED TENANTS
	WHERE M.IsRecurring = 1 
	And Cast(M.MovementDateTime as date) = @MovementDate
	and FeeId IS NULL
	and PayAdjustId IS NULL


	IF OBJECT_ID('tempdb..#MovementPlans') IS NOT NULL DROP TABLE #MovementPlans
	CREATE TABLE #MovementPlans(
		TenantId INT,
		PolicyBusinessId INT,
		IsPayawayReceived INT DEFAULT(0),
		SellingAdviserId INT,
		RecevingAdviserId INT, 
		CommissionTypeName VARCHAR(200),
		IsRecurring INT,
		MaxTriggerTimeStamp DATETIME,
		PolicyStartDate DATETIME,
		BandingRate DECIMAL (10,2) DEFAULT(0), 
		GrossAmount MONEY DEFAULT(0),
		IntroducerAmount MONEY DEFAULT(0),
		ClientAmount MONEY DEFAULT(0), 
		AdviserAmount MONEY DEFAULT(0),
		NetAmount MONEY DEFAULT(0), 
		PayawayReceivedPercentage DECIMAL (10,2) DEFAULT(0),
		Introducers VARCHAR(200),
		Clients VARCHAR(200),
		Advisers VARCHAR(200)
	);
	CREATE CLUSTERED INDEX IDX_TenantId ON #MovementPlans(TenantId);

	--Will only snap shot if Has a Policy Start Date,  has an expected commission, AND is not Deleted status


	IF OBJECT_ID('tempdb..#SuitableDueDate') IS NOT NULL DROP TABLE #SuitableDueDate
	SELECT
		DISTINCT pb.IndigoClientId,
		A.PolicyBusinessId,
		C.CommissionTypeName,
		C.RecurringCommissionFg,
		MaxTriggerTimeStamp = @MovementDate,
		PB.PolicyStartDate
	INTO #SuitableDueDate
	FROM #DueDate A
	INNER JOIN TPolicyBusiness PB ON A.PolicyBusinessId = PB.PolicyBusinessId
	INNER JOIN #Tenants t ON PB.IndigoClientId = t.TenantId -- ONLY CONFIGURED TENANTS
	INNER JOIN TPolicyExpectedCommission B ON A.PolicyExpectedCommissionId = B.PolicyExpectedCommissionId
	INNER JOIN TRefCommissionType C ON B.RefCommissionTypeId = C.RefCommissionTypeId
	WHERE PB.PolicyStartDate IS NOT NULL
		AND (Cast(A.DueDate AS DATE) = @MovementDate OR Cast(B.DueDate AS DATE) = @MovementDate)


	INSERT INTO #MovementPlans
	(
		TenantId,
		PolicyBusinessId,
		SellingAdviserId,
		RecevingAdviserId,
		CommissionTypeName,
		IsRecurring,
		MaxTriggerTimeStamp,
		PolicyStartDate,
		BandingRate
	)
	SELECT
		DISTINCT A.IndigoClientId,
		A.PolicyBusinessId,
		RATE.PractitionerId,
		RATE.CRAPractitionerId,
		A.CommissionTypeName,
		A.RecurringCommissionFg,
		@MovementDate,
		A.PolicyStartDate,
		RATE.BandingRate
	FROM #SuitableDueDate A
	INNER JOIN TStatusHistory D ON A.PolicyBusinessId = D.PolicyBusinessId AND D.CurrentStatusFG = 1 -- CURRENT STATUS
	INNER JOIN TStatus E ON D.StatusId = E.StatusId
	INNER JOIN TPolicyBusinessext EXT ON A.PolicyBusinessId = EXT.PolicyBusinessId
	INNER JOIN commissions..VwAdviserAndCRABanding RATE ON A.IndigoClientId = RATE.IndigoClientID AND EXT.BandingTemplateId = rate.BandingTemplateId -- this tells us exactly which rate to use and if a CRA is going to ovverride it


	-- Get the Expected Amount for plans
	Update A
	Set A.GrossAmount = ISNULL(B.Amount, 0)
	from #MovementPlans A INNER JOIN 
	(
		Select A.PolicyBusinessId, A.CommissionTypeName, Sum(B.ExpectedAmount) as Amount 
		from #MovementPlans A
		inner Join policymanagement..TPolicyExpectedCommission B ON A.PolicyBusinessId = B.PolicyBusinessId
		inner join policymanagement..TRefCommissionType C ON B.RefCommissionTypeId = C.RefCommissionTypeId and A.CommissionTypeName = C.CommissionTypeName
		WHERE Cast(A.MaxTriggerTimeStamp as date) = Cast(B.DueDate as date)
		Group BY A.PolicyBusinessId, A.CommissionTypeName
	) B ON A.PolicyBusinessId = B.PolicyBusinessId and A.CommissionTypeName = B.CommissionTypeName


	IF OBJECT_ID('tempdb..#PreMovementPlans') IS NOT NULL DROP TABLE #PreMovementPlans
	CREATE TABLE #PreMovementPlans(
		PolicyBusinessId INT,
		TenantId INT,
		CommissionTypeName VARCHAR(200),
		SplitPercent DECIMAL(10,2),
		CorporateName VARCHAR(200),
		FirstName VARCHAR(200),
		LastName VARCHAR(200),
		SplitType INT DEFAULT(0),
		PaymentEntityCRMId INT
	)
	CREATE CLUSTERED INDEX IDX_PolicyBusinessId ON #PreMovementPlans(PolicyBusinessId);


	INSERT INTO #PreMovementPlans(
		PolicyBusinessId,
		TenantId,
		CommissionTypeName,
		SplitPercent,
		CorporateName,
		FirstName,
		LastName,
		SplitType,
		PaymentEntityCRMId
	)
	SELECT
		A.PolicyBusinessId,
		A.TenantId,
		A.CommissionTypeName,
		B.SplitPercent,
		D.CorporateName,
		D.FirstName,
		D.LastName,
		CASE
			-- Introducer
			WHEN C.RefIntroducerTypeId IS NOT NULL THEN 1
			-- Client
			WHEN C.ClientFg = 1 THEN 2
			-- Adviser
			WHEN C.PractitionerFG = 1 AND ISNULL(B.PartnershipType, 0) IN (0, 1) THEN 3
			ELSE 0
		END,
		B.PaymentEntityCRMId
	FROM #MovementPlans A
	INNER JOIN commissions..TSplit B ON A.TenantId = B.IndClientId AND A.PolicyBusinessId = B.PolicyId
	INNER JOIN commissions..TPaymentEntity C ON B.PaymentEntityId = C.PaymentEntityId
	INNER JOIN crm..TCRMContact D ON B.PaymentEntityCRMId = D.CRMContactId
	WHERE (A.IsRecurring = 0 AND B.InitialFG = 1) OR (A.IsRecurring = 1 AND B.RenewalsFG = 1)


	IF OBJECT_ID('tempdb..#GroupedMovements') IS NOT NULL DROP TABLE #GroupedMovements
	CREATE TABLE #GroupedMovements(
		PolicyBusinessId INT,
		SplitPercent DECIMAL(10,2),
		FullName VARCHAR(200),
		SplitType INT
	);
	CREATE CLUSTERED INDEX IDX_PolicyBusinessId ON #GroupedMovements(PolicyBusinessId);

	INSERT INTO #GroupedMovements(
		PolicyBusinessId,
		SplitPercent,
		FullName,
		SplitType
	)
	SELECT
		PolicyBusinessId,
		ISNULL(SUM(SplitPercent), 0),
		MIN(ISNULL(CorporateName, '') + '' + ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '')),
		SplitType
	FROM #PreMovementPlans
	GROUP BY PolicyBusinessId, CommissionTypeName, SplitType

	--Snapshot PLAN SPLITS
	UPDATE A
	SET
		A.IntroducerAmount = ((ISNULL(B.SplitPercent, 0) * A.GrossAmount) / 100),
		A.Introducers = B.FullName,
		A.ClientAmount = ((ISNULL(C.SplitPercent, 0) * A.GrossAmount) / 100),
		A.Clients = C.FullName,
		A.AdviserAmount = ((ISNULL(D.SplitPercent, 0) * A.GrossAmount) / 100),
		A.Advisers = D.FullName
	FROM #MovementPlans A
	-- Introdusers
	LEFT JOIN #GroupedMovements B ON A.PolicyBusinessId = B.PolicyBusinessId AND B.SplitType = 1
	-- Clients
	LEFT JOIN #GroupedMovements C ON A.PolicyBusinessId = C.PolicyBusinessId AND C.SplitType = 2
	-- Advisers
	LEFT JOIN #GroupedMovements D ON A.PolicyBusinessId = D.PolicyBusinessId AND D.SplitType = 3


	UPDATE A
	SET GrossAmount = ISNULL(GrossAmount, 0),
		IntroducerAmount = ISNULL(IntroducerAmount, 0),
		ClientAmount = ISNULL(ClientAmount, 0),
		AdviserAmount = ISNULL(AdviserAmount, 0),
		NetAmount = (ISNULL(GrossAmount, 0) - ISNULL(IntroducerAmount, 0) - ISNULL(ClientAmount, 0) - ISNULL(AdviserAmount, 0)) * ISNULL(A.BandingRate, 0) / 100
	FROM #MovementPlans A



	INSERT INTO #MovementPlans
	(
		TenantId,
		PolicyBusinessId,
		IsPayawayReceived,
		SellingAdviserId,
		RecevingAdviserId,
		CommissionTypeName,
		IsRecurring,
		MaxTriggerTimeStamp,
		PolicyStartDate,
		GrossAmount,
		NetAmount,
		PayawayReceivedPercentage,
		Advisers
	)
	SELECT
		A.TenantId,
		A.PolicyBusinessId,
		1,
		PolicyAdviserSplitsReceived.PractitionerId,
		PolicyAdviserSplitsReceived.CRAPractitionerId,
		PolicyAdviserSplitsReceived.CommissionTypeName,
		A.IsRecurring,
		A.MaxTriggerTimeStamp,
		A.PolicyStartDate,
		0,
		NetAmount = ((ISNULL(PolicyAdviserSplitsReceived.SplitPercent, 0) * A.GrossAmount) / 100 ),
		PayawayReceivedPercentage = ISNULL(PolicyAdviserSplitsReceived.SplitPercent, 0),
		ISNULL(PolicyAdviserSplitsReceived.Advisers, '')
	FROM #MovementPlans A
	INNER JOIN
	(
		--Policy Adviser Splits - Treat Banding Partner ship and normal payway as the same (CDV using 100% banding on 100% Banding partnership is the same as a 100% split)
		SELECT
			A.PolicyBusinessId,
			cra.PractitionerId,
			CRA.CRAPractitionerId,
			CommissionTypeName,
			ISNULL(Sum(A.SplitPercent), 0) AS SplitPercent,
			MIN(ISNULL(A.CorporateName, '') + '' + ISNULL(A.FirstName, '') + ' ' + ISNULL(A.LastName, '')) AS Advisers
		FROM #PreMovementPlans A
		INNER JOIN CRM..TPractitioner E ON A.TenantId = E.IndClientId AND A.PaymentEntityCRMId = E.CRMContactId
		INNER JOIN commissions..VwAdviserAndCRABanding CRA ON A.TenantId = CRA.IndigoClientId AND E.PractitionerId = CRA.PractitionerId -- this tells us exactly which rate to use and if a CRA is going to ovverride it
		WHERE A.SplitType = 3
		GROUP BY A.PolicyBusinessId, CRA.PractitionerId, CRA.CRAPractitionerId, A.PaymentEntityCRMId, A.CommissionTypeName
	) PolicyAdviserSplitsReceived ON A.PolicyBusinessId = PolicyAdviserSplitsReceived.PolicyBusinessId AND A.CommissionTypeName = PolicyAdviserSplitsReceived.CommissionTypeName



		--All Plan movements that Don't exist must exist :-)
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
		PolicyBusinessId,
		null,
		null,
		IsRecurring,
		null,
		IsPayawayReceived,
		@MovementDate,
		GETDATE(),
		CommissionTypeName,
		Case when IsPayawayReceived = 0 Then BandingRate Else PayawayReceivedPercentage END,
		GrossAmount,
		IntroducerAmount,
		Introducers,
		ClientAmount,
		Clients,
		AdviserAmount,
		Advisers,
		NetAmount,
		0,
		GETDATE()
	from #MovementPlans


	--Finally update the due Dates
	Update A
		SET A.DueDate = B.DueDate
	from TPolicyExpectedCommission A
	inner join #DueDate B ON A.PolicyExpectedCommissionId = B.PolicyExpectedCommissionId