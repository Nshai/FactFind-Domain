SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrPortfolioReturn_Custom_Create]    
@LowerReturn decimal,    
@MidReturn decimal,    
@UpperReturn decimal,    
@AtrPortfolio uniqueidentifier,    
@AtrRefPortfolioTerm bigint,    
@Guid uniqueidentifier    
    
    
    
AS    
    
DECLARE @AtrPortfolioReturnId bigint    
DECLARE @StampUser varchar(255)

SELECT @StampUser='999999998'      
    
    
BEGIN    
 INSERT TAtrPortfolioReturn(     
 AtrPortfolioGuid,    
 AtrRefPortfolioTermId,    
 LowerReturn,    
 MidReturn,    
 UpperReturn,    
 Guid,    
 ConcurrencyId)    
    
 SELECT @AtrPortfolio,@AtrRefPortfolioTerm,@LowerReturn, @MidReturn, @UpperReturn, @Guid, 1    
    
 SELECT @AtrPortfolioReturnId=SCOPE_IDENTITY()    
    
 INSERT TAtrPortfolioReturnCombined(     
 Guid,    
 AtrPortfolioReturnId,    
 AtrPortfolioGuid,    
 AtrRefPortfolioTermId,    
 LowerReturn,    
 MidReturn,    
 UpperReturn,    
 ConcurrencyId)    
    
 SELECT @Guid,@AtrPortfolioReturnId,@AtrPortfolio, @AtrRefPortfolioTerm, @LowerReturn, @MidReturn, @UpperReturn,1    
    
	EXEC FactFind..SpNAuditAtrPortfolioReturnCombined @StampUser,@AtrPortfolioReturnId,'C'
    
END    
    
    
GO
