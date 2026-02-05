SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomGetFinancialYearIntervalDates] 
	@IndigoClientId bigint,
	@Interval varchar(64),
	@StartDate datetime output,
	@EndDate datetime output
AS
-- Declarations
DECLARE 
	@FinancialYearMonth tinyint, @ThisMonth tinyint, @ThisYear int, @ThisQuarterMonth tinyint, @FinancialYear int,
	@StartYear smallint, @StartMonth smallint, @EndYear smallint, @EndMonth smallint

-- Get the financial year start month for this client
SELECT @FinancialYearMonth = FinancialYearStartMonth FROM TIndigoClientExtended WHERE IndigoClientId = @IndigoClientId

-- Get the current month and year
SELECT
	@ThisMonth = DATEPART(month, GETDATE()),
	@ThisYear = DATEPART(year, GETDATE()),
	@FinancialYear = @ThisYear

-- adjust the financial year if it started last year
IF @ThisMonth < @FinancialYearMonth
	SET @FinancialYear = @FinancialYear - 1

-- Get the starting month for this financial quarter (different if financial year started in a prior year)
IF @ThisMonth < @FinancialYearMonth
	SET @ThisQuarterMonth = @FinancialYearMonth + (((@ThisMonth + (12 - @FinancialYearMonth + 1)) / 3) * 3) - 13
ELSE
	SET @ThisQuarterMonth = @FinancialYearMonth + (((@ThisMonth - @FinancialYearMonth) / 3) * 3)

-- Get start month using the specified interval
SELECT @StartMonth = 
	CASE @Interval	
		WHEN 'Current Financial Quarter' THEN @ThisQuarterMonth			  
		WHEN 'Previous Financial Quarter' THEN @ThisQuarterMonth - 3
		WHEN 'Current and Next Financial Quarter' THEN @ThisQuarterMonth
		WHEN 'Next Financial Quarter' THEN @ThisQuarterMonth + 3
		WHEN 'Current and Next 3 Financial Quarters' THEN @ThisQuarterMonth
		ELSE @FinancialYearMonth -- Current Year, Current and Next, Current and Previous, Previous, Next
	END

-- Start year
SELECT @StartYear =
	CASE @Interval	
		WHEN 'Current Financial Year' THEN @FinancialYear
		WHEN 'Current and Next Financial Year' THEN @FinancialYear
		WHEN 'Current and Previous Financial Year' THEN @FinancialYear - 1
		WHEN 'Previous Financial Year' THEN @FinancialYear - 1
		WHEN 'Next Financial Year' THEN @FinancialYear + 1
		ELSE @ThisYear -- use this year for any interval involving quarters 
	END

-- End Month
SELECT @EndMonth = 
	CASE @Interval	
		WHEN 'Current Financial Quarter' THEN @ThisQuarterMonth + 3
		WHEN 'Previous Financial Quarter' THEN @ThisQuarterMonth
		WHEN 'Current and Next Financial Quarter' THEN @ThisQuarterMonth + 6
		WHEN 'Next Financial Quarter' THEN @ThisQuarterMonth + 6
		WHEN 'Current and Next 3 Financial Quarters' THEN @ThisQuarterMonth
		ELSE @FinancialYearMonth -- Current Year, Current and Next, Current and Previous, Previous, Next
	END

-- End Year
SELECT @EndYear =
	CASE @Interval			
		WHEN 'Current and Next 3 Financial Quarters' THEN @ThisYear + 1
		WHEN 'Current Financial Year' THEN @FinancialYear + 1
		WHEN 'Current and Next Financial Year' THEN @FinancialYear + 2
		WHEN 'Current and Previous Financial Year' THEN @FinancialYear + 1		
		WHEN 'Previous Financial Year' THEN @FinancialYear
		WHEN 'Next Financial Year' THEN @FinancialYear + 2
		ELSE @ThisYear -- Current Financial Quarter, Previous Financial Quarter, Current and Next Financial, Previous Financial Year, Previous Financial Year
	END

-- adjust the dates if we've moved into a new year
IF @StartMonth > 12
	SELECT @StartMonth = @StartMonth - 12, @StartYear = @StartYear + 1

-- just for previous quarter
IF @StartMonth <= 0
	SELECT @StartMonth = @StartMonth + 12, @StartYear = @StartYear - 1

-- adjust end date if we've advanced to a new year
IF @EndMonth > 12
	SELECT @EndMonth = @EndMonth - 12, @EndYear = @EndYear + 1

-- Finally build the dates
SELECT
	@StartDate = CAST(@StartYear AS varchar(4)) + '-' + CAST(@StartMonth AS varchar(2)) + '-01',
	@EndDate = CAST(@EndYear AS varchar(4)) + '-' + CAST(@EndMonth AS varchar(2)) + '-01'

SET @EndDate = DATEADD(second, -1, @EndDate)
GO
