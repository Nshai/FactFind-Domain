SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  [dbo].[FnCustomRetrieveContributionToDate](
	@StartDate datetime, @StopDate datetime, @RefFrequencyId bigint, @Amount money)
RETURNS money
AS
BEGIN

DECLARE 
	@CurrentDate datetime
	
SET @CurrentDate = GETDATE()

-- Adjust stop date
SELECT
	@StopDate = 
	CASE 
		WHEN @StopDate IS NULL THEN @CurrentDate
		WHEN @StopDate > @CurrentDate THEN @CurrentDate
		ELSE @StopDate
	END
			
RETURN
	CASE
		-- single frequencies
		WHEN @RefFrequencyId = 9 THEN @Amount
		WHEN @RefFrequencyId = 10 THEN @Amount
		-- Cases where the contribution will be zero		
		WHEN @StartDate IS NULL THEN 0 
		WHEN @StartDate > @CurrentDate THEN 0
		WHEN ISNULL(@Amount, 0) = 0 THEN 0
		WHEN @StartDate > @StopDate THEN 0
		-- Cases where we need to calculate using the frequency
		ELSE @Amount * dbo.FnCustomGetNumberOfContributions(@StartDate, @StopDate, @RefFrequencyId)
	END
END
GO
