SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrMatrix]  
 @StampUser varchar (255),  
 @Guid uniqueidentifier,  
 @StampAction char(1)  
AS  
  
INSERT INTO TAtrMatrixAudit   
( AtrRefMatrixDurationId, ImmediateIncome, IndigoClientId, RiskProfileGuid,   
  AtrPortfolioGuid, AtrTemplateGuid, AtrMatrixTermGuid, Guid,   
  ConcurrencyId,   
 AtrMatrixId, StampAction, StampDateTime, StampUser)   
Select AtrRefMatrixDurationId, ImmediateIncome, IndigoClientId, RiskProfileGuid,   
  AtrPortfolioGuid, AtrTemplateGuid, AtrMatrixTermGuid, Guid,   
  ConcurrencyId,   
 AtrMatrixId, @StampAction, GetDate(), @StampUser  
FROM TAtrMatrix  
WHERE [Guid] = @Guid  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
