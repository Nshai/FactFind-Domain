SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditAtrTemplate]    
 @StampUser varchar (255),    
 @Guid uniqueidentifier,    
 @StampAction char(1)    
AS    
    
INSERT INTO TAtrTemplateAudit     
( Identifier, Descriptor, Active, HasModels, HasFreeTextAnswers, 
  BaseAtrTemplate, IndigoClientId, Guid, ConcurrencyId,     
      
 AtrTemplateId,AtrTemplateSyncId, StampAction, StampDateTime, StampUser)     
Select Identifier, Descriptor, Active, HasModels,  HasFreeTextAnswers,
  BaseAtrTemplate, IndigoClientId, Guid, ConcurrencyId,     
      
 AtrTemplateId,AtrTemplateSyncId, @StampAction, GetDate(), @StampUser    
FROM TAtrTemplate    
WHERE Guid = @Guid  
    
IF @@ERROR != 0 GOTO errh    
    
RETURN (0)    
    
errh:    
RETURN (100)    

GO
