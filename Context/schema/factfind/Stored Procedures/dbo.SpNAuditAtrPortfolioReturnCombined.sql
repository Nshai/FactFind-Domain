SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrPortfolioReturnCombined]  
 @StampUser varchar (255),  
 @AtrPortfolioReturnId bigint,  
 @StampAction char(1)  
AS  
  
INSERT INTO TAtrPortfolioReturnCombinedAudit   
(AtrPortfolioReturnId,AtrPortfolioGuid,AtrRefPortfolioTermId,LowerReturn,MidReturn,UpperReturn,ConcurrencyId,Guid,
	StampAction,StampDateTime,StampUser)   

Select AtrPortfolioReturnId,AtrPortfolioGuid,AtrRefPortfolioTermId,LowerReturn,MidReturn,UpperReturn,ConcurrencyId,Guid,
		@StampAction, GetDate(), @StampUser  
FROM TAtrPortfolioReturnCombined  
WHERE AtrPortfolioReturnId = @AtrPortfolioReturnId  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
