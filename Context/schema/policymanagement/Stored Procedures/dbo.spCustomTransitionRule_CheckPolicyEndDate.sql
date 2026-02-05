SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO 

/*
Modification History (most recent first)
Date        Modifier             Issue          Description
-----       ---------            -------        -------------
20231009    Ambika Lakshmi K S   SE-2465        Created SP to check plan has policy end date
*/
CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckPolicyEndDate]    
  @PolicyBusinessId int,    
  @ErrorMessage varchar(512) output    
AS    
    
BEGIN    
  
     --make sure that the plan has a policynumber    
     DECLARE @PolicyEndDate datetime  
  
     IF EXISTS (SELECT 1 FROM TGroupSchemeMember  
               WHERE PolicyBusinessId = @PolicyBusinessId) 
     BEGIN  
  
        SELECT @PolicyEndDate = LeavingDate    
        FROM TGroupSchemeMember  
        WHERE PolicyBusinessId = @PolicyBusinessId  
  
        IF(@PolicyEndDate IS NULL OR @PolicyEndDate < CONVERT(datetime,'1900-01-01'))    
           SELECT @ErrorMessage = 'LEAVINGDATE'    
     END  
     ELSE 
     BEGIN  
  
        SELECT @PolicyEndDate = MaturityDate    
        FROM TPolicyBusiness    
        WHERE PolicyBusinessId = @PolicyBusinessId    
  
        IF(@PolicyEndDate IS NULL OR @PolicyEndDate < CONVERT(datetime,'1900-01-01'))    
           SELECT @ErrorMessage = 'ENDDATE'    
  
       END  

END    

GO
