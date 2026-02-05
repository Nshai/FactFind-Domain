SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrPortfolio]  
 @StampUser varchar (255),  
 @Guid uniqueidentifier,  
 @StampAction char(1)  
AS  
  
INSERT INTO TAtrPortfolioAudit   
( Identifier, AtrRefPortfolioTypeId, Active, AnnualReturn,   
  Volatility, AtrTemplateGuid, IndigoClientId, Guid,   
  ConcurrencyId,   
 AtrPortfolioId, StampAction, StampDateTime, StampUser)   
Select Identifier, AtrRefPortfolioTypeId, Active, AnnualReturn,   
  Volatility, AtrTemplateGuid, IndigoClientId, Guid,   
  ConcurrencyId,   
 AtrPortfolioId, @StampAction, GetDate(), @StampUser  
FROM TAtrPortfolio  
WHERE [Guid] = @Guid  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
