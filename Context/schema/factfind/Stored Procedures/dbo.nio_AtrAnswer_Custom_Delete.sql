SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrAnswer_Custom_Delete]    
@Guid uniqueidentifier    
    
AS    
  
DECLARE @AtrAnswerId bigint,@StampUser varchar(255)  
  
SELECT @AtrAnswerId=AtrAnswerId FROM TAtrAnswer WHERE Guid=@Guid  
  
SELECT @StampUser='999999998'    
    
BEGIN    
 DELETE FROM TAtrAnswer WHERE Guid=@Guid    
  
 EXEC FactFind..SpnAuditAtrAnswerCombined @StampUser,@AtrAnswerId,'D'  
     
 DELETE FROM TAtrAnswerCombined WHERE Guid=@Guid     
    
END    
GO
