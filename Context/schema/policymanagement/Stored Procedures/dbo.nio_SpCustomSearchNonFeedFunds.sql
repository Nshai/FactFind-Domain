SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_SpCustomSearchNonFeedFunds](
	@FundName varchar(255) = '',
	@ProviderId bigint = 0,
	@TenantId bigint = 0, 
	@FundTypeId bigint = 0,
	@ExactNameMatch bit = 0,
	@CategoryId bigint = 0, 
	@EntityCategoryId int = 0
)
AS        

if (@FundName <> '' and @ExactNameMatch = 0)
	set @FundName = '%' + @FundName + '%'

If object_Id('tempdb..#IndigoClients') is not null
	Drop Table #IndigoClients

Create Table #IndigoClients (IndigoClientID bigint)

Insert into #IndigoClients
	select indigoclientid 
		from administration..tindigoclient i1 
	where i1.indigoclientid = @TenantId
	Union
	select distinct networkid	
		from administration..tindigoclient i1 
	where i1.indigoclientid = @TenantId And networkid is not null


SELECT Top 250
	f.NonFeedFundId AS [NonFeedFundId],  
	f.FundTypeId AS [FundTypeId], 
	f.FundTypeName as [FundTypeName],
	f.FundName AS [FundName],  
	f.CompanyId as [CompanyId],	
	f.CompanyName as [CompanyName],	
	f.CategoryId as [CategoryId],
	f.CategoryName as [CategoryName],
	f.Sedol AS [Sedol],
	f.MexId AS [MexId],
	f.IndigoClientId AS [IndigoClientId],
	f.CurrentPrice AS [CurrentPrice],
	f.PriceDate AS [PriceDate],
	f.PriceUpdatedByUser AS [PriceUpdatedByUser],
	f.LastUpdatedByPlan AS [LastUpdatedByPlan],
	f.RefProdProviderId AS [PlanProvider],
	f.IsClosed AS IsClosed,
	f.IsArchived AS IsArchived,
    f.IncomeYield AS IncomeYield,
	f.ConcurrencyId AS [ConcurrencyId],
	IsNull(ec.Name,'') AS [EntityCategoryName],
	f.ProviderFundCode,
	f.ISIN
FROM 
	TNonFeedFund f

	--search entity category
Left join 
	(Select a.EntityId, a.CategoryId, b.Name
	From Fund2..TEntityCategory a
	Inner Join Fund2..TCategory b on a.CategoryId = b.CategoryId
	Inner Join #IndigoClients ic on ic.IndigoClientID = a.TenantId
	Where a.EntityType = 'ManualFund'
	) ec on ec.EntityId = f.NonFeedFundId
INNER JOIN #IndigoClients ic on ic.IndigoClientID = f.IndigoClientId
WHERE 
	(f.FundName like @FundName OR @FundName = '')
	AND (f.CompanyId = @ProviderId OR @ProviderId = 0)
	AND (f.CategoryId = @CategoryId OR @CategoryId = 0)
	AND (f.FundTypeId = @FundTypeId OR @FundTypeId = 0)
	AND f.IsArchived = 0 -- Select only the Non-Archived records (SF Case 73409)
	AND @EntityCategoryId = 0 OR ec.CategoryId = @EntityCategoryId
	
ORDER BY [FundName]        


GO
