SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomGetQuoteDetailsForReport] 
				@QuoteId bigint,      
				@ShowWhich varchar(20)  

AS 
 
 /*
--test  
declare @QuoteId Bigint, @ShowWhich varchar(20)  
select @QuoteId = 38635, @ShowWhich = 'all'  
*/

--Identify quote product group
DECLARE @RefProductGroupId BIGINT,
	@RefApplicationId BIGINT,
	@RefProductGroupIdPensions BIGINT, 
	@RefProductGroupIdBonds BIGINT,
	@RefProductGroupIdAnnuities BIGINT,
	@RefApplicationIdAssureweb BIGINT
 
 SELECT @RefApplicationIdAssureweb = 1
 SELECT @RefProductGroupIdPensions = 4
 SELECT @RefProductGroupIdBonds = 5
 SELECT @RefProductGroupIdAnnuities = 6

SELECT 
	@RefProductGroupId = pg.RefProductGroupId,
	@RefApplicationId = q.RefApplicationId
FROM
	tquote q
INNER JOIN 
	trefproducttype pt on pt.refproducttypeid = q.refproducttypeid
INNER JOIN 
	trefproductgroup pg on pg.refproductgroupid = pt.refproductgroupid
WHERE
	q.QuoteId = @QuoteId

--Term Selection
IF @RefProductGroupId = 1
BEGIN
	SELECT
		 ProductGroup = 'Term',
		 Replace(qi.ProductDescription, '&amp;', '&') As ProductDescription,
		 Replace(qi.WarningMessage, '&amp;amp;', '&') As WarningMessage,
		 qt.PremiumAmount,
		 qt.PremiumType,
		 qt.CoverAmount,
		 CASE 
			WHEN ISNULL(qt1.IncludeTerminalIllness, '') = '' THEN 
				CASE 
					WHEN qt.TerminalIllness = 1 THEN 'Yes'
					ELSE 'No'
				END
			WHEN qt1.IncludeTerminalIllness = 1 THEN 'Yes'
			ELSE 'No'
		 END as TerminalIllness,	 
		 qi.CommissionAmount
	FROM 
		TQuote q with(nolock)
	LEFT JOIN 
		TTermQuote qt1 with(nolock) on qt1.QuoteId = q.QuoteId
	INNER JOIN 
		TQuoteItem qi with(nolock) On q.QuoteId = qi.QuoteId
	INNER JOIN 
		TQuoteTerm qt with(nolock) On qt.QuoteItemId = qi.QuoteItemId
	WHERE q.QuoteId = @QuoteId
		AND (@ShowWhich = 'all' 
			OR ((@ShowWhich = 'marked' AND qi.IsMarked = 1) 
				OR (@showWhich = 'unmarked' and qi.IsMarked = 0 )))      
	ORDER BY 
		qt.PremiumAmount ASC, ProductDescription ASC
END

--PHI Selection
IF @RefProductGroupId = 2
BEGIN
	SELECT
		 ProductGroup = 'PHI',
		 Replace(qi.ProductDescription, '&amp;', '&') As ProductDescription,
		 Replace(qi.WarningMessage, '&amp;amp;', '&') As WarningMessage,
		 qphi.Premium As PremiumAmount,
 		 qphi.Benefit As BenefitAmount,
		 qi.CommissionAmount
	FROM 
		TQuote q with(nolock)
	INNER JOIN 
		TQuoteItem qi with(nolock) On q.QuoteId = qi.QuoteId
	INNER JOIN 
		TQuotePHI qphi with(nolock) On qphi.QuoteItemId = qi.QuoteItemId
	WHERE 
		q.QuoteId = @QuoteId
		AND (@ShowWhich = 'all' 
				OR ((@ShowWhich = 'marked' and qi.IsMarked = 1) OR (@showWhich = 'unmarked' and qi.IsMarked = 0 )))
	ORDER BY  
		qphi.Premium ASC, ProductDescription ASC
END

IF @RefProductGroupId = @RefProductGroupIdPensions AND @RefApplicationId = @RefApplicationIdAssureweb BEGIN

	SELECT
		 ProductGroup = 'Pension',
		 Replace(QR.ProductDescription, '&amp;', '&') AS ProductDescription,
		 QuoteResultInternal.value('(//ApplicantPremiumAmount/text())[1]','money') As PremiumAmount,
		 QuoteResultInternal.value('(//RetirementFundAmount/text())[1]','money') As RetirementFundAmount
	FROM 
		TQuote Q WITH(NOLOCK)
		JOIN TQuoteResult QR WITH(NOLOCK) ON QR.QuoteId = Q.QuoteId
	WHERE 
		q.QuoteId = @QuoteId
		AND (@ShowWhich = 'all'
				OR ((@ShowWhich = 'marked' and QR.IsMarked = 1) OR (@showWhich = 'unmarked' and QR.IsMarked = 0 )))
	ORDER BY  
		QuoteResultInternal.value('(//ApplicantPremiumAmount/text())[1]','money') ASC, 
		ProductDescription ASC

END

IF @RefProductGroupId = @RefProductGroupIdBonds AND @RefApplicationId = @RefApplicationIdAssureweb BEGIN

	SELECT
		 ProductGroup = 'Bonds',
		 Replace(QR.ProductDescription, '&amp;', '&') AS ProductDescription,
		 QuoteResultInternal.value('(//InvestmentAmount/text())[1]','money') As InvestmentAmount,
		 QuoteResultInternal.value('(//CashInAmount/text())[1]','money') As CashInAmount
	FROM 
		TQuote Q WITH(NOLOCK)
		JOIN TQuoteResult QR WITH(NOLOCK) ON QR.QuoteId = Q.QuoteId
	WHERE 
		q.QuoteId = @QuoteId
		AND (@ShowWhich = 'all'
				OR ((@ShowWhich = 'marked' and QR.IsMarked = 1) OR (@showWhich = 'unmarked' and QR.IsMarked = 0 )))
	ORDER BY  
		QuoteResultInternal.value('(//CashInAmount/text())[1]','money') ASC, 
		ProductDescription ASC

END

IF @RefProductGroupId = @RefProductGroupIdAnnuities AND @RefApplicationId = @RefApplicationIdAssureweb BEGIN

	SELECT
		 ProductGroup = 'Annuities',
		 Replace(QR.ProductDescription, '&amp;', '&') AS ProductDescription,
		 QuoteResultInternal.value('(//AnnualAnnuityAmount/text())[1]','money') As AnnualAnnuityAmount,
		 QuoteResultInternal.value('(//PurchaseAmount/text())[1]','money') As PurchaseAmount
	FROM 
		TQuote Q WITH(NOLOCK)
		JOIN TQuoteResult QR WITH(NOLOCK) ON QR.QuoteId = Q.QuoteId
	WHERE 
		q.QuoteId = @QuoteId
		AND (@ShowWhich = 'all'
				OR ((@ShowWhich = 'marked' and QR.IsMarked = 1) OR (@showWhich = 'unmarked' and QR.IsMarked = 0 )))
	ORDER BY  
		QuoteResultInternal.value('(//AnnualAnnuityAmount/text())[1]','money') ASC, 
		ProductDescription ASC

END

GO
