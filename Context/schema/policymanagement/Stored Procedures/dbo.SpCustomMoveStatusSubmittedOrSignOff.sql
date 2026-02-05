SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SpCustomMoveStatusSubmittedOrSignOff]    
 @LifeCycleId Bigint,    
 @PolicyBusinessId bigint    
AS    
    
 Declare @NewStatus bigint    
 Declare @Type varchar(50)    
 Declare @Today datetime  
  
 IF (SELECT CHARINDEX('G60',Descriptor) From TLifeCycle Where LifeCycleId = @LifeCycleId) > 0 --G60 Plan    
  BEGIN    
   Select @NewStatus = B.StatusId From TLifeCycleStep A INNER JOIN TStatus B ON A.StatusId = B.StatusId Where LifeCycleId = @LifeCycleId AND B.IntelligentOfficeStatusType = 'G60 sign off'    
   Select @Type = 'G60'    
  END    
 ELSE    
  BEGIN    
--   Select @NewStatus = B.StatusId From TLifeCycleStep A INNER JOIN TStatus B ON A.StatusId = B.StatusId Where LifeCycleId = @LifeCycleId AND B.IntelligentOfficeStatusType = 'Submitted to Provider'    
   Select @NewStatus = B.StatusId From TLifeCycleStep A INNER JOIN TStatus B ON A.StatusId = B.StatusId Where LifeCycleId = @LifeCycleId AND B.SystemSubmitFg  = 1  
   Select @Type = 'Other'    
  END    
 Select @Today = GetDate()  
 Exec SpCustomCreateStatusHistory 0,@PolicyBusinessId,@NewStatus,NULL,@Today,0,@Today,1    
    
 SELECT @Type AS 'AdviceType' FOR XML RAW
GO
