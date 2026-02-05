SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_SpCustomSearchNonFeedFundsToGetColumnList]

as      
      
SELECT  
 0 AS [NonFeedFundId],    
 0 AS [FundTypeId],   
 '' as [FundTypeName],  
 '' AS [FundName],    
 0 as [CompanyId],   
 '' as [CompanyName],   
 0 as [CategoryId],  
 '' as [CategoryName],  
 '' AS [Sedol],
 '' AS [MexId],
 0 AS [IndigoClientId],
 0 AS [CurrentPrice],
 '' AS [PriceDate],
 '' AS [PriceUpdatedByUser],
 '' AS [LastUpdatedByPlan],
 0 AS [PlanProvider],
 0 AS IsClosed,
 0 AS IsArchived,
 0 AS IncomeYield,
 0 AS [ConcurrencyId],
 '' AS [EntityCategoryName]
GO
