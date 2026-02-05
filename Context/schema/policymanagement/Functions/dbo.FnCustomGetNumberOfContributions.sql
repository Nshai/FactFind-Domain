SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  [dbo].[FnCustomGetNumberOfContributions](@StartDate datetime, @EndDate datetime, @RefFrequencyId int)
RETURNS int
AS
BEGIN

DECLARE 
	@NumberOfContributions int,
	@CurrentDate datetime

SELECT
	@NumberOfContributions = 
	CASE
		WHEN @RefFrequencyId = 9 THEN 1 -- single
		WHEN @RefFrequencyId = 10 THEN 1 -- single
		WHEN @RefFrequencyId = 1 THEN DATEDIFF(day, @StartDate, @EndDate) / 7 + 1 -- weekly
		WHEN @RefFrequencyId = 2 THEN DATEDIFF(day, @StartDate, @EndDate) / 14 + 1 -- fortnightly
		WHEN @RefFrequencyId = 3 THEN DATEDIFF(day, @StartDate, @EndDate) / 28 + 1 -- four weekly
		WHEN @RefFrequencyId = 4 THEN -- monthly
			CASE -- need to check which date of the month we're on (e.g. 08-jan to 08-feb = 2 payments)
				WHEN DATEPART(day, @EndDate) >= DATEPART(day, @StartDate) THEN
					DATEDIFF(month, @StartDate, @EndDate) + 1
				ELSE
					DATEDIFF(month, @StartDate, @EndDate)
			END
		WHEN @RefFrequencyId > 4 AND @RefFrequencyId <= 8 THEN -- querterly, bi-annual, annual			
			CASE -- need to check which date of the month we're (e.g. 29-jan to 02-Apr would give 3 month intervals but shouldn't constitute a quarter)
				WHEN DATEPART(day, @EndDate) >= DATEPART(day, @StartDate) THEN
					DATEDIFF(month, @StartDate, @EndDate)
				ELSE
					DATEDIFF(month, @StartDate, @EndDate) - 1
			END			
		ELSE 0
	END

-- convert months to quarters / half year / year
IF @RefFrequencyId > 4 AND @RefFrequencyId <= 8
	SELECT
		@NumberOfContributions = 
		CASE	
			WHEN @RefFrequencyId = 5 THEN @NumberOfContributions / 3 + 1 -- quarterly
			WHEN @RefFrequencyId = 6 THEN @NumberOfContributions / 4 + 1 -- termly
			WHEN @RefFrequencyId = 7 THEN @NumberOfContributions / 6 + 1 -- bi-annual
			WHEN @RefFrequencyId = 8 THEN @NumberOfContributions / 12 + 1 -- annual	
		END

RETURN ISNULL(@NumberOfContributions, 0)
END

GO
