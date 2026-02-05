SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveAtrPortfolioReturnsChart]
	@AtrPortfolioGuid uniqueidentifier
AS	
	SELECT
		T.Identifier AS Term,
		PR.LowerReturn,
		PR.MidReturn,
		PR.UpperReturn
	FROM
		TAtrPortfolioReturnCombined PR
		JOIN TAtrRefPortfolioTerm T ON T.AtrRefPortfolioTermId = PR.AtrRefPortfolioTermId
		JOIN TAtrPortfolioCombined P ON P.Guid = PR.AtrPortfolioGuid		
	WHERE	
		P.Guid = @AtrPortfolioGuid	
	FOR XML RAW
GO
