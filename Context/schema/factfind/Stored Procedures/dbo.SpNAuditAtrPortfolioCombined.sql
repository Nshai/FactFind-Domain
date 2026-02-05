SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrPortfolioCombined]  
 @StampUser varchar (255),  
 @AtrPortfolioId bigint,  
 @StampAction char(1)  
AS  
  
INSERT INTO TAtrPortfolioCombinedAudit   
(AtrPortfolioId,Identifier,AtrRefPortfolioTypeId,Active,AnnualReturn,Volatility,AtrTemplateGuid,IndigoClientId,IndigoClientGuid,ConcurrencyId,Guid,
	StampAction,StampDateTime,StampUser)   

Select AtrPortfolioId,Identifier,AtrRefPortfolioTypeId,Active,AnnualReturn,Volatility,AtrTemplateGuid,IndigoClientId,IndigoClientGuid,ConcurrencyId,Guid,
		@StampAction, GetDate(), @StampUser  
FROM TAtrPortfolioCombined  
WHERE AtrPortfolioId = @AtrPortfolioId  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
