SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 /***************************************************************************************************
 Object:  StoredProcedure [dbo].[SpInstalmentDueDateForExistingRecords]    
 Script Date: 09/12/2012 12:08:34 
 Description: This stored procedure should be used only for RDRIV-151. 
 Migration script for calculating next instalment due date for existing records in PROD. 
 ****************************************************************************************************/

CREATE procedure [dbo].[SpInstalmentDueDateForExistingRecords]  
(  
@feeId bigint = 0,  
@startDate date,  
@lastDueDate date,  
@outputDate date = null OUTPUT   
)  
As  
begin   
     
   DECLARE @RecurrenceId bigint  
   DECLARE @NextDueDate date  
   DECLARE @currentDate date  
   DECLARE @bLastDay bit  
   DECLARE @MN int  
  
   -- GET RECURRENCE ID FOR THE FEE  
   SET @RecurrenceId=(SELECT RefFeeRetainerFrequencyId  
                      FROM TFee  
                      WHERE FeeId=@feeId)  
     
   SET @bLastDay=0    
   
    
  -- IS THE START DATE THE LAST DAY OF THE MONTH  
  IF MONTH(DATEADD(day,1,@StartDate))=MONTH(@StartDate)+1   
  BEGIN  
        SET @bLastDay=1  
  END  
   
           
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
  
 IF (@RecurrenceId=2 AND @bLastDay=1)  
  BEGIN  
   SET @MN=MONTH(@NextDueDate)  
   WHILE DAY(@NextDueDate)<31  
   BEGIN  
      SET @NextDueDate=DATEADD(day,1,@NextDueDate)  
      IF MONTH(@NextDueDate)<>@MN   
      BEGIN  
      SET @NextDueDate=DATEADD(day,-1,@NextDueDate)  
      BREAK  
      END  
   END  
         
   END  
  ELSE  
   IF (@RecurrenceId=2 AND (DAY(@StartDate)>DAY(@LastDueDate)))  
   BEGIN  
      SET @MN=MONTH(@NextDueDate)  
      WHILE DAY(@NextDueDate)<31  
      BEGIN  
      SET @NextDueDate=DATEADD(day,1,@NextDueDate)  
      IF DAY(@NextDueDate)=DAY(@StartDate)  
      BEGIN  
         BREAK  
      END  
      END  
  
   END  
     
      
 SET @LastDueDate = @NextDueDate   
   
     
  
    select @NextDueDate as NextDueDate  
      
    set @outputDate = @NextDueDate  
      
      
END  
   
  
  
  
  
GO
