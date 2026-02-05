SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAtrQuestion]
 @StampUser varchar (255),      
 @Guid uniqueidentifier,      
 @StampAction char(1)      
AS      
    
  
INSERT INTO TAtrQuestionAudit     
( Description, Ordinal, Investment, Retirement,     
  Active, AtrTemplateGuid, IndigoClientId, Guid,     
  ConcurrencyId,     
 AtrQuestionId,AtrQuestionSyncId, StampAction, StampDateTime, StampUser)     
Select Description, Ordinal, Investment, Retirement,     
  Active, AtrTemplateGuid, IndigoClientId, Guid,     
  ConcurrencyId,     
 AtrQuestionId, AtrQuestionSyncId,@StampAction, GetDate(), @StampUser    
FROM TAtrQuestion    
WHERE Guid = @Guid    
    
IF @@ERROR != 0 GOTO errh    
    
RETURN (0)    
    
errh:    
RETURN (100)    

GO
