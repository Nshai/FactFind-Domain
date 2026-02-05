SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Drop procedure [dbo].[spCalculateRecurringInvestmentFee]  
CREATE PROCEDURE [dbo].[spCalculateRecurringInvestmentFee] (
	@policyBusinessId BIGINT,
	@feeId BIGINT,
	@feePercentage DECIMAL(18, 2) = 0,
	@discountAmount DECIMAL(18, 2) = 0,
	@discountPercentage DECIMAL(18, 2) = 0,
	@vatPercentage DECIMAL(18, 2) = 0,
	@maxFee DECIMAL(18, 2) = 0,
	@minFee DECIMAL(18, 2) = 0,
	@vatExempt BIT,
	@tenantId BIGINT,
	@CurrentUserDate datetime
	)
AS

set transaction isolation level read uncommitted

BEGIN
	DECLARE @originalAmount DECIMAL(18, 2)
	DECLARE @discountPercentageAmount DECIMAL(18, 2)
	DECLARE @netAmount DECIMAL(18, 2)
	DECLARE @vatPercentageAmount DECIMAL(18, 2)
	DECLARE @vatAmount DECIMAL(18, 2)
	DECLARE @totalAmount DECIMAL(18, 2)
	DECLARE @valuationId BIGINT
	DECLARE @calculatedOnAmount DECIMAL(18, 2)
	DECLARE @lastDueDate datetime

	SET @originalAmount = 0
	SET @netAmount = 0
	SET @totalAmount = 0
	SET @vatAmount = 0

	-- Get the Fee Frequency & use for future calculations
	DECLARE @RecurrenceId BIGINT

	SET @RecurrenceId = (
			SELECT RecurringFrequencyId
			FROM TFee
			WHERE FeeId = @feeId
				AND IndigoClientId = @tenantId
			)

	-- If valuation exists for that plan, then use the valuation data for calculation.
	IF EXISTS (
			SELECT 1
			FROM TPlanValuation TPV
			WHERE TPV.PolicyBusinessId = @policyBusinessId
			)
	BEGIN
		SELECT @valuationId = Max(PlanValuationId)
		FROM TPlanValuation TPV
		WHERE TPV.PolicyBusinessId = @policyBusinessId

		SELECT @calculatedOnAmount = PlanValue
		FROM TPlanValuation TPV
		WHERE TPV.PolicyBusinessId = @policyBusinessId
			AND TPV.PlanValuationId = @valuationId
	END
	ELSE
	BEGIN
		IF EXISTS (
				SELECT 1
				FROM TPolicyBusinessFund
				WHERE PolicyBusinessId = @policyBusinessId
				)
		BEGIN
			-- Calculate Fund/Equity Based - % (If applicable)
			-- Get the Funds and Equities for the Plan
			-- Add up the Total Price
			SELECT @calculatedOnAmount = SUM(CurrentUnitQuantity * CurrentPrice)
			FROM TPolicyBusinessFund PBF
			WHERE PBF.PolicyBusinessId = @policyBusinessId
		END
		
		IF @calculatedOnAmount IS NULL OR @calculatedOnAmount = 0
		BEGIN
			-- Calculate Contribution based if both Valuations & Funds/Holdings are not there OR SUM of funds is zero
			EXECUTE dbo.SpCalculateRecurringContributionFee @policyBusinessId,
				@feeId,
				@feePercentage,
				@discountPercentage,
				@vatPercentage,
				@vatExempt,
				@tenantId,
				@CurrentUserDate = @CurrentUserDate

			RETURN
		END
	END
	IF @calculatedOnAmount IS NULL
	BEGIN
		SET @calculatedOnAmount = 0
	END

	SELECT @originalAmount = @calculatedOnAmount * @feePercentage / 100

	-- Adjust the Fee based on the Fee Frequency
	SELECT @originalAmount = CASE @RecurrenceId
			-- Monthly 
			WHEN 1
				THEN @originalAmount / 12
					-- Quarterly
			WHEN 2
				THEN @originalAmount / 4
					-- Bi- Annual
			WHEN 3
				THEN @originalAmount / 2
					-- Annual
			WHEN 4
				THEN @originalAmount
			END

	-- Discount = Original Net Amount * Discount Percentage 
	IF (@discountPercentage != 0)
	BEGIN
		SET @discountPercentageAmount = (@originalAmount * @discountPercentage) / 100
		SET @netAmount = @originalAmount - @discountPercentageAmount;
	END
	ELSE
	BEGIN
		SET @netAmount = @originalAmount - @discountAmount;
	END

	--Check Max Fee Amount & Min Fee Amount on the net Amount
	-- Removed after a discussion with Sumit   
	-- VAT Amount = Net Amount * VAT Percentage
	-- Total Amount = Net Amount + VAT Amount
	IF (@vatExempt = 1)
		SET @totalAmount = @netAmount
	ELSE
	BEGIN
		IF @vatPercentage != 0
			SET @vatAmount = (@netAmount * @vatPercentage) / 100
		SET @totalAmount = @netAmount + @vatAmount
	END

	select @lastDueDate = NextExpectationDate
		from TFeeRecurrence
		where FeeId = @FeeId

	SET @lastDueDate = ISNULL(@lastDueDate, @CurrentUserDate)

	--TODO : Insert to Breakup Table
	--Insert Record to Expectations
	INSERT INTO TExpectations (
		[PolicyBusinessId],
		[FeeId],
		[Date],
		[NetAmount],
		[TotalAmount],
		[CalculatedAmount],
		[TenantId]
		)
	VALUES (
		@policyBusinessId,
		@feeId,
		@lastDueDate,
		@netAmount,
		@totalAmount,
		@calculatedOnAmount,
		@tenantId
		)

	-- Get the Expectation Id and Insert a record into the Audit Table
	-- SELECT SCOPE_IDENTITY()
	INSERT INTO TExpectationsAudit (
		[PolicyBusinessId],
		[FeeId],
		[Date],
		[NetAmount],
		[TotalAmount],
		[CalculatedAmount],
		[TenantId],
		ExpectationsId,
		StampAction,
		StampDateTime,
		StampUser
		)
	VALUES (
		@policyBusinessId,
		@feeId,
		@lastDueDate,
		@netAmount,
		@totalAmount,
		@calculatedOnAmount,
		@tenantId,
		SCOPE_IDENTITY(),
		'C',
		GETDATE(),
		0
		)
END
GO
