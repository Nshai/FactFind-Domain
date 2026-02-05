SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdatePlanPurpose]    
@PolicyBusinessId bigint,    
@PlanPurpose varchar(255)=null,    
@StampUser varchar(50),    
@PlanPurposeId bigint =null
    
as    
    
IF ISNULL(@PlanPurpose,'')<>''    
BEGIN    
 DECLARE @IndigoClientId bigint,@PolicyBusinessPurposeId bigint,@CurrentPlanPurposeId bigint    
    
 SELECT @IndigoClientId=IndigoClientId FROM PolicyManagement..TPolicyBusiness WITH(NOLOCK) WHERE PolicyBusinessId=@PolicyBusinessId    
 IF(@PlanPurposeId IS NULL)
 BEGIN
 SELECT @PlanPurposeId=PlanPurposeId FROM PolicyManagement..TPlanPurpose WHERE IndigoClientId=@IndigoClientId AND Descriptor=@PlanPurpose    
 END
 SELECT @PolicyBusinessPurposeId=MIN(PolicyBusinessPurposeId) FROM PolicyManagement..TPolicyBusinessPurpose WHERE PolicyBusinessId=@PolicyBusinessId    
 SELECT @CurrentPlanPurposeId=PlanPurposeId FROM  PolicyManagement..TPolicyBusinessPurpose WHERE PolicyBusinessPurposeId=@PolicyBusinessPurposeId    
     
 IF ISNULL(@PlanPurposeId,0)>0    
 BEGIN    
  IF ISNULL(@PolicyBusinessPurposeId,0)>0    
  BEGIN    
   IF @CurrentPlanPurposeId<>@PlanPurposeId    
   BEGIN  
    DECLARE @DuplicatePolicyBusinessPurposeId INT
    SELECT @DuplicatePolicyBusinessPurposeId = pbp.PolicyBusinessPurposeId
    FROM PolicyManagement..TPolicyBusinessPurpose pbp
    JOIN PolicyManagement..TPlanPurpose pp ON pbp.PlanPurposeId = pp.PlanPurposeId
    WHERE pp.Descriptor=@PlanPurpose AND pbp.PolicyBusinessId = @PolicyBusinessId
    IF @DuplicatePolicyBusinessPurposeId IS NOT NULL
    BEGIN
     INSERT  PolicyManagement..TPolicyBusinessPurposeAudit(PlanPurposeId,PolicyBusinessId,ConcurrencyId,PolicyBusinessPurposeId,StampAction,StampDateTime,StampUser)
     SELECT PlanPurposeId,PolicyBusinessId,ConcurrencyId,PolicyBusinessPurposeId,'U',GETDATE(),@StampUser
     FROM PolicyManagement..TPolicyBusinessPurpose
     WHERE PolicyBusinessPurposeId in (@PolicyBusinessPurposeId, @DuplicatePolicyBusinessPurposeId)
     UPDATE PolicyManagement..TPolicyBusinessPurpose
     SET PlanPurposeId = CASE
     WHEN PolicyBusinessPurposeId = @PolicyBusinessPurposeId THEN (SELECT PlanPurposeId FROM PolicyManagement..TPolicyBusinessPurpose WHERE PolicyBusinessPurposeId = @DuplicatePolicyBusinessPurposeId)
     WHEN PolicyBusinessPurposeId = @DuplicatePolicyBusinessPurposeId THEN (SELECT PlanPurposeId FROM PolicyManagement..TPolicyBusinessPurpose WHERE PolicyBusinessPurposeId = @PolicyBusinessPurposeId)
     END
     WHERE PolicyBusinessPurposeId in (@PolicyBusinessPurposeId, @DuplicatePolicyBusinessPurposeId)
    END
    ELSE
    BEGIN
     INSERT  PolicyManagement..TPolicyBusinessPurposeAudit(PlanPurposeId,PolicyBusinessId,ConcurrencyId,PolicyBusinessPurposeId,StampAction,StampDateTime,StampUser)    
     SELECT PlanPurposeId,PolicyBusinessId,ConcurrencyId,PolicyBusinessPurposeId,'U',GETDATE(),@StampUser    
     FROM PolicyManagement..TPolicyBusinessPurpose    
     WHERE PolicyBusinessPurposeId=@PolicyBusinessPurposeId    
     
     UPDATE PolicyManagement..TPolicyBusinessPurpose    
     SET PlanPurposeId=@PlanPurposeId    
     WHERE PolicyBusinessPurposeId=@PolicyBusinessPurposeId
    END
   END    
  END    
  ELSE    
  BEGIN    
   INSERT PolicyManagement..TPolicyBusinessPurpose(PlanPurposeId,PolicyBusinessId,ConcurrencyId)    
   SELECT @PlanPurposeId,@PolicyBusinessId,1    
   
   SET @PolicyBusinessPurposeId=SCOPE_IDENTITY()    
   
   INSERT PolicyManagement..TPolicyBusinessPurposeAudit(PlanPurposeId,PolicyBusinessId,ConcurrencyId,PolicyBusinessPurposeId,StampAction,StampDateTime,StampUser)    
   SELECT @PlanPurposeId,@PolicyBusinessId,1,@PolicyBusinessPurposeId,'C',GETDATE(),@StampUser     
     
  END    
 END    
END    
ELSE  
 BEGIN    
  SELECT @PolicyBusinessPurposeId=MIN(PolicyBusinessPurposeId) FROM PolicyManagement..TPolicyBusinessPurpose WHERE PolicyBusinessId=@PolicyBusinessId  
   IF ISNULL(@PolicyBusinessPurposeId,0)>0    
   BEGIN    
 INSERT  PolicyManagement..TPolicyBusinessPurposeAudit(PlanPurposeId,PolicyBusinessId,ConcurrencyId,PolicyBusinessPurposeId,StampAction,StampDateTime,StampUser)    
 SELECT PlanPurposeId,PolicyBusinessId,ConcurrencyId,PolicyBusinessPurposeId,'D',GETDATE(),@StampUser    
 FROM PolicyManagement..TPolicyBusinessPurpose    
 WHERE PolicyBusinessPurposeId=@PolicyBusinessPurposeId  
   
 DELETE FROM PolicyManagement..TPolicyBusinessPurpose   
 WHERE PolicyBusinessPurposeId=@PolicyBusinessPurposeId   
   END  
 END  
GO
