SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrMatrixCombined]  
 @StampUser varchar (255),  
 @AtrMatrixId bigint,  
 @StampAction char(1)  
AS  
  
INSERT INTO TAtrMatrixCombinedAudit   
(AtrMatrixId,ImmediateIncome,IndigoClientId,IndigoClientGuid,RiskProfileGuid,AtrPortfolioGuid,AtrTemplateGuid,AtrMatrixTermGuid,Guid,ConcurrencyId,
	StampAction,StampDateTime,StampUser)   

Select AtrMatrixId,ImmediateIncome,IndigoClientId,IndigoClientGuid,RiskProfileGuid,AtrPortfolioGuid,AtrTemplateGuid,AtrMatrixTermGuid,Guid,ConcurrencyId,
		@StampAction, GetDate(), @StampUser  
FROM TAtrMatrixCombined  
WHERE AtrMatrixId = @AtrMatrixId  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
