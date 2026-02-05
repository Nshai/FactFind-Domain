SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrPortfolio_Custom_Delete]  
@Guid uniqueidentifier  
  
  
  
AS  
  
DECLARE @PortfolioCount int  
DECLARE @TemplateGuid uniqueidentifier  
DECLARE @StampUser varchar(255)
  
SET @TemplateGuid=(SELECT AtrTemplateGuid FROM TAtrPortfolio WHERE Guid=@Guid)  

SELECT @StampUser='999999998'
  
  
BEGIN 
	--AtrAssetClassFund
	INSERT TAtrAssetClassFundAudit(
	AtrAssetClassGuid,
	FundId,
	FundTypeId,
	FromFeed,
	Recommended,
	IndigoClientId,
	ConcurrencyId,
	AtrAssetClassFundId,
	StampAction,
	StampDateTime,
	StampUser)

	SELECT AtrAssetClassGuid,
	A.FundId,
	A.FundTypeId,
	A.FromFeed,
	A.Recommended,
	A.IndigoClientId,
	A.ConcurrencyId,
	A.AtrAssetClassFundId,
	'D',getdate(),@StampUser
	FROM TAtrAssetClassFund A
	JOIN TAtrAssetClass B ON A.AtrAssetClassGuid=B.Guid	
	WHERE B.AtrPortfolioGuid=@Guid	


	DELETE A
	FROM TAtrAssetClassFund A
	JOIN TAtrAssetClass B ON A.AtrAssetClassGuid=B.Guid	
	WHERE B.AtrPortfolioGuid=@Guid

	INSERT TAtrAssetClassCombinedAudit(
	AtrAssetClassId,
	Identifier,
	Allocation,
	Ordering,
	AtrPortfolioGuid,
	ConcurrencyId,
	Guid,
	StampAction,
	StampDateTime,
	StampUser)

	SELECT AtrAssetClassId,
	Identifier,
	Allocation,
	Ordering,
	AtrPortfolioGuid,
	ConcurrencyId,
	Guid,
	'D',getdate(),@StampUser
	FROM TAtrAssetClassCombined 
	WHERE AtrPortfolioGuid=@Guid 

	DELETE FROM TAtrAssetClassCombined WHERE AtrPortfolioGuid=@Guid  

	INSERT TAtrAssetClassAudit(	
	Identifier,
	Allocation,
	Ordering,
	AtrRefAssetClassId,
	AtrPortfolioGuid,
	Guid,
	ConcurrencyId,
	AtrAssetClassId,
	StampAction,
	StampDateTime,
	StampUser)

	SELECT 
	Identifier,
	Allocation,
	Ordering,
	AtrRefAssetClassId,
	AtrPortfolioGuid,
	Guid,
	ConcurrencyId,
	AtrAssetClassId,
	'D',getdate(),@StampUser
	FROM TAtrAssetClass WHERE AtrPortfolioGuid=@Guid  
  
	DELETE FROM TAtrAssetClass WHERE AtrPortfolioGuid=@Guid  

	INSERT TAtrMatrixAudit(	
	AtrRefMatrixDurationId,
	ImmediateIncome,
	IndigoClientId,
	RiskProfileGuid,
	AtrPortfolioGuid,
	AtrTemplateGuid,
	AtrMatrixTermGuid,
	Guid,
	ConcurrencyId,
	AtrMatrixId,
	StampAction,
	StampDateTime,
	StampUser)
	SELECT AtrRefMatrixDurationId,
	ImmediateIncome,
	IndigoClientId,
	RiskProfileGuid,
	AtrPortfolioGuid,
	AtrTemplateGuid,
	AtrMatrixTermGuid,
	Guid,
	ConcurrencyId,
	AtrMatrixId,
	'D',getdate(),@StampUser
	FROM TAtrMatrix
	WHERE AtrPortfolioGuid=@Guid

	DELETE FROM TAtrMatrix WHERE AtrPortfolioGuid=@Guid

	INSERT TAtrMatrixCombinedAudit(
	AtrMatrixId,
	ImmediateIncome,
	IndigoClientId,
	IndigoClientGuid,
	RiskProfileGuid,
	AtrPortfolioGuid,
	AtrTemplateGuid,
	AtrMatrixTermGuid,
	Guid,
	ConcurrencyId,
	StampAction,
	StampDateTime,
	StampUser)

	SELECT AtrMatrixId,
	ImmediateIncome,
	IndigoClientId,
	IndigoClientGuid,
	RiskProfileGuid,
	AtrPortfolioGuid,
	AtrTemplateGuid,
	AtrMatrixTermGuid,
	Guid,
	ConcurrencyId,
	'D',getdate(),@StampUser
	FROM TAtrMatrixCombined
	WHERE AtrPortfolioGuid=@Guid

	DELETE FROM TAtrMatrixCombined
	WHERE AtrPortfolioGuid=@Guid

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
	'D',getdate(),@StampUser
	FROM TAtrPortfolioCombined WHERE Guid=@Guid 
   
	DELETE FROM TAtrPortfolioCombined WHERE Guid=@Guid   
	
  
	DELETE FROM TAtrPortfolio WHERE Guid=@Guid  

	
  
	 SET @PortfolioCount=(SELECT Count(AtrPortfolioId) FROM TAtrPortfolio WHERE AtrTemplateGuid=@TemplateGuid)  
	  
	 IF ISNULL(@PortfolioCount,0)=0  
	 BEGIN  
	   UPDATE TAtrTemplate SET HasModels=0 WHERE Guid=@TemplateGuid  
	  
	   UPDATE TAtrTemplateCombined SET HasModels=0 WHERE Guid=@TemplateGuid  
	 END  
  
END  
  
GO
