SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  [dbo].[FnCustomCalculateFundCost](@TenantId int, @PolicyBusinessFundId bigint)
RETURNS decimal(28, 4)
AS
BEGIN
-- Declarations
DECLARE @UnitQuantity money, @UnitPrice money, @Gross money,
	@TotalHolding decimal(38, 8), @TransactionCost decimal(38, 8), @FundCost decimal(28, 4)

-- Default cost to zero
SELECT @FundCost = 0, @TotalHolding = 0

-- Cursor to get all fund transactions
DECLARE Transaction_Cursor CURSOR LOCAL FAST_FORWARD FOR
SELECT
	A.PolicyBusinessFundId, ISNULL(UnitQuantity, 0), ISNULL(UnitPrice, 0), ISNULL(Gross, 0)
FROM
	PolicyManagement..TPolicyBusinessFundTransaction A with (nolock)
WHERE
    TenantId = @TenantId
	AND PolicyBusinessFundId = @PolicyBusinessFundId
	AND ((NOT ((isnull(UnitPrice,0)= 0) AND (isnull(Gross,0)= 0)))
	OR ISNULL(UnitQuantity,0) < 0)
	AND NOT ((RefFundTransactionTypeId IS NOT NULL AND RefFundTransactionTypeId=32)
	OR (RefFundTransactionTypeId IS NULL AND Category1Text IS NOT NULL AND LOWER(Category1Text)='dividend')
	OR (RefFundTransactionTypeId IS NULL AND Category1Text IS NULL AND Description IS NOT NULL AND LOWER(Description)='dividend'))
-- Order is important, must by date, then quantity desc (so buys come before sells)
ORDER BY
	TransactionDate, UnitQuantity DESC, PolicyBusinessFundTransactionId

OPEN Transaction_Cursor
FETCH NEXT FROM Transaction_Cursor INTO @PolicyBusinessFundId, @UnitQuantity, @UnitPrice, @Gross

WHILE @@FETCH_STATUS = 0
BEGIN
	-- Buys, cost of transaction is the Gross amount by default. If Gross is unavailable we use units * price
	IF @UnitQuantity > 0
		SET @TransactionCost = CASE WHEN @Gross = 0 THEN @UnitQuantity * @UnitPrice ELSE @Gross END
	-- Are we selling more funds than we hold?
	-- We're not sure how to deal with this, for now we will kill the fund cost
	-- BEFORE FIX - SELECT @FundCost = NULL, @TotalHolding = NULL, @TransactionCost = NULL
	-- AFTER FIX - We must accumulate @UnitQuantity across all transactions in @TotalHolding and after that make a desision if @TotalHolding is negative then set @FundCost to zero
	ELSE IF @TotalHolding + @UnitQuantity < 0
		SET @TransactionCost = 0
	ELSE IF @TotalHolding = 0
		SET @TransactionCost = 0
	-- Sales, cost is calculated by using the proportion of units sold.
	-- (units sold / units held) * cost of current holdings
	ELSE
		SET @TransactionCost = CASE WHEN @UnitQuantity = 0 THEN @Gross ELSE (@UnitQuantity * @FundCost) / @TotalHolding END

	-- Update total cost and holdings
	SET @FundCost = @FundCost + @TransactionCost
	SET @TotalHolding = @TotalHolding + @UnitQuantity

	-- Next transaction
	FETCH NEXT FROM Transaction_Cursor INTO @PolicyBusinessFundId, @UnitQuantity, @UnitPrice, @Gross
END

CLOSE Transaction_Cursor
DEALLOCATE Transaction_Cursor

if (@TotalHolding < 0)
	SET @FundCost = 0

RETURN @FundCost
END
GO
