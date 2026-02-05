SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO 
  
/*
Modification History (most recent first)
Date        Modifier        Issue          Description
----        ---------       -------        -------------
20231005    Shruthy C S     SE-2371        Created SP to check plan has expected payment date
*/
CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckPlanExpectedPaymentDate]    
  @PolicyBusinessId int,    
  @ErrorMessage varchar(512) output    
AS    
    
BEGIN    
  
    --make sure that the plan has expected payment date    
    DECLARE @ExpectedPaymentDate datetime 
  
    SELECT @ExpectedPaymentDate = ExpectedPaymentDate    
    FROM TPolicyBusiness    
    WHERE PolicyBusinessId = @PolicyBusinessId    
  
    IF(@ExpectedPaymentDate IS NULL OR @ExpectedPaymentDate < CONVERT(datetime,'1900-01-01'))    
        SELECT @ErrorMessage = 'EXPECTEDPAYMENTDATE'      
END 

GO