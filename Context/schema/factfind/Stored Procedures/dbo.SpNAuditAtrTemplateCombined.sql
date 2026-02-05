SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditAtrTemplateCombined]  
 @StampUser varchar (255),  
 @AtrTemplateId bigint,  
 @StampAction char(1)  
AS  
  
INSERT INTO TAtrTemplateCombinedAudit   
(AtrTemplateId,Identifier,Descriptor,Active,HasModels,BaseAtrTemplate,IndigoClientId,IndigoClientGuid,HasFreeTextAnswers,
	ConcurrencyId,Guid,StampAction,StampDateTime,StampUser)   
Select AtrTemplateId,Identifier,Descriptor,Active,HasModels,BaseAtrTemplate,IndigoClientId,IndigoClientGuid,HasFreeTextAnswers,
	ConcurrencyId,Guid, @StampAction, GetDate(), @StampUser  
FROM TAtrTemplateCombined  
WHERE AtrTemplateId = @AtrTemplateId  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
