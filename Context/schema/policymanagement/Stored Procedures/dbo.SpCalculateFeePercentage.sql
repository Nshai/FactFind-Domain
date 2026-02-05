SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================  
  
-- Create date: 27 Septmeber  
-- Description: Calculate the fee percentage based recurring frequency  
-- =============================================  
CREATE PROCEDURE dbo.SpCalculateFeePercentage  
  @feeId BIGINT  
  ,@feePercentage DECIMAL(18,2)  
  ,@tenant BIGINT  
  ,@feePercentageOutput DECIMAL(18,2) OUTPUT
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
 DECLARE @RecurrenceId BIGINT     
  
 -- Get Recurrence ID for the Fee  
 SET @RecurrenceId=(SELECT RecurringFrequencyId FROM TFee WHERE FeeId=@feeId AND IndigoClientId = @tenant )  
                 
 -- Convert the Per Annum Percentage to the corresponding percentage  
 SELECT @feePercentage =   
 CASE @RecurrenceId  
 -- Monthly   
 WHEN 1 THEN @feePercentage/12  
  
 -- Quarterly  
 WHEN 2 THEN @feePercentage/4  
  
 -- Bi- Annual  
 WHEN 3 THEN @feePercentage/2  
  
 -- Annual  
 WHEN 4 THEN @feePercentage    
 END  
	
 SELECT @feePercentageOutput = @feePercentage
 
  
END  
GO
