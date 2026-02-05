SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrPortfolio_Custom_Create]    
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
    
DECLARE @AtrPortfolioId bigint    
    
    
    
BEGIN    
 INSERT TAtrPortfolio(    
 Identifier,    
 AtrRefPortfolioTypeId,    
 Active,    
 AnnualReturn,    
 Volatility,    
 AtrTemplateGuid,    
 IndigoClientId,    
 Guid,    
 ConcurrencyId)    
    
 SELECT @Identifier, @ATRRefPortfolioType, @IsActive, @AnnualReturn, @Volatility,@AtrTemplate,    
 @IndigoClientId,@Guid,1    
    
 SELECT @AtrPortfolioId=SCOPE_IDENTITY()    
    
 INSERT TAtrPortfolioCombined(     
 Guid,    
 AtrPortfolioId,    
 Identifier,    
 AtrRefPortfolioTypeId,    
 Active,    
 AnnualReturn,    
 Volatility,    
 AtrTemplateGuid,    
 IndigoClientId,    
 IndigoClientGuid,    
 ConcurrencyId)    
    
 SELECT @Guid,@AtrPortfolioId,@Identifier, @ATRRefPortfolioType, @IsActive, @AnnualReturn, @Volatility,@AtrTemplate,    
 @IndigoClientId,@TenantGuid,1   

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

	SELECT AtrPortfolioId,
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
	'C',getdate(),'999999998'
	FROM TAtrPortfolioCombined
	WHERE [Guid]=@Guid
    
    
END    
    
    
GO
