SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveQuoteRangeForChart]    
@QuoteId bigint,        
@ShowWhich varchar(20)        
        
As        
  
--Used to display product chart for Quotation Analysis Report  
--Product Quote Graph  
  
        
Begin        
        
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
 if @RefProductGroupId = 1  
 Begin  
  
  SELECT         
  1 AS tag,        
  NULL AS parent,        
  NULL AS [QuoteSummaries!1!Dummy],        
  NULL AS [QuoteSummary!2!YAxis],        
  NULL AS [QuoteSummary!3!YAxis],        
  NULL AS [QuoteSummary!3!XAxis]        
          
  UNION ALL        
          
  SELECT         
  2 AS tag,        
  1 AS parent,        
  NULL,        
  isnull(qt.CoverAmount,0),        
  NULL,        
  NULL  
  from TQuoteItem qi        
  join TQuoteDetail qd on qd.QuoteDetailId = qi.QuoteDetailId        
  join TQuoteTerm qt on qt.QuoteItemId = qi.QuoteItemId        
  where qi.quoteid = @QuoteId       
  and qt.coveramount > 0   
  Group BY qt.coveramount  
          
  UNION ALL        
          
  select         
  3 as tag,        
  2 as parent,        
  null,        
  --qd.SumAssuredAmount,        
  --qd.SumAssuredAmount,        
  qt.CoverAmount,      
  qt.CoverAmount,      
  qt.PremiumAmount        
          
  from TQuoteItem qi        
  join TQuoteDetail qd on qd.QuoteDetailId = qi.QuoteDetailId        
  join TQuoteTerm qt on qt.QuoteItemId = qi.QuoteItemId        
  where qi.quoteid = @QuoteId       
  and qt.coveramount > 0     
  and (@ShowWhich = 'all' or ( (@ShowWhich = 'marked' and qi.IsMarked = 1) or (@showWhich = 'unmarked' and qi.IsMarked = 0 ) ) )        
  order by [QuoteSummary!2!YAxis], [QuoteSummary!3!YAxis],[QuoteSummary!3!XAxis]        
          
  for xml explicit  
    
 End  
  
  
 --PHI Selection  
 if @RefProductGroupId = 2  
 Begin  
  
  SELECT         
  1 AS tag,        
  NULL AS parent,        
  NULL AS [QuoteSummaries!1!Dummy],               
  NULL AS [QuoteSummary!2!YAxis],        
  NULL AS [QuoteSummary!3!YAxis],        
  NULL AS [QuoteSummary!3!XAxis]         
          
  UNION ALL        
          
  SELECT         
  2 AS tag,        
  1 AS parent,        
  NULL,        
  isnull(qphi.Benefit,0),        
  NULL,        
  NULL  
  from TQuoteItem qi        
  join TQuotePhi qphi on qphi.QuoteItemId = qi.QuoteItemId        
  where qi.quoteid = @QuoteId       
  and qphi.Benefit > 0     
  Group BY qphi.Benefit  
          
  UNION ALL        
          
  select         
  3 as tag,        
  2 as parent,        
  null,        
  qphi.Benefit,      
  qphi.Benefit,      
  qphi.Premium  
          
  from TQuoteItem qi        
  join TQuotePhi qphi on qphi.QuoteItemId = qi.QuoteItemId        
  where qi.quoteid = @QuoteId       
  and qphi.Benefit > 0     
  and (@ShowWhich = 'all' or ( (@ShowWhich = 'marked' and qi.IsMarked = 1) or (@showWhich = 'unmarked' and qi.IsMarked = 0 ) ) )     
       
  order by [QuoteSummary!2!YAxis], [QuoteSummary!3!YAxis],[QuoteSummary!3!XAxis]        
          
  for xml explicit  
    
 End    
 
	-- Assureweb Annuities  
	IF @RefProductGroupId = @RefProductGroupIdAnnuities AND @RefApplicationId = @RefApplicationIdAssureweb BEGIN

		SELECT         
			1 AS TAG,        
			NULL AS PARENT,        
			NULL AS [QuoteSummaries!1!Dummy],               
			NULL AS [QuoteSummary!2!YAxis],        
			NULL AS [QuoteSummary!3!YAxis],        
			NULL AS [QuoteSummary!3!XAxis]         
		  
		UNION ALL        
		  
		SELECT         
			2 AS TAG,        
			1 AS PARENT,        
			NULL,  
			ISNULL(PurchaseAmount,0),        
			NULL,        
			NULL  
		FROM 
			( -- Have to do this inner query because "XML methods are not allowed in a GROUP BY clause."
			SELECT
				QuoteId AS QuoteId,
				QuoteResultInternal.value('(//PurchaseAmount/text())[1]','money') AS PurchaseAmount
			FROM
				TQuoteResult
			WHERE
				QuoteId = @QuoteId
			) QR       
		WHERE 
			QR.QuoteId = @QuoteId       
			AND QR.PurchaseAmount > 0     
		GROUP BY 
			QR.PurchaseAmount  
		  
		UNION ALL        
		  
		SELECT         
			3 AS TAG,        
			2 AS PARENT,        
			NULL,        
			QR.QuoteResultInternal.value('(//PurchaseAmount/text())[1]','money'),      
			QR.QuoteResultInternal.value('(//PurchaseAmount/text())[1]','money'),      
			QR.QuoteResultInternal.value('(//AnnualAnnuityAmount/text())[1]','money') 
		FROM 
			TQuoteResult QR       
		WHERE 
			QR.QuoteId = @QuoteId       
			AND QR.QuoteResultInternal.value('(//PurchaseAmount/text())[1]','money') > 0 
			AND (@ShowWhich = 'all' or ( (@ShowWhich = 'marked' and QR.IsMarked = 1) or (@showWhich = 'unmarked' and QR.IsMarked = 0 ) ) )     
		ORDER BY 
			[QuoteSummary!2!YAxis], [QuoteSummary!3!YAxis],[QuoteSummary!3!XAxis]        
		  
		FOR XML EXPLICIT  

	END  
	
	-- Assureweb Bonds  
	IF @RefProductGroupId = @RefProductGroupIdBonds AND @RefApplicationId = @RefApplicationIdAssureweb BEGIN

		SELECT         
			1 AS TAG,        
			NULL AS PARENT,        
			NULL AS [QuoteSummaries!1!Dummy],               
			NULL AS [QuoteSummary!2!YAxis],        
			NULL AS [QuoteSummary!3!YAxis],        
			NULL AS [QuoteSummary!3!XAxis]         
		  
		UNION ALL        
		  
		SELECT         
			2 AS TAG,        
			1 AS PARENT,        
			NULL,  
			ISNULL(InvestmentAmount,0),        
			NULL,        
			NULL  
		FROM 
			( -- Have to do this inner query because "XML methods are not allowed in a GROUP BY clause."
			SELECT
				QuoteId AS QuoteId,
				QuoteResultInternal.value('(//InvestmentAmount/text())[1]','money') AS InvestmentAmount
			FROM
				TQuoteResult
			WHERE
				QuoteId = @QuoteId
			) QR       
		WHERE 
			QR.QuoteId = @QuoteId       
			AND QR.InvestmentAmount > 0     
		GROUP BY 
			QR.InvestmentAmount  
		  
		UNION ALL        
		  
		SELECT         
			3 AS TAG,        
			2 AS PARENT,        
			NULL,        
			QR.QuoteResultInternal.value('(//InvestmentAmount/text())[1]','money'),      
			QR.QuoteResultInternal.value('(//InvestmentAmount/text())[1]','money'),      
			QR.QuoteResultInternal.value('(//CashInAmount/text())[1]','money') 
		FROM 
			TQuoteResult QR       
		WHERE 
			QR.QuoteId = @QuoteId       
			AND QR.QuoteResultInternal.value('(//InvestmentAmount/text())[1]','money') > 0 
			AND (@ShowWhich = 'all' or ( (@ShowWhich = 'marked' and QR.IsMarked = 1) or (@showWhich = 'unmarked' and QR.IsMarked = 0 ) ) )     
		ORDER BY 
			[QuoteSummary!2!YAxis], [QuoteSummary!3!YAxis],[QuoteSummary!3!XAxis]        
		  
		FOR XML EXPLICIT  

	END  	
	
	-- Assureweb Pensions  
	IF @RefProductGroupId = @RefProductGroupIdPensions AND @RefApplicationId = @RefApplicationIdAssureweb BEGIN

		SELECT         
			1 AS TAG,        
			NULL AS PARENT,        
			NULL AS [QuoteSummaries!1!Dummy],               
			NULL AS [QuoteSummary!2!YAxis],        
			NULL AS [QuoteSummary!3!YAxis],        
			NULL AS [QuoteSummary!3!XAxis]         
		  
		UNION ALL        
		  
		SELECT         
			2 AS TAG,        
			1 AS PARENT,        
			NULL,  
			ISNULL(InvestmentAmount,0),        
			NULL,        
			NULL  
		FROM 
			( -- Have to do this inner query because "XML methods are not allowed in a GROUP BY clause."
			SELECT
				QuoteId AS QuoteId,
				QuoteResultInternal.value('(//RetirementFundAmount/text())[1]','money') AS InvestmentAmount
			FROM
				TQuoteResult
			WHERE
				QuoteId = @QuoteId
			) QR       
		WHERE 
			QR.QuoteId = @QuoteId       
			AND QR.InvestmentAmount > 0     
		GROUP BY 
			QR.InvestmentAmount  
		  
		UNION ALL        
		  
		SELECT         
			3 AS TAG,        
			2 AS PARENT,        
			NULL,        
			QR.QuoteResultInternal.value('(//RetirementFundAmount/text())[1]','money'),      
			QR.QuoteResultInternal.value('(//RetirementFundAmount/text())[1]','money'),      
			QR.QuoteResultInternal.value('(//ApplicantPremiumAmount/text())[1]','money') 
		FROM 
			TQuoteResult QR       
		WHERE 
			QR.QuoteId = @QuoteId       
			AND QR.QuoteResultInternal.value('(//RetirementFundAmount/text())[1]','money') > 0 
			AND (@ShowWhich = 'all' or ( (@ShowWhich = 'marked' and QR.IsMarked = 1) or (@showWhich = 'unmarked' and QR.IsMarked = 0 ) ) )     
		ORDER BY 
			[QuoteSummary!2!YAxis], [QuoteSummary!3!YAxis],[QuoteSummary!3!XAxis]        
		  
		FOR XML EXPLICIT  

	END  	
        
END
GO
