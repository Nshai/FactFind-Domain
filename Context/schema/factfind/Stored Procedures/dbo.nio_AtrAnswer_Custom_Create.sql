SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrAnswer_Custom_Create]    
@AtrAnswerId bigint=null,    
@Description varchar(255),    
@Ordinal int,    
@Weighting int,    
@TenantGuid uniqueidentifier,    
@AtrQuestion uniqueidentifier,    
@IndigoClientId bigint,    
@Guid uniqueidentifier    
    
AS    
  
DECLARE @StampUser varchar(255)  
  
SELECT @StampUser='999999998'    
    
BEGIN    
 INSERT TAtrAnswer(     
 Description,    
 Ordinal,    
 Weighting,    
 AtrQuestionGuid,    
 IndigoClientId,    
 Guid,    
 ConcurrencyId)    
    
 SELECT @Description, @Ordinal, @Weighting, @AtrQuestion, @IndigoClientId,@Guid, 1    
    
 SELECT @AtrAnswerId=SCOPE_IDENTITY()    
    
 INSERT TAtrAnswerCombined(     
 Guid,    
 AtrAnswerId,    
 Description,    
 Ordinal,    
 Weighting,    
 AtrQuestionGuid,    
 IndigoClientId,    
 IndigoClientGuid,    
 ConcurrencyId)    
    
 SELECT @Guid,@AtrAnswerId,@Description, @Ordinal, @Weighting, @AtrQuestion, @IndigoClientId,@TenantGuid, 1    
  
 EXEC FactFind..SpNAuditAtrAnswerCombined @StampUser,@AtrAnswerId,'C'  
    
    
END    
    
SELECT @Guid AS Guid    
GO
