SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveQuoteSummaryForChart]        
@QuoteId bigint,          
@ShowWhich varchar(20)          
          
AS          
  
--Used to display summary chart for Quotation Analysis Report  
--Graphical Summary Of Quote Range  
          
BEGIN          
  
 --Identify quote product group  
 declare @RefProductGroupId bigint  
  
 select @RefProductGroupId = pg.RefProductGroupId  
 from tquote q  
 inner join trefproducttype pt on pt.refproducttypeid = q.refproducttypeid  
 inner join trefproductgroup pg on pg.refproductgroupid = pt.refproductgroupid  
 where q.QuoteId = @QuoteId  
  
 --Term Selection  
 if @RefProductGroupId = 1  
 Begin  
  
  SELECT           
  1 AS tag,          
  NULL AS parent,          
  NULL AS [QuoteSummaries!1!Dummy],          
  NULL AS [QuoteSummary!2!SumAssured],          
  NULL AS [QuoteSummary!3!SumAssured],          
  NULL AS [QuoteSummary!3!LifeCoverOnly],          
  NULL AS [QuoteSummary!3!CICCoverOnly],          
  NULL AS [QuoteSummary!3!LifeWithCIC]          
            
  UNION ALL          
            
  SELECT         
  2 AS tag,        
  1 AS parent,        
  NULL,        
  isnull(qt.CoverAmount,0),        
  NULL,        
  NULL,  
  NULL,        
  NULL  
  from TQuoteItem qi        
  join TQuoteDetail qd on qd.QuoteDetailId = qi.QuoteDetailId        
  join TQuoteTerm qt on qt.QuoteItemId = qi.QuoteItemId        
  where qi.quoteid = @QuoteId       
  and qt.coveramount > 0   
  and (@ShowWhich = 'all' or ( (@ShowWhich = 'marked' and qi.IsMarked = 1) or (@showWhich = 'unmarked' and qi.IsMarked = 0 ) ) )   
  Group BY qt.coveramount          
            
  UNION ALL          
  
  SELECT          
  3 AS tag,          
  2 AS parent,          
  NULL,          
  CONVERT(varchar(20),CoverAmount),          
  CONVERT(varchar(20),t.CoverAmount) + 'm1',           
  SUM(CASE t.CoverBasis WHEN 'Life Cover Only' THEN t.MinPremium END) AS LifeCoverOnly,          
  SUM(CASE t.CoverBasis WHEN 'Critical Illness / TPD Only' THEN t.MinPremium END) AS CICCoverOnly,          
  SUM(CASE t.CoverBasis WHEN 'Life Cover with Critical Illness / TPD' THEN t.MinPremium END) AS LifeWithCIC          
  FROM (          
   SELECT ISNULL(coverbasis,'Life Cover Only')'CoverBasis', CoverAmount, min(qt.premiumamount) AS MinPremium          
   FROM tquoteterm qt          
   JOIN tquoteitem qi ON qi.quoteitemid = qt.quoteitemid          
   JOIN tquotedetail qd ON qi.quotedetailid = qd.quotedetailid          
   WHERE qi.quoteid = @QuoteId          
   AND qt.coveramount> 0      
   and (@ShowWhich = 'all' or ( (@ShowWhich = 'marked' and qi.IsMarked = 1) or (@showWhich = 'unmarked' and qi.IsMarked = 0 ) ) )          
   GROUP BY coverbasis, CoverAmount          
  ) t          
  GROUP BY t.CoverAmount          
            
  UNION ALL          
            
  SELECT          
  3 AS tag,          
  2 AS parent,          
  NULL,          
  CONVERT(varchar(20),CoverAmount),          
  CONVERT(varchar(20),t.CoverAmount) + 'm2',            
  SUM(CASE t.CoverBasis WHEN 'Life Cover Only' THEN t.MaxPremium END) AS LifeCoverOnly,          
  SUM(CASE t.CoverBasis WHEN 'Critical Illness / TPD Only' THEN t.MaxPremium END) AS CICCoverOnly,          
  SUM(CASE t.CoverBasis WHEN 'Life Cover with Critical Illness / TPD' THEN t.MaxPremium END) AS LifeWithCIC          
  FROM (          
   SELECT ISNULL(coverbasis,'Life Cover Only')'CoverBasis', CoverAmount, MAX(qt.premiumamount) AS MaxPremium          
   FROM tquoteterm qt          
   JOIN tquoteitem qi ON qi.quoteitemid = qt.quoteitemid          
   JOIN tquotedetail qd ON qi.quotedetailid = qd.quotedetailid          
   WHERE qi.quoteid = @QuoteId         
  AND qt.coveramount> 0       
   and (@ShowWhich = 'all' or ( (@ShowWhich = 'marked' and qi.IsMarked = 1) or (@showWhich = 'unmarked' and qi.IsMarked = 0 ) ) )          
   GROUP BY coverbasis, CoverAmount          
  ) t          
  GROUP BY t.CoverAmount          
            
            
  ORDER BY [QuoteSummary!2!SumAssured], [QuoteSummary!3!SumAssured]          
            
  for xml explicit  
   
 End  
  
  
 --PHI Selection  
 if @RefProductGroupId = 2  
 Begin  
  
  SELECT           
  1 AS tag,          
  NULL AS parent,          
  NULL AS [QuoteSummaries!1!Dummy],          
  NULL AS [QuoteSummary!2!SumAssured],          
  NULL AS [QuoteSummary!3!SumAssured],  
  NULL AS [QuoteSummary!3!Phi]  
            
  UNION ALL          
            
  SELECT         
  2 AS tag,        
  1 AS parent,        
  NULL,        
  isnull(qphi.Benefit,0),        
  NULL,  
  NULL  
  From TQuoteItem qi  
  Join TQuotePhi qphi on qphi.QuoteItemId = qi.QuoteItemId        
  Where qi.quoteid = @QuoteId  
  And qphi.Benefit > 0    
  And (@ShowWhich = 'all' or ( (@ShowWhich = 'marked' and qi.IsMarked = 1) or (@showWhich = 'unmarked' and qi.IsMarked = 0 ) ) )          
  GROUP BY Benefit         
            
  UNION ALL          
  
  SELECT          
  3 AS tag,          
  2 AS parent,          
  NULL,          
  CONVERT(varchar(20),CoverAmount),          
  CONVERT(varchar(20),t.CoverAmount) + 'm1',  
  sum(t.MinPremium)  
  FROM (          
   Select Benefit As CoverAmount, min(qphi.premium) AS MinPremium  
   From TQuoteItem qi  
   Join TQuotePhi qphi on qphi.QuoteItemId = qi.QuoteItemId        
   Where qi.quoteid = @QuoteId  
   And qphi.Benefit > 0    
   And (@ShowWhich = 'all' or ( (@ShowWhich = 'marked' and qi.IsMarked = 1) or (@showWhich = 'unmarked' and qi.IsMarked = 0 ) ) )          
   GROUP BY Benefit          
  ) t          
  GROUP BY t.CoverAmount          
            
  UNION ALL          
            
  SELECT          
  3 AS tag,          
  2 AS parent,          
  NULL,          
  CONVERT(varchar(20),CoverAmount),          
  CONVERT(varchar(20),t.CoverAmount) + 'm2',  
  sum(t.MaxPremium)  
  FROM (          
   Select Benefit As CoverAmount, max(qphi.premium) AS MaxPremium  
   From TQuoteItem qi  
   Join TQuotePhi qphi on qphi.QuoteItemId = qi.QuoteItemId        
   Where qi.quoteid = @QuoteId  
   And qphi.Benefit > 0    
   And (@ShowWhich = 'all' or ( (@ShowWhich = 'marked' and qi.IsMarked = 1) or (@showWhich = 'unmarked' and qi.IsMarked = 0 ) ) )          
   GROUP BY Benefit          
  ) t          
  GROUP BY t.CoverAmount          
           
  ORDER BY [QuoteSummary!2!SumAssured], [QuoteSummary!3!SumAssured]          
            
  for xml explicit    
  
 End  
          
End
GO
