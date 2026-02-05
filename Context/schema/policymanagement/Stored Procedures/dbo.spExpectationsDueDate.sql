SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spExpectationsDueDate]
(
	@FeeId bigint = 0,
	@startDate date,
	@lastDueDate date,
	@CurrentUserDate datetime,
	@outputDate date = null OUTPUT 
)
AS
BEGIN

	DECLARE @RecurrenceId bigint
	DECLARE @NextDueDate date
	DECLARE @currentDate date
	DECLARE @bLastDay bit
	DECLARE @endDate date
	DECLARE @initialLastDueDate date

	-- Get Recurrence ID for the Fee
	SELECT @RecurrenceId=RecurringFrequencyId, @endDate = EndDate
	FROM TFee
	WHERE FeeId=@FeeId
   
	SET @bLastDay=0  
	SET @currentDate = @CurrentUserDate;
	SET @initialLastDueDate = @lastDueDate

	IF @endDate IS NOT NULL 
	BEGIN
		IF @currentDate > @endDate
			RETURN;
		IF @lastDueDate > @endDate
			RETURN;
	END 


	SET @NextDueDate = DATEADD(day,-1,@currentDate)
  
	--If start date is in the future or current date is a start date next due date should be the start date
	IF @startDate >= @currentDate
		SET @NextDueDate = @startDate

  -- Is the start date the last day of the month
	IF @StartDate=EOMONTH(@StartDate)
	BEGIN
		SET @bLastDay=1
	END
 
	WHILE (@NextDueDate < @currentDate) 
	BEGIN
		SELECT @NextDueDate= 
			CASE @RecurrenceId
				-- Monthly
				WHEN 1 THEN DATEADD(month,1,@LastDueDate)
				-- Quarterly
				WHEN 2 THEN DATEADD(month,3,@LastDueDate)
				-- Bi- Annual
				WHEN 3 THEN DATEADD(MONTH,6,@LastDueDate)
				-- BiAnnual
				WHEN 4 THEN DATEADD(year,1,@LastDueDate)  
			END

		SET @NextDueDate = 				
		CASE 
				-- Start date is Feb and the start date day IS the end of the month
			WHEN MONTH(@StartDate) = 2 And  Day(@StartDate) in(28,29) THEN EOMONTH(@NextDueDate) 
			-- Start date is NOT Feb and the start date day IS the end of the 
			WHEN MONTH(@StartDate) != 2 AND Day(@StartDate) = DAY(EOMonth(@StartDate)) THEN EOMONTH(@NextDueDate) 
			-- Not end of any month, but the day of the next date is less than the day of teh start date , EG: 30 Jan, 28 Feb to 30 March !!!
			WHEN MONTH(@NextDueDate) != 2 AND DAY(@startDate) > Day(@NextDueDate) THEN Cast(cast(Day(@startDate) as varchar(5)) + ' ' + Convert(char(3), @NextDueDate, 0) + ' ' + cast(YEAR(@NextDueDate) as varchar(5)) as Date) 
			--Otherwise just reurn the next Date
			ELSE @NextDueDate 
		END
		

		IF @endDate IS NOT NULL AND @NextDueDate > @endDate
		BEGIN
			RETURN;
		END


	SET @LastDueDate = @NextDueDate	
	END--while
   
    SET @outputDate = @NextDueDate
END
GO
