SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrAnswerCombined]  
 @StampUser varchar (255),  
 @AtrAnswerId bigint,  
 @StampAction char(1)  
AS  
  
INSERT INTO TAtrAnswerCombinedAudit   
(AtrAnswerId,Description,Ordinal,Weighting,AtrQuestionGuid,IndigoClientId,IndigoClientGuid,ConcurrencyId,Guid,
	StampAction,StampDateTime,StampUser)   

Select AtrAnswerId,Description,Ordinal,Weighting,AtrQuestionGuid,IndigoClientId,IndigoClientGuid,ConcurrencyId,Guid,
		@StampAction, GetDate(), @StampUser  
FROM TAtrAnswerCombined  
WHERE AtrAnswerId = @AtrAnswerId  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
