SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAtrCategoryQuestion]
 @StampUser varchar (255),      
 @AtrCategoryQuestionId bigint,      
 @StampAction char(1)      
AS      
    
  
INSERT INTO TAtrCategoryQuestionAudit     
(AtrCategoryQuestionId,AtrCategoryGuid,AtrQuestionGuid,AtrTemplateGuid,
	ConcurrencyId,StampAction,StampDateTime,StampUser)     
Select AtrCategoryQuestionId,AtrCategoryGuid,AtrQuestionGuid,AtrTemplateGuid,
	ConcurrencyId, @StampAction, GetDate(), @StampUser    
FROM TAtrCategoryQuestion    
WHERE AtrCategoryQuestionId = @AtrCategoryQuestionId    
    
IF @@ERROR != 0 GOTO errh    
    
RETURN (0)    
    
errh:    
RETURN (100)    

GO
