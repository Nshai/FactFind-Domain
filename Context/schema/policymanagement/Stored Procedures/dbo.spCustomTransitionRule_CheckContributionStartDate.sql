SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO 
  
/*
Modification History (most recent first)
Date        Modifier        Issue          Description
----        ---------       -------        -------------
20231127    Arun Sivan      SE-3023        Created SP to check the contributions have start date
*/
CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckContributionStartDate]    
  @PolicyBusinessId int,    
  @ErrorMessage varchar(512) output    
AS    
    
BEGIN    
  
    --make sure that the contributions have start date    
    
    IF((SELECT COUNT(PolicyMoneyInId)    
    FROM TPolicyMoneyIn    
    WHERE PolicyBusinessId = @PolicyBusinessId AND StartDate IS NULL) > 0)    
        SELECT @ErrorMessage = 'CONTRIBUTIONSTARTDATE'      
END 

GO