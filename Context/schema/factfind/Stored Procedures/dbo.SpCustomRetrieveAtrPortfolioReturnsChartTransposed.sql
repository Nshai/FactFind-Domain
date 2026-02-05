SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveAtrPortfolioReturnsChartTransposed]
	@AtrPortfolioGuid uniqueidentifier
AS	
	WITH AllReturns (Term, Low, Mid, Upp)
	AS
	(
	SELECT
		T.Term AS Term,		
		PR.LowerReturn,
		PR.MidReturn,
		PR.UpperReturn
	FROM
		TAtrPortfolioReturnCombined PR
		JOIN TAtrRefPortfolioTerm T ON T.AtrRefPortfolioTermId = PR.AtrRefPortfolioTermId
		JOIN TAtrPortfolioCombined P ON P.Guid = PR.AtrPortfolioGuid		
	WHERE	
		P.Guid = @AtrPortfolioGuid
	),
	Low (Term, Ret)
	AS
	(
	SELECT
		Term,
		Low
	FROM
		AllReturns
	),
	Mid (Term, Ret)
	AS
	(
	SELECT
		Term,
		Mid
	FROM
		AllReturns
	),
	Upp (Term, Ret)
	AS
	(
	SELECT
		Term,
		Upp
	FROM
		AllReturns
	)	
	SELECT
		'Lower' AS [Range], LowPivot.*
	FROM
		Low
	PIVOT (		
		MIN(Ret)
		FOR Term IN ([1],[3],[5],[10])
	) AS LowPivot
	
	UNION ALL

	SELECT
		'Mid' AS [Range], MidPivot.*
	FROM
		Mid
	PIVOT (		
		MIN(Ret)
		FOR Term IN ([1],[3],[5],[10])
	) AS MidPivot

	UNION ALL

	SELECT
		'Upper' AS [Range], UppPivot.*
	FROM
		Upp
	PIVOT (		
		MIN(Ret)
		FOR Term IN ([1],[3],[5],[10])
	) AS UppPivot

	FOR XML RAW
GO
