SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[FnConvertFrequency]
(
@ToFrequency varchar(50),       
@FromFrequency varchar(50),
@Amount money 
)    
RETURNS money
AS
BEGIN

IF @Amount IS NULL  
RETURN NULL

DECLARE @CalculatedAmount money,
		@Freq_Conv Bigint,
		@Annually varchar(50) = 'Annually',
		@HalfYearly varchar(50) = 'Half Yearly',
		@HalfYearlyWithoutSpace varchar(50) = 'HalfYearly',		
		@Quarterly varchar(50) = 'Quarterly',
		@Monthly varchar(50) = 'Monthly',
		@FourWeekly varchar(50) = 'Four Weekly',
		@FourWeeklyWithoutSpace varchar(50) = 'FourWeekly',		
		@Fortnightly varchar(50) = 'Fortnightly',
		@Weekly varchar(50) = 'Weekly'
		
IF @ToFrequency= @FromFrequency OR
   @ToFrequency NOT IN (@Annually,@HalfYearly,@HalfYearlyWithoutSpace, @Quarterly,@Monthly, @FourWeekly, @FourWeeklyWithoutSpace, @Fortnightly, @Weekly) OR 
   @FromFrequency NOT IN (@Annually,@HalfYearly,@HalfYearlyWithoutSpace, @Quarterly,@Monthly, @FourWeekly, @FourWeeklyWithoutSpace, @Fortnightly, @Weekly) OR
   @ToFrequency IS NULL 
   RETURN (@Amount)


IF(@ToFrequency IN (@Annually,@HalfYearly,@HalfYearlyWithoutSpace,@Quarterly,@Monthly))
	BEGIN
		SELECT @Freq_Conv = CASE @ToFrequency
							WHEN @Annually Then 1
							WHEN @HalfYearly Then 2
							WHEN @HalfYearlyWithoutSpace Then 2							
							WHEN @Quarterly  Then 4
							WHEN @Monthly  Then 12
							END
		SELECT @CalculatedAmount = CASE @FromFrequency
				 WHEN @Weekly THEN @Amount * 52 / @Freq_Conv
				 WHEN @Fortnightly THEN @Amount * 26 / @Freq_Conv
				 WHEN @FourWeekly THEN @Amount * 13 / @Freq_Conv
				 WHEN @FourWeeklyWithoutSpace THEN @Amount * 13 / @Freq_Conv				 
				 WHEN @Monthly THEN @Amount * 12 / @Freq_Conv
				 WHEN @Quarterly THEN @Amount * 4 / @Freq_Conv
				 WHEN @HalfYearly THEN @Amount * 2 / @Freq_Conv
				 WHEN @HalfYearlyWithoutSpace THEN @Amount * 2 / @Freq_Conv				 
				 WHEN @Annually THEN @Amount * 1 / @Freq_Conv
				 ELSE @Amount 
			   END 
    
	END
ELSE
	BEGIN
		SELECT @Freq_Conv = CASE @ToFrequency
							WHEN @FourWeekly  Then 1
							WHEN @FourWeeklyWithoutSpace  Then 1							
							WHEN @Fortnightly  Then 2
							WHEN @Weekly Then 4		
							END
 		SELECT @CalculatedAmount = CASE @FromFrequency
				 WHEN @Weekly THEN @Amount * 4 / @Freq_Conv
				 WHEN @Fortnightly THEN @Amount * 2 / @Freq_Conv
				 WHEN @FourWeekly THEN @Amount * 1 / @Freq_Conv
				 WHEN @FourWeeklyWithoutSpace THEN @Amount * 1 / @Freq_Conv				 
				 WHEN @Monthly THEN @Amount * 0.92 / @Freq_Conv
				 WHEN @Quarterly THEN @Amount / 13 * 4 / @Freq_Conv
				 WHEN @HalfYearly THEN @Amount / 26 * 4 / @Freq_Conv
				 WHEN @HalfYearlyWithoutSpace THEN @Amount / 26 * 4 / @Freq_Conv				 
				 WHEN @Annually THEN @Amount / 52 * 4 / @Freq_Conv 
				 ELSE @Amount
				 END
	END
RETURN(@CalculatedAmount)
END
GO




	  