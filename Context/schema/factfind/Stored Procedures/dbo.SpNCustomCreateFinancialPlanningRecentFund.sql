SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateFinancialPlanningRecentFund]  
 @StampUser varchar (255),  
 @UserId bigint,   
 @FundUnitId bigint,   
 @DataAdded datetime = getdate   
AS  
  
  
DECLARE @FinancialPlanningRecentFundId bigint, @Result int, @CRMContactId bigint, @StampAction char(1)  
  
select @CRMContactId = CRMContactId from administration..TUser where @UserId = UserId  
  
if (select 1 from TFinancialPlanningRecentFund where @CRMContactId = CRMContactId and @FundUnitId = FundUnitId) is null begin  
      
 INSERT INTO TFinancialPlanningRecentFund  
 (CRMContactId, FundUnitId, DataAdded, ConcurrencyId)  
 VALUES(@CRMContactId, @FundUnitId, @DataAdded, 1)  
  
 SELECT @FinancialPlanningRecentFundId = SCOPE_IDENTITY(), @Result = @@ERROR,@StampAction = 'C'   
end  
else begin  
   
 update TFinancialPlanningRecentFund  
 set  DataAdded = @DataAdded,  
   ConcurrencyId = ConcurrencyId +1  
 where @CRMContactId = @CRMContactId and @FundUnitId = FundUnitId  
  
 SELECT @FinancialPlanningRecentFundId = FinancialPlanningRecentFundId from TFinancialPlanningRecentFund  
   where @CRMContactId = @CRMContactId and @FundUnitId = FundUnitId  
 select @StampAction = 'U'   
  
end  
  
  
IF @Result != 0 GOTO errh  
  
  
Execute @Result = dbo.SpNAuditFinancialPlanningRecentFund @StampUser, @FinancialPlanningRecentFundId, @StampAction  
  
IF @Result  != 0 GOTO errh  
  
select * from TFinancialPlanningRecentFund where   
FinancialPlanningRecentFundId=@FinancialPlanningRecentFundId  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
