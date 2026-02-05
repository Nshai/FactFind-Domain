SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrPortfolioReturn_Custom_Update]    
@AtrPortfolioReturnId bigint,    
@LowerReturn decimal(10,4),    
@MidReturn decimal(10,4),    
@UpperReturn decimal(10,4),    
@AtrPortfolio uniqueidentifier,    
@AtrRefPortfolioTerm bigint,    
@Guid uniqueidentifier    
    
    
    
AS    
  
DECLARE @StampUser varchar(255)  
  
SELECT @StampUser='999999998'        
    
    
BEGIN    
 Update TAtrPortfolioReturn     
 SET LowerReturn=@LowerReturn,MidReturn=@MidReturn,    
 UpperReturn=@UpperReturn    
 WHERE Guid=@Guid AND AtrPortfolioReturnId=@AtrPortfolioReturnId    
  
 EXEC FactFind..SpNAuditAtrPortfolioReturnCombined @StampUser,@AtrPortfolioReturnId,'U'  
    
 Update TAtrPortfolioReturnCombined     
 SET LowerReturn=@LowerReturn,MidReturn=@MidReturn,    
 UpperReturn=@UpperReturn    
 WHERE Guid=@Guid AND AtrPortfolioReturnId=@AtrPortfolioReturnId    
    
    
END    
GO
