SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  [dbo].[FnCustomGetPolicyDuration](@StartDate datetime, @EndDate datetime, @RefFrequencyId int)
RETURNS decimal(10,2)
AS
BEGIN

DECLARE 
	@Duration decimal(10,2)

IF @EndDate IS NULL
	SELECT @EndDate = GETDATE()

SELECT
	@Duration = 
	CASE
		WHEN @StartDate IS NULL THEN NULL
		WHEN @StartDate >= @EndDate THEN NULL
		WHEN @RefFrequencyId = 9 THEN 1 -- single
		WHEN @RefFrequencyId = 10 THEN 1 -- single
		WHEN @RefFrequencyId = 1 THEN DATEDIFF(day, @StartDate, @EndDate) / 7 + 1 -- weekly
		WHEN @RefFrequencyId = 2 THEN DATEDIFF(day, @StartDate, @EndDate) / 14 + 1 -- fortnightly
		WHEN @RefFrequencyId = 3 THEN DATEDIFF(day, @StartDate, @EndDate) / 28 + 1 -- four weekly
		WHEN @RefFrequencyId >= 4 AND @RefFrequencyId <= 8 THEN -- treat all these as months
			CASE -- need to check which date of the month we're on
				WHEN DATEPART(day, @EndDate) >= DATEPART(day, @StartDate) THEN
					DATEDIFF(month, @StartDate, @EndDate) + 1
				ELSE
					DATEDIFF(month, @StartDate, @EndDate)
			END
		ELSE 0
	END

-- convert months to quarters / half year / year
IF @RefFrequencyId > 4 AND @RefFrequencyId <= 8 AND @Duration IS NOT NULL
	SELECT
		@Duration = 
		CASE	
			WHEN @RefFrequencyId = 5 THEN @Duration / 3.0
			WHEN @RefFrequencyId = 6 THEN @Duration		 -- termly?
			WHEN @RefFrequencyId = 7 THEN @Duration / 6.0
			WHEN @RefFrequencyId = 8 THEN @Duration / 12.0
		END

IF @Duration = 0
	SET @Duration = NULL

RETURN @Duration
END
GO
