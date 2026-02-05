SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrAnswerCombined_Custom_Update]    
  @Description varchar(500),  
  @Ordinal int,  
  @Weighting int,  
  @IndigoClientGuid uniqueidentifier,  
  @ConcurrencyId bigint,  
  @AtrAnswerId bigint,    
  @TenantId bigint,     
  @Guid uniqueidentifier    
AS    
    
BEGIN     
   
   IF NOT EXISTS(SELECT AtrAnswerId FROM TAtrAnswerCombined WHERE Guid=@Guid)  
   BEGIN  
    INSERT INTO TAtrAnswerCombined (    
   Guid,  
   AtrAnswerId,  
   Description,  
   Ordinal,  
   Weighting,  
   AtrQuestionGuid,  
   IndigoClientId,  
   IndigoClientGuid,  
   ConcurrencyId)    
    SELECT    
   A.Guid,    
   A.AtrAnswerId,    
   A.Description,    
   A.Ordinal,    
   A.Weighting,    
   A.AtrQuestionGuid,       
   I.IndigoClientId,    
   I.Guid,  
   A.ConcurrencyId    
    FROM    
   TAtrAnswer A    
   JOIN Administration..TIndigoClient I ON I.IndigoClientId = A.IndigoClientId    
    WHERE    
   A.Guid = @Guid   
   END  
   ELSE  
   BEGIN  
  UPDATE A  
   SET Description=B.Description,  
    Ordinal=B.Ordinal,  
    Weighting=B.Weighting  
  
  
  FROM TAtrAnswerCombined A  
  JOIN TAtrAnswer B ON A.Guid=B.Guid  
  
   END   
    
END    
 SELECT @Guid  
  
  
EndProcedure: 
GO
