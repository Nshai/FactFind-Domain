SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrAnswer]  
 @StampUser varchar (255),  
 @Guid uniqueidentifier, 
 @StampAction char(1)  
AS  
  
INSERT INTO TAtrAnswerAudit   
( Description, Ordinal, Weighting, AtrQuestionGuid,   
  IndigoClientId, Guid, ConcurrencyId,   
 AtrAnswerId,AtrAnswerSyncId, StampAction, StampDateTime, StampUser)   
Select Description, Ordinal, Weighting, AtrQuestionGuid,   
  IndigoClientId, Guid, ConcurrencyId,   
 AtrAnswerId,AtrAnswerSyncId, @StampAction, GetDate(), @StampUser  
FROM TAtrAnswer  
WHERE Guid = @Guid  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
