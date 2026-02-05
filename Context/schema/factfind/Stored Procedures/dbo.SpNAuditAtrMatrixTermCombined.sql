SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrMatrixTermCombined]  
 @StampUser varchar (255),  
 @AtrMatrixTermId bigint,  
 @StampAction char(1)  
AS  
  
INSERT INTO TAtrMatrixTermCombinedAudit   
(AtrMatrixTermId,Identifier,Ordinal,Starting,Ending,IndigoClientId,IndigoClientGuid,AtrTemplateGuid,ConcurrencyId,Guid,
	StampAction,StampDateTime,StampUser)   

Select AtrMatrixTermId,Identifier,Ordinal,Starting,Ending,IndigoClientId,IndigoClientGuid,AtrTemplateGuid,ConcurrencyId,Guid,
		@StampAction, GetDate(), @StampUser  
FROM TAtrMatrixTermCombined  
WHERE AtrMatrixTermId = @AtrMatrixTermId  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
