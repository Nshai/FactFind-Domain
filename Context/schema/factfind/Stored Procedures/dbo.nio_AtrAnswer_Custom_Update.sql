SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrAnswer_Custom_Update]    
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
  
IF ISNULL(@AtrAnswerId,0)=0  
BEGIN  
 SELECT @AtrAnswerId=AtrAnswerId FROM TAtrAnswer WHERE Guid=@Guid  
END  
    
BEGIN    
 Update TAtrAnswer     
 SET Description=@Description,Ordinal=@Ordinal,    
 Weighting=@Weighting    
    
 WHERE Guid=@Guid AND AtrAnswerId=@AtrAnswerId    
  
EXEC FactFind..SpNAuditAtrAnswerCombined  @StampUser, @AtrAnswerId,'U'  
    
 Update TAtrAnswerCombined     
 SET Description=@Description,Ordinal=@Ordinal,    
 Weighting=@Weighting    
    
 WHERE Guid=@Guid AND AtrAnswerId=@AtrAnswerId    
    
END    
GO
