SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--DROP procedure [dbo].[SpCalculateRecurringContributionFee]

CREATE procedure [dbo].[SpCalculateRecurringContributionFee]
@PolicyBusinessId bigint,
@FeeId bigint,
@FeePercentage decimal(18,2), -- This will come converted from Annual.
@DiscountPercentage decimal(18,2),
@VATPercentage decimal(18,2),
@VATExcempt bit,
@TenantId bigint,
@RefContributionTypeId bigint = null,
@CurrentUserDate datetime
AS

BEGIN
  
-- calculate current monthly contributions  
declare @CurrentRegularContributions money, 
        @CurrentLumpSumContributions money,
        @TotalContributionFee money,
        @TotalDiscountAmount money,
        @VATAmount money,
        @CurrentYearlyRegularContributions money,
        @TotalFeeAmount money,
        @NetFeeAmount money,
        @CalculatedOnAmount money,
		@lastDueDate datetime
        
-- Get the Fee Frequency & use for future calculations
DECLARE @RecurrenceId BIGINT 
SET @RecurrenceId=(SELECT RecurringFrequencyId FROM TFee WHERE FeeId=@feeId AND IndigoClientId = @tenantId)           

--1. Calculate the regular contribution on an annual basis
select @CurrentYearlyRegularContributions =   
 SUM(  
  case rf.RefFrequencyId  
  when 1 then (pmi.Amount * 52) --weekly  
  when 2 then (pmi.Amount * 26) --fortnightly  
  when 3 then (pmi.Amount * 13) --four weekly  
  when 4 then (pmi.amount * 12) -- monthly  
  when 5 then (pmi.Amount * 4 ) --quaterly  
  when 7 then (pmi.amount * 2 ) --half yearly  
  when 8 then (pmi.Amount * 1 ) -- annually  
 end   
 )  
 from TPolicyMoneyIn pmi  
 join TRefFrequency rf on rf.RefFrequencyId = pmi.RefFrequencyId  
 where PolicyBusinessId = @PolicyBusinessId  
 and rf.RefFrequencyId < 10  
 and (CAST(@CurrentUserDate AS DATE) >= CAST(pmi.StartDate AS DATE) and 
     (CAST(@CurrentUserDate AS DATE) <= CAST(pmi.stopdate AS DATE) or pmi.stopdate is null)) -- Current Date Between Start Date and End Date  
 and pmi.IsOngoingFee = 1  --Consider only those contribution which have IsOnGoingFee = 1 
 and (pmi.RefContributionTypeId = @RefContributionTypeId OR @RefContributionTypeId IS NULL)
 
 
-- Convert the regular contribution to match the Fee Frequency
-- Removed after a discussion with Sumit.
    
-- calculate lump sum contributions (Frequency is always single) 
-- -- Check The Contribution Type as LumpSum.
-- Consider only those contribution which have IsOnGoingFee = 1
select @CurrentLumpSumContributions =   
 SUM(pmi.Amount)  
 from TPolicyMoneyIn pmi  
 join TRefFrequency rf on rf.RefFrequencyId = pmi.RefFrequencyId  
 where PolicyBusinessId = @PolicyBusinessId  
 and rf.RefFrequencyId = 10 
 and pmi.IsOngoingFee = 1     --Consider only those contribution which have IsOnGoingFee = 1
 and (pmi.RefContributionTypeId = @RefContributionTypeId OR @RefContributionTypeId IS NULL)
 
-- Find the Calculated On Amount First
--set @CalculatedOnAmount = isnull(@CurrentLumpSumContributions,0) + isnull(@CurrentRegularContributions,0)

set @CalculatedOnAmount = isnull(@CurrentLumpSumContributions,0) + isnull(@CurrentYearlyRegularContributions,0)

--Total fee is (Regular + Lumpsum) * FeePercentage
set @TotalContributionFee = @CalculatedOnAmount * isnull(@FeePercentage,0) / 100

-- Adjust the Fee based on the Fee Frequency
SELECT @TotalContributionFee = 
CASE @RecurrenceId
	-- Monthly 
	WHEN 1 THEN @TotalContributionFee/12
	-- Quarterly
	WHEN 2 THEN @TotalContributionFee/4
	-- Bi- Annual
	WHEN 3 THEN @TotalContributionFee/2
	-- Annual
	WHEN 4 THEN @TotalContributionFee  
END

-- Discount is TotalFee * Discount Percentage
set @TotalDiscountAmount = isnull(@DiscountPercentage,0) * @TotalContributionFee / 100

-- Net Fee is Total Fee - Discount
set @NetFeeAmount = @TotalContributionFee - @TotalDiscountAmount

-- If VAT Exempt is set, VATAmount = 0
if (@VATExcempt = 1)
    set @VATAmount = 0
else
	--VAT is Net Fee * VAT Percentage
	set @VATAmount = isnull(@VATPercentage,0) * @NetFeeAmount / 100
	
-- Total Fee is Net Fee + VAT Amount.
set @TotalFeeAmount = @NetFeeAmount + @VATAmount 

select @lastDueDate = NextExpectationDate
		from TFeeRecurrence
		where FeeId = @FeeId

SET @lastDueDate = ISNULL(@lastDueDate, @CurrentUserDate)

-- Insert the Redords into TExpectations
 --Insert Record to Expectations
  INSERT INTO TExpectations
           ([PolicyBusinessId]
           ,[FeeId]
           ,[Date]
           ,[NetAmount]
           ,[TotalAmount]
           ,[CalculatedAmount]
           ,[TenantId]           )
     VALUES
           (@policyBusinessId
           ,@feeId
           ,@lastDueDate
           ,@NetFeeAmount
           ,@TotalFeeAmount
           ,@CalculatedOnAmount
           ,@TenantId)  
           
   -- Get the Expectation Id and Insert a record into the Audit Table
   -- SELECT SCOPE_IDENTITY()
   INSERT INTO TExpectationsAudit
           ([PolicyBusinessId]
           ,[FeeId]
           ,[Date]
           ,[NetAmount]
           ,[TotalAmount]
           ,[CalculatedAmount]
           ,[TenantId]
           ,ExpectationsId
           ,StampAction
           ,StampDateTime
           ,StampUser)           
     VALUES
           (@policyBusinessId
           ,@feeId
           ,@lastDueDate
           ,@NetFeeAmount
           ,@TotalFeeAmount
           ,@CalculatedOnAmount
           ,@TenantId
           ,SCOPE_IDENTITY()
           ,'C'
           ,GETDATE()
           ,0)

END    
GO
