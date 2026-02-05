SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrPortfolio_Custom_Update]    
@AtrPortfolioId bigint=null,    
@Identifier varchar(255),    
@IsActive bit,    
@AnnualReturn decimal(10,4),    
@Volatility decimal(10,4),    
@TenantGuid uniqueidentifier,    
@IndigoClientId bigint,    
@ATRTemplate uniqueidentifier,    
@ATRRefPortfolioType bigint,    
@Guid uniqueidentifier    
    
    
    
AS    
    
    
BEGIN    
	 Update TAtrPortfolio     
	 SET Identifier=@Identifier,AtrRefPortfolioTypeId=@ATRRefPortfolioType,    
	 Active=@IsActive,AnnualReturn=@AnnualReturn,Volatility=@Volatility    
	 WHERE Guid=@Guid AND AtrPortfolioId=@AtrPortfolioId    

	 INSERT TAtrPortfolioCombinedAudit(
		AtrPortfolioId,
		Identifier,
		AtrRefPortfolioTypeId,
		Active,
		AnnualReturn,
		Volatility,
		AtrTemplateGuid,
		IndigoClientId,
		IndigoClientGuid,
		ConcurrencyId,
		Guid,
		StampAction,
		StampDateTime,
		StampUser)

		SELECT  
		AtrPortfolioId,
		Identifier,
		AtrRefPortfolioTypeId,
		Active,
		AnnualReturn,
		Volatility,
		AtrTemplateGuid,
		IndigoClientId,
		IndigoClientGuid,
		ConcurrencyId,
		Guid,
		'U',getdate(),'999999998'
		FROM TAtrPortfolioCombined
		WHERE [Guid]=@Guid	
    
		 Update TAtrPortfolioCombined     
		 SET Identifier=@Identifier,AtrRefPortfolioTypeId=@ATRRefPortfolioType,    
		 Active=@IsActive,AnnualReturn=@AnnualReturn,Volatility=@Volatility
		 WHERE [Guid]=@Guid AND AtrPortfolioId=@AtrPortfolioId   
    
END    
GO
