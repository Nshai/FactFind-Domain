SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomSearchFunds]
@FundName varchar(255),
@ProviderId bigint = 0,
@IndigoClientId bigint = 0, 
@FundTypeId bigint = 0,
@ExactNameMatch bit = 0,
@CategoryId bigint = 0
AS

if (@FundName <> '' and @ExactNameMatch = 0)
	set @FundName = '%' + @FundName + '%'

If object_Id('tempdb..#IndigoClients') is not null
	Drop Table #IndigoClients

Create Table #IndigoClients (IndigoClientID bigint)

Insert into #IndigoClients
Select Null
Union 
select indigoclientid 
from administration..tindigoclient i1 
where i1.indigoclientid = @IndigoClientId
Union
select distinct networkid	
from administration..tindigoclient i1 
where i1.indigoclientid = @IndigoClientId And networkid is not null




SELECT 
	1 AS TAG,  
	NULL AS PARENT,  
	f.NonFeedFundId AS [Fund!1!FundId],  
	f.FundTypeId AS [Fund!1!FundTypeId],  
	f.FundName AS [Fund!1!FundName],  
	f.CompanyId as [Fund!1!ProviderId],
	f.CompanyName as [Fund!1!ProviderName],
	f.FundTypeName as [Fund!1!FundTypeDescription],
	f.CategoryId as [Fund!1!CategoryId],
	f.CategoryName as [Fund!1!CategoryName]
FROM 
	TNonFeedFund f
WHERE 
	(f.FundName like @FundName OR @FundName = '')
	AND (f.CompanyId = @ProviderId OR @ProviderId = 0)
	AND (f.CategoryId = @CategoryId OR @CategoryId = 0)
	-- 12 may 2009
	-- replaced
	/* AND (f.IndigoClientId is NULL or f.IndigoClientId in 
		(
		select indigoclientid from administration..tindigoclient i1 where i1.indigoclientid = @IndigoClientId
		union
		select networkid from administration..tindigoclient i1 where i1.indigoclientid = @IndigoClientId
		) OR @IndigoClientId = 0
	) */
	-- with
	And F.IndigoClientId In (Select IndigoClientId From #IndigoClients)

AND (f.FundTypeId = @FundTypeId OR @FundTypeId = 0)

ORDER BY [Fund!1!FundName]

FOR XML EXPLICIT

GO
