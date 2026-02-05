SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create FUNCTION [dbo].[fn_ExpectationsDueDate]  (@LastDueDate datetime, @currentDate datetime, @RecurringFrequencyId int)
RETURNS datetime
AS
BEGIN
	IF @LastDueDate IS NULL 
		RETURN NULL;

	IF @RecurringFrequencyId IS NULL 
		RETURN NULL;

	IF @currentDate IS NULL
		SET @currentDate = GETDATE();

   DECLARE @NextDueDate datetime
   DECLARE @initialDate datetime

  
  IF @LastDueDate >= @currentDate
	RETURN @LastDueDate
  
  SET @NextDueDate = @LastDueDate
  SET @initialDate = @LastDueDate
   
  WHILE (@NextDueDate < @currentDate) 
  BEGIN
  
	  SELECT @NextDueDate= 
		 CASE @RecurringFrequencyId
		WHEN 1 THEN DATEADD(month, 1, @LastDueDate)
		WHEN 2 THEN DATEADD(month, 3, @LastDueDate)
		WHEN 3 THEN DATEADD(month, 6, @LastDueDate)
		WHEN 4 THEN DATEADD(year, 1, @LastDueDate)
		END
		
		SELECT @NextDueDate = 				
		CASE 
			--If the DAY of the Start date IS the same as the DAY of teh END OF THE MONTH, then return the END OF THE MONTH of the next date
			--Unless for Feb the last day could be leap year so just account for that too
			WHEN MONTH(@initialDate) = 2 And  Day(@initialDate) in(28,29) THEN EOMONTH(@NextDueDate) 
			WHEN MONTH(@initialDate) != 2 AND Day(@initialDate) = DAY(EOMONTH(@initialDate)) THEN EOMONTH(@NextDueDate) 
			-- Not end of any month, but the day of the next date is less than the day of teh start date , EG: 30 Jan, 28 Feb to 30 March !!!
			WHEN MONTH(@NextDueDate) != 2 AND DAY(@initialDate) > Day(@NextDueDate) THEN Cast(cast(Day(@initialDate) as varchar(5)) + ' ' + Convert(char(3), @NextDueDate, 0) + ' ' + cast(YEAR(@NextDueDate) as varchar(5)) as Date) 
			--Otherwise just reurn the next Date
			ELSE @NextDueDate 
		END 
		
		SET @LastDueDate = @NextDueDate	
	
	END     

    RETURN (@NextDueDate)
END

GO
