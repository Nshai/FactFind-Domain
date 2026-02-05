SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomScalarAtrPortfolio]
	@AtrPortfolioGuid uniqueidentifier
AS
	SELECT
		Identifier
	FROM
		TAtrPortfolioCombined
	WHERE
		Guid = @AtrPortfolioGuid
GO
