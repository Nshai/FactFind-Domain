SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrQuestionCombined]  
 @StampUser varchar (255),  
 @AtrQuestionId bigint,  
 @StampAction char(1)  
AS  
  
INSERT INTO TAtrQuestionCombinedAudit   
(AtrQuestionId,Description,Ordinal,Investment,Retirement,Active,AtrTemplateGuid,IndigoClientId,IndigoClientGuid,ConcurrencyId,Guid,
	StampAction,StampDateTime,StampUser)   

Select AtrQuestionId,Description,Ordinal,Investment,Retirement,Active,AtrTemplateGuid,IndigoClientId,IndigoClientGuid,ConcurrencyId,Guid,
		@StampAction, GetDate(), @StampUser  
FROM TAtrQuestionCombined  
WHERE AtrQuestionId = @AtrQuestionId  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
