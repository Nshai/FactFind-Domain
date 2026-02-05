SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrPortfolioReturn]  
 @StampUser varchar (255),  
 @Guid uniqueidentifier,  
 @StampAction char(1)  
AS  
  
INSERT INTO TAtrPortfolioReturnAudit   
( AtrPortfolioGuid, AtrRefPortfolioTermId, LowerReturn, MidReturn,   
  UpperReturn, Guid, ConcurrencyId,   
 AtrPortfolioReturnId, StampAction, StampDateTime, StampUser)   
Select AtrPortfolioGuid, AtrRefPortfolioTermId, LowerReturn, MidReturn,   
  UpperReturn, Guid, ConcurrencyId,   
 AtrPortfolioReturnId, @StampAction, GetDate(), @StampUser  
FROM TAtrPortfolioReturn  
WHERE [Guid] = @Guid  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
